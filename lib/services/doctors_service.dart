// lib/services/doctors_service.dart
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart' hide Data;
import 'package:health_appointment_app/api/api.dart';
import 'package:health_appointment_app/models/doctor_model.dart';

class DoctorsService {
  final Dio _dio = Api().dio;
  final GetStorage _storage = GetStorage();

  String? _getToken() {
    return _storage.read('token');
  }

  // Fetch all doctors
  Future<List<Data>?> getAllDoctors() async {
    try {
      final token = _getToken();
      if (token == null || token.isEmpty) {
        print("⚠️ No token found. Please login first.");
        return null;
      }

      final response = await _dio.get(
        '/api/v1/home/doctors',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        final Map<String, dynamic> json = response.data;
        if (json['status'] == 'success' && json['data'] is List) {
          final List<dynamic> list = json['data'];
          return list.map((item) => Data.fromJson(item)).toList();
        }
      }
      return null;
    } on DioException catch (e) {
      print("❌ Doctor service error: ${e.message}");
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        _storage.remove('token');
        print("⚠️ Token removed due to unauthorized response.");
      }
      return null;
    } catch (e) {
      print("❌ Doctor service error: $e");
      return null;
    }
  }

  // Fetch doctor by ID
  Future<DoctorModel?> getDoctorById(int id) async {
    try {
      final token = _getToken();
      if (token == null || token.isEmpty) {
        print("⚠️ No token found. Please login first.");
        return null;
      }

      final response = await _dio.get(
        '/api/v1/doctors/$id',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        return DoctorModel.fromJson(response.data);
      }
      return null;
    } on DioException catch (e) {
      print("❌ Doctor fetch error: ${e.message}");
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        _storage.remove('token');
        print("⚠️ Token removed due to unauthorized response.");
      }
      return null;
    } catch (e) {
      print("❌ Doctor fetch error: $e");
      return null;
    }
  }
}