// lib/services/chat_service.dart
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:health_appointment_app/api/api.dart';
import 'package:health_appointment_app/models/conversation_model.dart';
import 'package:health_appointment_app/models/message_model.dart';

class ChatService {
  final Dio _dio = Api().dio;
  final GetStorage _storage = GetStorage();

  String? _getToken() => _storage.read('token');

  Future<List<Conversation>?> getConversations() async {
    try {
      final token = _getToken();
      if (token == null || token.isEmpty) return null;

      final response = await _dio.get(
        '/api/v1/chat/conversations',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        final json = response.data;
        if (json['status'] == 'success' && json['data'] is List) {
          final List<dynamic> list = json['data'];
          return list.map((item) => Conversation.fromJson(item)).toList();
        }
      }
      return null;
    } catch (e) {
      print('❌ Get conversations error: $e');
      return null;
    }
  }

  Future<String?> createConversation(int userId) async {
    try {
      final token = _getToken();
      if (token == null || token.isEmpty) return null;

      final response = await _dio.post(
        '/api/v1/chat/conversations',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        data: {'user_id': userId},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = response.data;
        if (json['status'] == 'success' && json['data'] != null) {
          if (json['data'] is Map<String, dynamic>) {
            return json['data']['id']?.toString();
          } else {
            return json['data'].toString();
          }
        }
      }
      return null;
    } catch (e) {
      print('❌ Create conversation error: $e');
      return null;
    }
  }

  Future<List<Message>?> getMessages(String conversationId) async {
    try {
      final token = _getToken();
      if (token == null || token.isEmpty) return null;

      final response = await _dio.get(
        '/api/v1/chat/conversations/$conversationId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        final json = response.data;
        if (json['status'] == 'success' && json['data'] is List) {
          final List<dynamic> list = json['data'];
          final currentUserId = _storage.read('user_id') ?? 0;
          return list.map((item) => Message.fromJson(item, currentUserId: currentUserId)).toList();
        }
      }
      return null;
    } catch (e) {
      print('❌ Get messages error: $e');
      return null;
    }
  }

  Future<Message?> sendMessage(String conversationId, String content) async {
    try {
      final token = _getToken();
      if (token == null || token.isEmpty) return null;

      final response = await _dio.post(
        '/api/v1/chat/messages',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        data: {
          'conversation_id': conversationId,
          'content': content,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = response.data;
        if (json['status'] == 'success' && json['data'] != null) {
          final currentUserId = _storage.read('user_id') ?? 0;
          return Message.fromJson(json['data'], currentUserId: currentUserId);
        }
      }
      return null;
    } catch (e) {
      print('❌ Send message error: $e');
      return null;
    }
  }
}