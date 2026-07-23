// lib/services/auth/forget_password_services.dart
import 'package:dio/dio.dart';
import 'package:health_appointment_app/api/api.dart';

class ForgetPasswordServices {
  Future<Map<String, dynamic>?> postForgetPasswordData({
    required String email,
  }) async {
    try {
      final Map<String, dynamic> requestData = {
        "email": email,
      };

      print("📤 REQUEST BODY (forgot-password):");
      print(requestData);

      final response = await Api().dio.post(
        '/api/v1/forgot-password',
        data: requestData,
      );

      print("📥 RESPONSE (forgot-password):");
      print(response.data);

      if (response.data is Map<String, dynamic>) {
        return response.data as Map<String, dynamic>;
      } else {
        return {
          'status': 'error',
          'message': 'استجابة غير متوقعة من الخادم',
        };
      }
    } on DioException catch (e) {
      print("❌ Dio Error (forgot-password): ${e.message}");
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
      print("❌ Error (forgot-password): $e");
      return {
        'status': 'error',
        'message': 'حدث خطأ غير متوقع: $e',
      };
    }
  }

  Future<Map<String, dynamic>?> postOtpData({
    required String otp,
    required String email,
  }) async {
    try {
      final Map<String, dynamic> requestData = {
        "otp": otp,
        "email": email,
      };

      print("📤 REQUEST BODY (verify-otp):");
      print(requestData);

      final response = await Api().dio.post(
        '/api/v1/verify-otp',
        data: requestData,
      );

      print("📥 RESPONSE (verify-otp):");
      print(response.data);

      if (response.data is Map<String, dynamic>) {
        return response.data as Map<String, dynamic>;
      } else {
        return {
          'status': 'error',
          'message': 'استجابة غير متوقعة من الخادم',
        };
      }
    } on DioException catch (e) {
      print("❌ Dio Error (verify-otp): ${e.message}");
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
      print("❌ Error (verify-otp): $e");
      return {
        'status': 'error',
        'message': 'حدث خطأ غير متوقع: $e',
      };
    }
  }

  Future<Map<String, dynamic>?> resendOtp({
    required String email,
  }) async {
    try {
      final Map<String, dynamic> requestData = {
        "email": email,
      };

      print("📤 REQUEST BODY (resend-otp):");
      print(requestData);

      final response = await Api().dio.post(
        '/api/v1/resend-otp',
        data: requestData,
      );

      print("📥 RESPONSE (resend-otp):");
      print(response.data);

      if (response.data is Map<String, dynamic>) {
        return response.data as Map<String, dynamic>;
      } else {
        return {
          'status': 'error',
          'message': 'استجابة غير متوقعة من الخادم',
        };
      }
    } on DioException catch (e) {
      print("❌ Dio Error (resend-otp): ${e.message}");
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
      print("❌ Error (resend-otp): $e");
      return {
        'status': 'error',
        'message': 'حدث خطأ غير متوقع: $e',
      };
    }
  }

  Future<Map<String, dynamic>?> resetPassword({
    required String email,
    required String otp,
    required String password,
  }) async {
    try {
      final Map<String, dynamic> requestData = {
        "email": email,
        "otp": otp,
        "password": password,
      };

      print("📤 REQUEST BODY (reset-password):");
      print(requestData);

      final response = await Api().dio.post(
        '/api/v1/reset-password',
        data: requestData,
      );

      print("📥 RESPONSE (reset-password):");
      print(response.data);

      if (response.data is Map<String, dynamic>) {
        return response.data as Map<String, dynamic>;
      } else {
        return {
          'status': 'error',
          'message': 'استجابة غير متوقعة من الخادم',
        };
      }
    } on DioException catch (e) {
      print("❌ Dio Error (reset-password): ${e.message}");
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
      print("❌ Error (reset-password): $e");
      return {
        'status': 'error',
        'message': 'حدث خطأ غير متوقع: $e',
      };
    }
  }
}