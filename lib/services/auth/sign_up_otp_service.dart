import 'package:dio/dio.dart';
import 'package:health_appointment_app/api/api.dart';

class SignUpOtpService {
  Future<Map<String, dynamic>?> postOtpData({
    required String otp,
    required String email,
  }) async {
    try {
      final Map<String, dynamic> requestData = {
        "otp": otp,
        "email": email,
      };

      print("📤 REQUEST BODY:");
      print(requestData);

      final response = await Api().dio.post(
        '/api/v1/verify-otp',
        data: requestData,
      );

      print("📥 RESPONSE:");
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
      print("❌ OTP verification error: $e");
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

      print("📤 REQUEST BODY:");
      print(requestData);

      final response = await Api().dio.post(
        '/api/v1/resend-otp',
        data: requestData,
      );

      print("📥 RESPONSE:");
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
      print("❌ OTP verification error: $e");
      return {
        'status': 'error',
        'message': 'حدث خطأ غير متوقع: $e',
      };
    }
  }
}