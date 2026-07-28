import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart' hide Data;
import 'package:health_appointment_app/api/api.dart';
import 'package:health_appointment_app/models/doctor_model.dart';
import 'package:health_appointment_app/models/post_model.dart';
import 'package:health_appointment_app/models/specialty_model.dart';

class HomeService {
  final Dio _dio = Api().dio;
  final GetStorage _storage = GetStorage();

  String? _getToken() {
    return _storage.read('token');
  }

  Future<List<Data>?> getHomeDoctors() async {
    try {
      final token = _getToken();
      if (token == null || token.isEmpty) {
        print("⚠️ No token found. Please login first.");
        return null;
      }

      final response = await _dio.get(
        '/api/v1/home/recommended-doctors',
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
      }
      return null;
    } catch (e) {
      print("❌ Doctor fetch error: $e");
      return null;
    }
  }

  Future<List<SpecialtyModel>?> getHomeSpecialties() async {
    try {
      final token = _getToken();
      if (token == null || token.isEmpty) {
        print("⚠️ No token found.");
        return null;
      }

      final response = await _dio.get(
        '/api/v1/home/specialties',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        final Map<String, dynamic> json = response.data;
        if (json['status'] == 'success' && json['data'] is List) {
          final List<dynamic> list = json['data'];
          return list.map((item) => SpecialtyModel.fromJson(item)).toList();
        }
      }
      return null;
    } on DioException catch (e) {
      print("❌ Specialty service error: ${e.message}");
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        _storage.remove('token');
      }
      return null;
    } catch (e) {
      print("❌ Specialty service error: $e");
      return null;
    }
  }

  Future<List<PostModel>?> getLatestPosts() async {
    try {
      final token = _getToken();
      if (token == null || token.isEmpty) {
        print("⚠️ No token found.");
        return null;
      }

      final response = await _dio.get(
        '/api/v1/home/latest-posts',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        final Map<String, dynamic> json = response.data;
        if (json['status'] == 'success' && json['data'] is List) {
          final List<dynamic> list = json['data'];
          return list.map((item) => PostModel.fromJson(item)).toList();
        }
      }
      return null;
    } on DioException catch (e) {
      print("❌ Posts service error: ${e.message}");
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        _storage.remove('token');
      }
      return null;
    } catch (e) {
      print("❌ Posts service error: $e");
      return null;
    }
  }

 Future<List<Data>?> searchDoctors(String query) async {
  try {
    final token = _getToken();
    if (token == null || token.isEmpty) {
      print("⚠️ No token found.");
      return null;
    }

    final response = await _dio.get(
      '/api/v1/home/search',
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
      queryParameters: {'search': query},
    );

    print("📥 Search response status: ${response.statusCode}");

    if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
      final Map<String, dynamic> json = response.data;
      if (json['status'] == 'success' && json['data'] != null) {
        final Map<String, dynamic> data = json['data'];
        
        if (data['doctors'] != null && data['doctors'] is List) {
          final List<dynamic> doctorsList = data['doctors'];
          final List<Data> allDoctors = doctorsList
              .map((docJson) => Data.fromJson(docJson))
              .toList();
          print("✅ Found ${allDoctors.length} doctors from search (direct)");
          return allDoctors;
        }
        
        if (data['specialties'] != null && data['specialties'] is List) {
          final List<dynamic> specialties = data['specialties'];
          final List<Data> allDoctors = [];
          
          for (var specialty in specialties) {
            if (specialty['doctors'] != null && specialty['doctors'] is List) {
              final List<dynamic> doctors = specialty['doctors'];
              for (var doctorJson in doctors) {
                try {
                  final Data doctor = Data.fromJson(doctorJson);
                  allDoctors.add(doctor);
                } catch (e) {
                  print("❌ Error parsing doctor: $e");
                }
              }
            }
          }
          print("✅ Found ${allDoctors.length} doctors from search (specialties)");
          return allDoctors;
        }
      }
    }
    return null;
  } on DioException catch (e) {
    print("❌ Search service error: ${e.message}");
    if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
      _storage.remove('token');
    }
    return null;
  } catch (e) {
    print("❌ Search service error: $e");
    return null;
  }
}
}