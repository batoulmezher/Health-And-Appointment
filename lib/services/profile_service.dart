import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:health_appointment_app/api/api.dart';
import 'package:health_appointment_app/models/user_profile.dart';

class ProfileService {
  final Dio _dio = Api().dio;
  final GetStorage _storage = GetStorage();

  String? _getToken() => _storage.read('token');
 
  Future<bool> logout() async {
    try {
      final token = _getToken();
      if (token == null || token.isEmpty) return false;

      final response = await _dio.post(
        '/api/v1/logout',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('❌ Logout error: $e');
      return false;
    }
  }

  Future<UserProfile?> getProfile() async {
    try {
      final token = _getToken();
      if (token == null || token.isEmpty) {
        print('⚠️ No token found');
        return null;
      }

      final response = await _dio.get(
        '/api/v1/me',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        final json = response.data;
        if (json['status'] == 'success' && json['data'] != null) {
          return UserProfile.fromJson(json['data']);
        }
      }
      return null;
    } catch (e) {
      print('❌ Get profile error: $e');
      return null;
    }
  }

Future<UserProfile?> updateProfile({
  required String fullName,
  required String phoneNumber,
  required double weight,
  required String bloodType,
}) async {
  try {
    final token = _getToken();
    if (token == null || token.isEmpty) return null;

    final response = await _dio.put(
      '/api/v1/profile',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
      data: {
        'full_name': fullName,
        'phone_number': phoneNumber,
        'weight': weight,
        'blood_type': bloodType,
      },
    );

    if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
      final json = response.data;
      if (json['status'] == 'success' && json['data'] != null) {
        return UserProfile.fromJson(json['data']);
      }
    }
    return null;
  } catch (e) {
    print('❌ Update profile error: $e');
    return null;
  }
}
}