// lib/screens/notifications_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_appointment_app/constant/colors.dart' as appColor;
import 'package:health_appointment_app/controller/notifications_controller.dart';
import 'package:health_appointment_app/models/notification_model.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NotificationsController());
    final isDarkMode = Get.isDarkMode;

    final backgroundColor = isDarkMode ? Colors.grey.shade900 : const Color(0xFFF8F9FB);
    final cardColor = isDarkMode ? Colors.grey.shade800 : Colors.white;
    final textColor = isDarkMode ? Colors.white : const Color(0xFF1A1A2E);
    final subTextColor = isDarkMode ? Colors.white70 : const Color(0xFF6B7280);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: Text(
          'الإشعارات',
          style: TextStyle(
            color: textColor,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: textColor),
          onPressed: () => Get.back(),
        ),
        actions: [
          Obx(() {
            if (controller.unreadCount > 0) {
              return TextButton(
                onPressed: controller.markAllAsRead,
                child: Text(
                  'تحديد الكل كمقروء',
                  style: TextStyle(color: appColor.appColor.primary),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
          IconButton(
            icon: Icon(Icons.refresh, color: textColor),
            onPressed: controller.fetchNotifications,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 60, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  controller.errorMessage.value,
                  style: TextStyle(color: subTextColor),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: controller.fetchNotifications,
                  child: const Text('إعادة المحاولة'),
                ),
              ],
            ),
          );
        }
        if (controller.notifications.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.notifications_off, size: 60, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text(
                  'لا توجد إشعارات',
                  style: TextStyle(color: subTextColor, fontSize: 16),
                ),
              ],
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: controller.fetchNotifications,
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: controller.notifications.length,
            itemBuilder: (context, index) {
              final notification = controller.notifications[index];
              return _buildNotificationCard(
                notification,
                controller,
                cardColor,
                textColor,
                subTextColor,
              );
            },
          ),
        );
      }),
    );
  }

  Widget _buildNotificationCard(
    NotificationModel notification,
    NotificationsController controller,
    Color cardColor,
    Color textColor,
    Color subTextColor,
  ) {
    final isRead = notification.isRead;

    return GestureDetector(
      onTap: () {
        if (!isRead) {
          controller.markAsRead(notification.id);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isRead
              ? cardColor.withOpacity(0.6)
              : cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          border: isRead
              ? null
              : Border.all(color: appColor.appColor.primary.withOpacity(0.3), width: 1.5),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _getIconColor(notification.type).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getIconForType(notification.type),
                color: _getIconColor(notification.type),
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: TextStyle(
                      fontWeight: isRead ? FontWeight.w500 : FontWeight.bold,
                      fontSize: 15,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.content,
                    style: TextStyle(
                      fontSize: 13,
                      color: subTextColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    notification.timeAgo, 
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
            if (!isRead)
              Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: appColor.appColor.primary,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForType(String type) {
    switch (type.toLowerCase()) {
      case 'post':
        return Icons.post_add;
      case 'appointment':
        return Icons.calendar_today;
      case 'follow':
        return Icons.person_add;
      case 'like':
        return Icons.favorite;
      case 'comment':
        return Icons.comment;
      case 'wallet':
        return Icons.account_balance_wallet;
      case 'alert':
        return Icons.warning_amber;
      default:
        return Icons.notifications;
    }
  }

  Color _getIconColor(String type) {
    switch (type.toLowerCase()) {
      case 'post':
        return Colors.blue;
      case 'appointment':
        return Colors.green;
      case 'follow':
        return Colors.amber;
      case 'like':
        return Colors.red;
      case 'comment':
        return Colors.purple;
      case 'wallet':
        return Colors.orange;
      case 'alert':
        return Colors.redAccent;
      default:
        return Colors.grey;
    }
  }
}