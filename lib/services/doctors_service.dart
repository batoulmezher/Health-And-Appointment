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
      }
      return null;
    } catch (e) {
      print("❌ Doctor service error: $e");
      return null;
    }
  }

  Future<DoctorModel?> getDoctorById(int id) async {
    try {
      final token = _getToken();
      if (token == null || token.isEmpty) {
        print("⚠️ No token found. Please login first.");
        return null;
      }

      final response = await _dio.get(
        '/api/v1/patient/doctors/$id',
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
      }
      return null;
    } catch (e) {
      print("❌ Doctor fetch error: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>?> toggleFollowDoctor(int doctorId) async {
    try {
      final token = _getToken();
      if (token == null || token.isEmpty) {
        print("⚠️ No token found.");
        return null;
      }

      final response = await _dio.post(
        '/api/v1/patient/doctors/$doctorId/follow',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data as Map<String, dynamic>;
      }
      return null;
    } on DioException catch (e) {
      print("❌ Follow error: ${e.message}");
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        _storage.remove('token');
      }
      return null;
    } catch (e) {
      print("❌ Follow error: $e");
      return null;
    }
  }

  Future<List<Data>?> getFilteredDoctors({
    bool? topRated,
    String? gender,
    String? city,
    String? search,
  }) async {
    try {
      final token = _getToken();
      if (token == null || token.isEmpty) {
        print("⚠️ No token found.");
        return null;
      }

      final Map<String, dynamic> queryParams = {};
      if (topRated != null) queryParams['top_rated'] = topRated ? 1 : 0;
      if (gender != null && gender.isNotEmpty) queryParams['gender'] = gender;
      if (city != null && city.isNotEmpty) queryParams['city'] = city;
      if (search != null && search.isNotEmpty) queryParams['search'] = search;

      final response = await _dio.get(
        '/api/v1/home/doctors',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
        queryParameters: queryParams,
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
      print("❌ Filtered doctors service error: ${e.message}");
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        _storage.remove('token');
      }
      return null;
    } catch (e) {
      print("❌ Filtered doctors service error: $e");
      return null;
    }
  }

  Future<List<String>?> getDoctorAvailability(int doctorId, String date) async {
    try {
      final token = _getToken();
      if (token == null || token.isEmpty) {
        print("⚠️ No token found.");
        return null;
      }

      final response = await _dio.get(
        '/api/v1/patient/doctors/$doctorId/availability',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
        queryParameters: {'date': date},
      );

      print("📥 Availability response status: ${response.statusCode}");

      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        final Map<String, dynamic> json = response.data;
        if (json['status'] == 'success' && json['data'] != null) {
          final Map<String, dynamic> data = json['data'];
          if (data['available_slots'] != null && data['available_slots'] is List) {
            final List<String> slots = List<String>.from(data['available_slots']);
            print("✅ Found ${slots.length} available slots");
            return slots;
          } else {
            print("⚠️ Unexpected availability data structure: $data");
            return null;
          }
        }
      }
      return null;
    } on DioException catch (e) {
      print("❌ Availability fetch error: ${e.message}");
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        _storage.remove('token');
      }
      return null;
    } catch (e) {
      print("❌ Availability fetch error: $e");
      return null;
    }
  }
}