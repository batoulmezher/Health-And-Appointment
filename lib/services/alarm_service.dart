// lib/services/alarm_service.dart
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:health_appointment_app/api/api.dart';
import 'package:health_appointment_app/models/alarm_model.dart';

class AlarmService {
  final Dio _dio = Api().dio;
  final GetStorage _storage = GetStorage();

  String? _getToken() => _storage.read('token');

  Future<AlarmModel?> createAlarm({
    required String medicineName,
    required String dosage,
    required int quantity,
    required String frequency,
    required String alarmTime,
  }) async {
    try {
      final token = _getToken();
      if (token == null || token.isEmpty) return null;

      final response = await _dio.post(
        '/api/v1/alarms',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        data: {
          'medicine_name': medicineName,
          'dosage': dosage,
          'quantity': quantity,
          'frequency': frequency,
          'alarm_time': alarmTime,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = response.data;
        if (json['status'] == 'success' && json['data'] != null) {
          return AlarmModel.fromJson(json['data']);
        }
      }
      return null;
    } catch (e) {
      print('❌ Create alarm error: $e');
      return null;
    }
  }
// lib/services/alarm_service.dart
Future<List<AlarmModel>?> getAlarms() async {
  try {
    final token = _getToken();
    if (token == null || token.isEmpty) return null;

    final response = await _dio.get(
      '/api/v1/alarms',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
      final json = response.data;
      if (json['status'] == 'success' && json['data'] != null) {
        final data = json['data'];
        if (data['alarms'] is List) {
          final List<dynamic> list = data['alarms'];
          return list.map((item) => AlarmModel.fromJson(item)).toList();
        }
      }
    }
    return null;
  } catch (e) {
    print('❌ Get alarms error: $e');
    return null;
  }
}
 

  Future<bool> toggleAlarm(int id, bool isActive) async {
    try {
      final token = _getToken();
      if (token == null || token.isEmpty) return false;

      final response = await _dio.patch(
        '/api/v1/alarms/$id/toggle',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        data: {'is_active': isActive},
      );

      return response.statusCode == 200;
    } catch (e) {
      print('❌ Toggle alarm error: $e');
      return false;
    }
  }

  Future<bool> deleteAlarm(int id) async {
    try {
      final token = _getToken();
      if (token == null || token.isEmpty) return false;

      final response = await _dio.delete(
        '/api/v1/alarms/$id',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('❌ Delete alarm error: $e');
      return false;
    }
  }
}