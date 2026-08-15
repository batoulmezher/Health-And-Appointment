// lib/services/review_service.dart
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:health_appointment_app/api/api.dart';
import 'package:health_appointment_app/models/review.dart';

class ReviewService {
  final Dio _dio = Api().dio;
  final GetStorage _storage = GetStorage();

  String? _getToken() => _storage.read('token');

  Future<Review?> submitReview({
    required int doctorId,
    required int ratingScore,
    required String comment,
  }) async {
    try {
      final token = _getToken();
      if (token == null || token.isEmpty) return null;

      final response = await _dio.post(
        '/api/v1/patient/doctors/$doctorId/reviews',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        data: {
          'rating_score': ratingScore,
          'comment': comment,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = response.data;
        if (json['status'] == 'success' && json['data'] != null) {
          return Review.fromJson(json['data']);
        }
      }
      return null;
    } catch (e) {
      print('❌ Submit review error: $e');
      return null;
    }
  }
}