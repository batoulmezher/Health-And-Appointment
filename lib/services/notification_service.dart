// lib/services/notification_service.dart
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:health_appointment_app/api/api.dart';
import 'package:health_appointment_app/controller/notifications_controller.dart';
import 'package:health_appointment_app/models/notification_model.dart';

class NotificationService {
  static final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static String? _cachedFcmToken;


  final Dio _dio = Api().dio;
  final GetStorage _storage = GetStorage();

  String? _getAuthToken() => _storage.read('token');

  Future<List<NotificationModel>?> getNotifications() async {
    try {
      final token = _getAuthToken();
      if (token == null || token.isEmpty) return null;

      final response = await _dio.get(
        '/api/v1/notifications',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        final json = response.data;
        if (json['status'] == 'success' && json['data'] is List) {
          final List<dynamic> list = json['data'];
          return list.map((item) => NotificationModel.fromJson(item)).toList();
        }
      }
      return null;
    } catch (e) {
      print('❌ Get notifications error: $e');
      return null;
    }
  }

  Future<bool> markAsRead(int id) async {
    try {
      final token = _getAuthToken();
      if (token == null || token.isEmpty) return false;

      final response = await _dio.post(
        '/api/v1/notifications/$id/read',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('❌ Mark as read error: $e');
      return false;
    }
  }

  Future<bool> markAllAsRead() async {
    try {
      final token = _getAuthToken();
      if (token == null || token.isEmpty) return false;

      final response = await _dio.post(
        '/api/v1/notifications/read-all',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('❌ Mark all as read error: $e');
      return false;
    }
  }


  static Future<void> init() async {
    try {
      print('🔔 Initializing NotificationService...');

      const AndroidInitializationSettings androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      const DarwinInitializationSettings iosSettings =
          DarwinInitializationSettings();
      const InitializationSettings settings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );
      await _localNotifications.initialize(settings: settings);
      print('✅ Local notifications initialized');

      NotificationSettings permissions = await _fcm.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      print('🔔 Permission status: ${permissions.authorizationStatus}');

      _cachedFcmToken = await _fcm.getToken();
      print('✅ FCM Token: $_cachedFcmToken');

      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
      print('✅ Background handler registered');

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        _handleForegroundMessage(message);
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        _handleMessageOpenedApp(message);
      });

      RemoteMessage? initialMessage = await _fcm.getInitialMessage();
      if (initialMessage != null) {
        print('📩 تم فتح التطبيق من إشعار (مغلق)');
        _handleMessageOpenedApp(initialMessage);
      }

      print('✅ NotificationService initialized successfully');
    } catch (e) {
      print('❌ NotificationService init error: $e');
    }
  }



static Future<void> saveTokenToBackend(int userId) async {
  try {
    final authToken = GetStorage().read('token');
    if (authToken == null || authToken.isEmpty) {
      print('⚠️ No auth token, skipping FCM token save');
      return;
    }

    String? token = _cachedFcmToken ?? await _fcm.getToken();
    if (token == null) {
      print('⚠️ No FCM token available');
      return;
    }

    final dio = Api().dio;
    final response = await dio.post(
      '/api/v1/users/$userId/fcm-token',
      options: Options(headers: {'Authorization': 'Bearer $authToken'}),
      data: {'fcm_token': token},
    );
    
    if (response.statusCode == 200 || response.statusCode == 201) {
      print('✅ FCM Token saved to backend successfully');
    } else {
      print('⚠️ Failed to save FCM token: ${response.data}');
    }
  } catch (e) {
    print('❌ Failed to save FCM token: $e');
  }
}

  static void _handleForegroundMessage(RemoteMessage message) {
    print('📩 Foreground message: ${message.messageId}');
    _showLocalNotification(message);
    _updateNotificationsList(message);
  }

  static void _handleMessageOpenedApp(RemoteMessage message) {
    print('👆 Message opened: ${message.messageId}');
    Get.toNamed('/notifications');
  }

  static Future<void> _showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'health_app_channel',
      'قناة الإشعارات',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails details =
        NotificationDetails(android: androidDetails);

    await _localNotifications.show(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: message.notification?.title ?? 'إشعار جديد',
      body: message.notification?.body ?? '',
      notificationDetails: details,
      payload: message.data['id']?.toString(),
    );
  }

  static void _updateNotificationsList(RemoteMessage message) {
    try {
      final controller = Get.find<NotificationsController>();
      final notification = NotificationModel(
        id: int.tryParse(message.data['id'] ?? '0') ??
            DateTime.now().millisecondsSinceEpoch,
        title: message.notification?.title ?? 'إشعار جديد',
        content: message.notification?.body ?? '',
        type: message.data['type'] ?? 'general',
        isRead: false,
        timeAgo: 'الآن',
        createdAt: DateTime.now(),
      );
      controller.addNotification(notification);
    } catch (e) {
      print('❌ Failed to update notifications list: $e');
    }
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('📩 Background message: ${message.messageId}');

  const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const DarwinInitializationSettings iosSettings =
      DarwinInitializationSettings();
  const InitializationSettings settings = InitializationSettings(
    android: androidSettings,
    iOS: iosSettings,
  );
  final FlutterLocalNotificationsPlugin localNotifications =
      FlutterLocalNotificationsPlugin();
  await localNotifications.initialize(settings: settings);

  const AndroidNotificationDetails androidDetails =
      AndroidNotificationDetails(
    'health_app_channel',
    'قناة الإشعارات',
    importance: Importance.max,
    priority: Priority.high,
  );
  const NotificationDetails details =
      NotificationDetails(android: androidDetails);

  await localNotifications.show(
    id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
    title: message.notification?.title ?? 'إشعار جديد',
    body: message.notification?.body ?? '',
    notificationDetails: details,
  );
}