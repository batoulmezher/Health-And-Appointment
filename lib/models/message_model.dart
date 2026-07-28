// lib/models/message_model.dart
class Message {
  final String id;
  final String conversationId;
  final String content;
  final bool isRead;
  final DateTime createdAt;
  final bool isFromUser;

  Message({
    required this.id,
    required this.conversationId,
    required this.content,
    required this.isRead,
    required this.createdAt,
    required this.isFromUser,
  });

  factory Message.fromJson(Map<String, dynamic> json, {required int currentUserId}) {
    final senderId = json['sender_id'] ?? 0;
    return Message(
      id: json['id'] ?? '',
      conversationId: json['conversation_id'] ?? '',
      content: json['content'] ?? '',
      isRead: json['is_read'] ?? false,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      isFromUser: senderId == currentUserId,
    );
  }
}