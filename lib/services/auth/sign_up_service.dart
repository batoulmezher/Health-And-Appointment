import 'package:dio/dio.dart';
import 'package:health_appointment_app/api/api.dart';

class SignUpService { 
   Future<Map<String, dynamic>?> postSignUpData({
    required String email,
    required String password,
    required String full_name,
    required String phone_number,
    required String gender,
    required int age,
    required double weight,
    required double height,
    required String blood_type,
    required bool has_chronic_disease,
    String chronic_disease_description = '',
    String current_medications = '',
  }) async {
    try {
      final Map<String, dynamic> requestData = {
        "email": email,
        "password": password,
        "full_name": full_name,
        "phone_number": phone_number,
        "gender": gender,
        "age": age,
        "weight": weight,
        "height": height,
        "blood_type": blood_type,
        "has_chronic_disease": has_chronic_disease,
        "chronic_disease_description": chronic_disease_description,
        "current_medications": current_medications,
      };

      // طباعة الطلب للتصحيح (Debug)
      print("📤 REQUEST BODY:");
      print(requestData);

      final response = await Api().dio.post(
        '/api/v1/register',
        data: requestData,
      );

      print("📥 RESPONSE:");
      print(response.data);

      // تأكد من أن الاستجابة تحتوي على البيانات المطلوبة
      if (response.data is Map<String, dynamic>) {
        return response.data as Map<String, dynamic>;
      } else {
        return {
          'success': false,
          'message': 'استجابة غير متوقعة من الخادم',
        };
      }
    } on DioException catch (e) {
      // معالجة أخطاء Dio بشكل خاص
      print("❌ Dio Error: ${e.message}");
      print("❌ Response Data: ${e.response?.data}");

      if (e.response?.data is Map<String, dynamic>) {
        return {
          'success': false,
          'message': e.response?.data['message'] ?? 'خطأ في الاتصال بالخادم',
        };
      }
      return {
        'success': false,
        'message': 'خطأ في الاتصال بالخادم',
      };
    } catch (e) {
      print("❌ Sign up error: $e");
      return {
        'success': false,
        'message': 'حدث خطأ غير متوقع: $e',
      };
    }
  }
}