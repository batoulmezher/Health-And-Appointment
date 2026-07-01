import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ResetPasswordController extends GetxController {
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  var obscureNewPassword = true.obs;
  var obscureConfirmPassword = true.obs;

  var isLoading = false.obs;

  var passwordStrength = ''.obs;

  void toggleNewPasswordVisibility() {
    obscureNewPassword.value = !obscureNewPassword.value;
  }

  void toggleConfirmPasswordVisibility() {
    obscureConfirmPassword.value = !obscureConfirmPassword.value;
  }

  String calculatePasswordStrength(String password) {
    if (password.isEmpty) return '';
    if (password.length < 6) return 'ضعيفة';
    if (password.length >= 6 && password.length < 10) {
      if (RegExp(r'[0-9]').hasMatch(password) &&
          RegExp(r'[a-zA-Z]').hasMatch(password)) {
        return 'متوسطة';
      }
      return 'ضعيفة';
    }
    if (password.length >= 10) {
      if (RegExp(r'[0-9]').hasMatch(password) &&
          RegExp(r'[a-zA-Z]').hasMatch(password) &&
          RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
        return 'قوية';
      }
      if (RegExp(r'[0-9]').hasMatch(password) &&
          RegExp(r'[a-zA-Z]').hasMatch(password)) {
        return 'متوسطة';
      }
      return 'ضعيفة';
    }
    return 'ضعيفة';
  }

  void resetPassword() {
    String newPassword = newPasswordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      Get.snackbar(
        'تنبيه',
        'يرجى إدخال كلمة المرور وتأكيدها',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
      return;
    }

    if (newPassword != confirmPassword) {
      Get.snackbar(
        'خطأ',
        'كلمتا المرور غير متطابقتين',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
      return;
    }

    if (newPassword.length < 6) {
      Get.snackbar(
        'تنبيه',
        'كلمة المرور يجب أن تتكون من 6 أحرف على الأقل',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
      return;
    }

    isLoading.value = true;

    // await apiService.resetPassword(newPassword);

    Future.delayed(const Duration(seconds: 2), () {
      isLoading.value = false;
      Get.snackbar(
        'نجاح',
        'تم إعادة تعيين كلمة المرور بنجاح',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade900,
      );
      Get.offAllNamed('/login');
    });
  }

  @override
  void onClose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}