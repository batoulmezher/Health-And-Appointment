// lib/controller/notifications_controller.dart
import 'package:get/get.dart';
import 'package:health_appointment_app/models/notification_model.dart';
import 'package:health_appointment_app/services/notification_service.dart';

class NotificationsController extends GetxController {
  final NotificationService _notificationService = NotificationService();

  var notifications = <NotificationModel>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final result = await _notificationService.getNotifications();
      isLoading.value = false;
      if (result != null) {
        notifications.value = result;
        if (result.isEmpty) {
          errorMessage.value = 'لا توجد إشعارات';
        }
      } else {
        errorMessage.value = 'فشل تحميل الإشعارات';
      }
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = 'حدث خطأ غير متوقع';
    }
  }

  void addNotification(NotificationModel notification) {
    final exists = notifications.any((n) => n.id == notification.id);
    if (!exists) {
      notifications.insert(0, notification);
      notifications.refresh();
    }
  }

  Future<void> markAsRead(int id) async {
    final success = await _notificationService.markAsRead(id);
    if (success) {
      final index = notifications.indexWhere((n) => n.id == id);
      if (index != -1) {
        final updated = notifications[index];
        notifications[index] = NotificationModel(
          id: updated.id,
          title: updated.title,
          content: updated.content,
          type: updated.type,
          isRead: true,
          timeAgo: updated.timeAgo,
          createdAt: updated.createdAt,
        );
        notifications.refresh();
        Get.snackbar('نجاح', 'تم تحديث الإشعار كمقروء');
      }
    } else {
      Get.snackbar('خطأ', 'فشل تحديث الإشعار');
    }
  }

  Future<void> markAllAsRead() async {
    final success = await _notificationService.markAllAsRead();
    if (success) {
      for (int i = 0; i < notifications.length; i++) {
        final n = notifications[i];
        notifications[i] = NotificationModel(
          id: n.id,
          title: n.title,
          content: n.content,
          type: n.type,
          isRead: true,
          timeAgo: n.timeAgo,
          createdAt: n.createdAt,
        );
      }
      notifications.refresh();
      Get.snackbar('نجاح', 'تم تحديث جميع الإشعارات كمقروءة');
    } else {
      Get.snackbar('خطأ', 'فشل تحديث الإشعارات');
    }
  }

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  void clearAll() {
    notifications.clear();
  }
}