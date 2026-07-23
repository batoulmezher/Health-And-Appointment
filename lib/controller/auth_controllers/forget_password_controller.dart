import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_appointment_app/Routes/pages.dart';
import 'package:health_appointment_app/services/auth/forget_password_services.dart';

class ForgetPasswordController extends GetxController {
  final emailController = TextEditingController();
  final ForgetPasswordServices _forgetPasswordServices = ForgetPasswordServices();
  var isLoading = false.obs;

  Future<void> sendResetCode() async {
    final String email = emailController.text.trim();

    if (email.isEmpty) {
      Get.snackbar(
        'تنبيه',
        'يرجى إدخال البريد الإلكتروني',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
      return;
    }

    if (!GetUtils.isEmail(email)) {
      Get.snackbar(
        'تنبيه',
        'يرجى إدخال بريد إلكتروني صحيح',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
      return;
    }

    isLoading.value = true;

    try {
      final response = await _forgetPasswordServices.postForgetPasswordData(
        email: email,
      );

      if (response != null && response['status'] == 'success') {
       
        Get.snackbar(
          "نجاح",
          response['message'] ?? "تم إرسال رمز التحقق إلى بريدك الإلكتروني",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade100,
          colorText: Colors.green.shade900,
        );

        await Future.delayed(const Duration(seconds: 1));
        Get.toNamed(
          AppRoutes.otpVerification,
          arguments: email, 
        );
      } else {
        String errorMessage = response?['message'] ?? "حدث خطأ أثناء إرسال الرمز";
        Get.snackbar(
          "فشل الإرسال",
          errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900,
        );
      }
    } catch (e) {
      Get.snackbar(
        "خطأ",
        "حدث خطأ في الاتصال بالخادم: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
      print("❌ Error (sendResetCode): $e");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}