// lib/services/prescription_service.dart
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:health_appointment_app/api/api.dart';
import 'package:health_appointment_app/models/prescription.dart';
import 'package:path_provider/path_provider.dart';

class PrescriptionService {
  final Dio _dio = Api().dio;
  final GetStorage _storage = GetStorage();

  String? _getToken() => _storage.read('token');

  Future<List<Prescription>?> getPrescriptions({String? search}) async {
    try {
      final token = _getToken();
      if (token == null || token.isEmpty) return null;

      final queryParams = <String, dynamic>{};
      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }

      final response = await _dio.get(
        '/api/v1/patient/prescriptions',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        queryParameters: queryParams,
      );

      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        final json = response.data;
        if (json['status'] == 'success' && json['data'] is List) {
          final List<dynamic> list = json['data'];
          return list.map((item) => Prescription.fromJson(item)).toList();
        }
      }
      return null;
    } catch (e) {
      print('❌ Get prescriptions error: $e');
      return null;
    }
  }

  Future<Prescription?> getPrescriptionDetail(int id) async {
    try {
      final token = _getToken();
      if (token == null || token.isEmpty) return null;

      final response = await _dio.get(
        '/api/v1/patient/prescriptions/$id',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        final json = response.data;
        if (json['status'] == 'success' && json['data'] != null) {
          return Prescription.fromJson(json['data']);
        }
      }
      return null;
    } catch (e) {
      print('❌ Get prescription detail error: $e');
      return null;
    }
  }

  Future<String?> downloadPrescriptionFile(int id) async {
    try {
      final token = _getToken();
      if (token == null || token.isEmpty) return null;

      final response = await _dio.get(
        '/api/v1/patient/prescriptions/$id/download',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          responseType: ResponseType.bytes,
        ),
      );

      if (response.statusCode == 200) {
        final String dir = (await getApplicationDocumentsDirectory()).path;
        final String filePath = '$dir/prescription_$id.pdf';
        final File file = File(filePath);
        await file.writeAsBytes(response.data as List<int>);
        return filePath;
      }
      return null;
    } catch (e) {
      print('❌ Download prescription error: $e');
      return null;
    }
  }
}