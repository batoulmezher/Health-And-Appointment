// lib/models/notification_model.dart
class NotificationModel {
  final int id;
  final String title;
  final String content;
  final String type;
  final bool isRead;
  final String timeAgo;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.content,
    required this.type,
    required this.isRead,
    required this.timeAgo,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      type: json['type'] ?? '',
      isRead: json['is_read'] ?? false,
      timeAgo: json['time_ago'] ?? '',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'type': type,
      'is_read': isRead,
      'time_ago': timeAgo,
      'created_at': createdAt.toIso8601String(),
    };
  }
}