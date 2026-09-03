// lib/services/local_notification_service.dart
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
      AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
      DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings();
      InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    await _plugin.initialize(settings: settings);
  }

  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? payload,
    String? soundName, 
    bool useSystemAlarm = false, 
  }) async {
    AndroidNotificationSound? androidSound;

    if (useSystemAlarm) {
      androidSound = UriAndroidNotificationSound(
        'content://settings/system/alarm_alert',
      );
    } else if (soundName != null && soundName.isNotEmpty) {
      androidSound = RawResourceAndroidNotificationSound(soundName);
    }

      AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'alarm_channel',
      'المنبهات',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      sound: androidSound,
    );

      DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      sound: soundName != null ? '$soundName.caf' : null,
    );

      NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final tz.TZDateTime tzScheduledTime =
        tz.TZDateTime.from(scheduledTime, tz.local);

    await _plugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: tzScheduledTime,
      notificationDetails: details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: payload,
    );
  }

  static Future<void> showImmediateNotification({
    required int id,
    required String title,
    required String body,
    String? soundName,
    bool useSystemAlarm = false,
  }) async {
    AndroidNotificationSound? androidSound;

    if (useSystemAlarm) {
      androidSound = UriAndroidNotificationSound(
        'content://settings/system/alarm_alert',
      );
    } else if (soundName != null && soundName.isNotEmpty) {
      androidSound = RawResourceAndroidNotificationSound(soundName);
    }

      AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'alarm_channel',
      'المنبهات',
      importance: Importance.max,
      priority: Priority.high,
      sound: androidSound,
    );

      NotificationDetails details = NotificationDetails(
      android: androidDetails,
    );

    await _plugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: details,
    );
  }

  static Future<void> cancelNotification(int id) async {
    await _plugin.cancel(id: id);
  }

  static Future<void> cancelAllNotifications() async {
    await _plugin.cancelAll();
  }
}