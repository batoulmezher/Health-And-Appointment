// lib/services/appointment_service.dart
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:health_appointment_app/api/api.dart';
import 'package:health_appointment_app/models/appointment%20_model.dart';

class AppointmentService {
  final Dio _dio = Api().dio;
  final GetStorage _storage = GetStorage();

  String? _getToken() {
    return _storage.read('token');
  }

  Future<Map<String, dynamic>?> createAppointment({
    required int doctorId,
    required String appointmentDate,
    required String appointmentTime,
  }) async {
    try {
      final token = _getToken();
      if (token == null || token.isEmpty) {
        print("⚠️ No token found.");
        return null;
      }

      final response = await _dio.post(
        '/api/v1/patient/appointments',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
        data: {
          'doctor_id': doctorId,
          'appointment_date': appointmentDate,
          'appointment_time': appointmentTime,
        },
      );

      print("📥 Create appointment response status: ${response.statusCode}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data as Map<String, dynamic>;
      }
      return null;
    } on DioException catch (e) {
      print("❌ Create appointment error: ${e.message}");
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        _storage.remove('token');
      }
      return null;
    } catch (e) {
      print("❌ Create appointment error: $e");
      return null;
    }
  }
  Future<List<AppointmentModel>?> getAppointments() async {
  try {
    final token = _getToken();
    if (token == null || token.isEmpty) {
      print("⚠️ No token found.");
      return null;
    }

    final response = await _dio.get(
      '/api/v1/patient/appointments',
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
    );

    print("📥 Appointments response status: ${response.statusCode}");

    if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
      final json = response.data;
      if (json['status'] == 'success' && json['data'] != null) {
        final data = json['data'];
        final appointmentsData = data['appointments'] as Map<String, dynamic>?;
        final list = appointmentsData?['data'] as List?;
        if (list != null) {
          return list.map((item) => AppointmentModel.fromJson(item)).toList();
        }
      }
    }
    return null;
  } on DioException catch (e) {
    print("❌ Get appointments error: ${e.message}");
    if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
      _storage.remove('token');
    }
    return null;
  } catch (e) {
    print("❌ Get appointments error: $e");
    return null;
  }
}
 Future<bool> cancelAppointment(int appointmentId) async {
    try {
      final token = _getToken();
      if (token == null || token.isEmpty) {
        print("⚠️ No token found.");
        return false;
      }

      final response = await _dio.patch(
        '/api/v1/patient/appointments/$appointmentId/cancel',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      print("📥 Cancel appointment response status: ${response.statusCode}");
      
      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      }
      
      if (response.data is Map && response.data['message'] != null) {
        print("❌ Cancel error message: ${response.data['message']}");
      }
      return false;
    } on DioException catch (e) {
      print("❌ Cancel appointment error: ${e.message}");
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        _storage.remove('token');
      }
      return false;
    } catch (e) {
      print("❌ Cancel appointment error: $e");
      return false;
    }
  }
}