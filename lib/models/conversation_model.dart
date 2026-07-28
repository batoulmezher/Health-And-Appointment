// lib/models/conversation_model.dart
import 'doctor_model.dart';

class Conversation {
  final String id;
  final User doctor;
  final User patient;
  final LatestMessage? latestMessage;
  final DateTime createdAt;

  Conversation({
    required this.id,
    required this.doctor,
    required this.patient,
    this.latestMessage,
    required this.createdAt,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'] ?? '',
      doctor: User.fromJson(json['doctor'] ?? {}),
      patient: User.fromJson(json['patient'] ?? {}),
      latestMessage: json['latest_message'] != null
          ? LatestMessage.fromJson(json['latest_message'])
          : null,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }
}

class LatestMessage {
  final String id;
  final String conversationId;
  final String content;
  final bool isRead;
  final DateTime createdAt;
  final String? timeAgo;

  LatestMessage({
    required this.id,
    required this.conversationId,
    required this.content,
    required this.isRead,
    required this.createdAt,
    this.timeAgo,
  });

  factory LatestMessage.fromJson(Map<String, dynamic> json) {
    return LatestMessage(
      id: json['id'] ?? '',
      conversationId: json['conversation_id'] ?? '',
      content: json['content'] ?? '',
      isRead: json['is_read'] ?? false,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      timeAgo: json['time_ago'],
    );
  }
}