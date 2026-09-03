// lib/services/auth/sign_up_service.dart
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:health_appointment_app/api/api.dart';

class SignUpService {
  Future<Map<String, dynamic>?> registerWithImage({
    required String email,
    required String password,
    required String fullName,
    required int phoneNumber,
    required String gender,
    required int age,
    required double weight,
    required double height,
    required String bloodType,
    required bool hasChronicDisease,
    required String chronicDiseaseDescription,
    required String currentMedications,
    required File? imageFile,
  }) async {
    try {
      final formData = FormData();

      formData.fields.addAll([
        MapEntry('email', email),
        MapEntry('password', password),
        MapEntry('full_name', fullName),
        MapEntry('phone_number', phoneNumber.toString()),
        MapEntry('gender', gender),
        MapEntry('age', age.toString()),
        MapEntry('weight', weight.toString()),
        MapEntry('height', height.toString()),
        MapEntry('blood_type', bloodType),
        MapEntry('has_chronic_disease', hasChronicDisease.toString()),
        MapEntry('chronic_disease_description', chronicDiseaseDescription),
        MapEntry('current_medications', currentMedications),
      ]);

      if (imageFile != null) {
        final multipartFile = await MultipartFile.fromFile(
          imageFile.path,
          filename: 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg',
        );
        formData.files.add(MapEntry('profile_picture', multipartFile));
        print("📸 Image added to formData: ${imageFile.path}");
      } else {
        print("⚠️ No image file provided");
      }

      print("📤 Sending FormData with ${formData.fields.length} fields and ${formData.files.length} files");

      final response = await Api().dio.post(
        '/api/v1/register',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      print("📥 Response status: ${response.statusCode}");
      print("📥 Response data: ${response.data}");

      if (response.data is Map<String, dynamic>) {
        return response.data as Map<String, dynamic>;
      } else {
        return {
          'status': 'error',
          'message': 'استجابة غير متوقعة من الخادم',
        };
      }
    } on DioException catch (e) {
      print("❌ Dio Error: ${e.message}");
      print("❌ Response Data: ${e.response?.data}");
      if (e.response?.data is Map<String, dynamic>) {
        final errorData = e.response?.data as Map<String, dynamic>;
        return {
          'status': 'error',
          'message': errorData['message'] ?? 'خطأ في الاتصال بالخادم',
        };
      }
      return {
        'status': 'error',
        'message': 'خطأ في الاتصال بالخادم',
      };
    } catch (e) {
      print("❌ Registration error: $e");
      return {
        'status': 'error',
        'message': 'حدث خطأ غير متوقع: $e',
      };
    }
  }
}