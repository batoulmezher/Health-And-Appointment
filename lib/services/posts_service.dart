// lib/services/post_service.dart
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:health_appointment_app/api/api.dart';
import 'package:health_appointment_app/models/comment_model.dart';
import 'package:health_appointment_app/models/post_model.dart';

class PostService {
  final Dio _dio = Api().dio;
  final GetStorage _storage = GetStorage();

  String? _getToken() => _storage.read('token');

  Future<Map<String, dynamic>?> toggleLike(int postId) async {
    try {
      final token = _getToken();
      if (token == null || token.isEmpty) {
        print("⚠️ No token found.");
        return null;
      }

      final response = await _dio.post(
        '/api/v1/posts/$postId/react',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      print("📥 React response status: ${response.statusCode}");

      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        return response.data as Map<String, dynamic>;
      }
      return null;
    } on DioException catch (e) {
      print("❌ React error: ${e.message}");
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        _storage.remove('token');
      }
      return null;
    } catch (e) {
      print("❌ React error: $e");
      return null;
    }
  }

  Future<List<CommentModel>?> getComments(int postId) async {
    try {
      final token = _getToken();
      if (token == null || token.isEmpty) {
        print("⚠️ No token found.");
        return null;
      }

      final response = await _dio.get(
        '/api/v1/posts/$postId/comments',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      print("📥 Get comments response status: ${response.statusCode}");

      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        final json = response.data;
        if (json['status'] == 'success' && json['data'] != null) {
          final data = json['data'];
          final List<dynamic> list = data['data'] ?? [];
          return list.map((item) => CommentModel.fromJson(item)).toList();
        }
      }
      return null;
    } on DioException catch (e) {
      print("❌ Get comments error: ${e.message}");
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        _storage.remove('token');
      }
      return null;
    } catch (e) {
      print("❌ Get comments error: $e");
      return null;
    }
  }

  Future<bool> addComment(int postId, String content) async {
    try {
      final token = _getToken();
      if (token == null || token.isEmpty) {
        print("⚠️ No token found.");
        return false;
      }

      final response = await _dio.post(
        '/api/v1/posts/$postId/comments',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
        data: {'content': content},
      );

      print("📥 Add comment response status: ${response.statusCode}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
      return false;
    } on DioException catch (e) {
      print("❌ Add comment error: ${e.message}");
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        _storage.remove('token');
      }
      return false;
    } catch (e) {
      print("❌ Add comment error: $e");
      return false;
    }
  }
  Future<List<PostModel>?> getAllPosts() async {
  try {
    final token = _getToken();
    if (token == null || token.isEmpty) {
      print("⚠️ No token found.");
      return null;
    }

    final response = await _dio.get(
      '/api/v1/posts',
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
    );

    print("📥 Posts response status: ${response.statusCode}");

    if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
      final json = response.data;
      if (json['status'] == 'success' && json['data'] is List) {
        final List<dynamic> list = json['data'];
        return list.map((item) => PostModel.fromJson(item)).toList();
      }
    }
    return null;
  } on DioException catch (e) {
    print("❌ Get all posts error: ${e.message}");
    if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
      _storage.remove('token');
    }
    return null;
  } catch (e) {
    print("❌ Get all posts error: $e");
    return null;
  }
}

}