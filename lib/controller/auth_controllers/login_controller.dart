import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:health_appointment_app/Routes/pages.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final rememberMe = false.obs;
  final obscurePassword = true.obs;

  void login() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('خطأ', 'يرجى ملء جميع الحقول',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    Get.offAllNamed(AppRoutes.mainScreen);
    print('تسجيل الدخول: $email - $password');

  }

  void goToRegister() {
    Get.toNamed(AppRoutes.register);
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}