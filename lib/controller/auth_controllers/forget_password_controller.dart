import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_appointment_app/Routes/pages.dart';
import '../../screens/auth/otp_verification_screen.dart';

class ForgetPasswordController extends GetxController {
  final emailOrPhoneController = TextEditingController();

  var isLoading = false.obs;

  void sendResetCode() {
    if (emailOrPhoneController.text.isEmpty) {
      Get.snackbar(
        'تنبيه',
        'يرجى إدخال البريد الإلكتروني أو رقم الهاتف',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
      return;
    }

    isLoading.value = true;

    Future.delayed(const Duration(seconds: 2), () {
      isLoading.value = false;
      
      Get.snackbar(
        'نجاح',
        'تم إرسال رمز الاستعادة إلى بريدك الإلكتروني',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade900,
      );

      Get.toNamed(
        AppRoutes.otpVerification,
        arguments: {
          'emailOrPhone': emailOrPhoneController.text.trim(),
        },
      );
    });
  }

  @override
  void onClose() {
    emailOrPhoneController.dispose();
    super.onClose();
  }
}