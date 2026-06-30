import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ResetPasswordController extends GetxController {
  // حقول كلمة المرور
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // إظهار/إخفاء كلمة المرور
  var obscureNewPassword = true.obs;
  var obscureConfirmPassword = true.obs;

  // حالة التحميل
  var isLoading = false.obs;

  // قوة كلمة المرور
  var passwordStrength = ''.obs;

  // تبديل إظهار/إخفاء كلمة المرور الجديدة
  void toggleNewPasswordVisibility() {
    obscureNewPassword.value = !obscureNewPassword.value;
  }

  // تبديل إظهار/إخفاء تأكيد كلمة المرور
  void toggleConfirmPasswordVisibility() {
    obscureConfirmPassword.value = !obscureConfirmPassword.value;
  }

  // حساب قوة كلمة المرور
  String calculatePasswordStrength(String password) {
    if (password.isEmpty) return '';
    if (password.length < 6) return 'ضعيفة';
    if (password.length >= 6 && password.length < 10) {
      // تحتوي على أرقام وحروف
      if (RegExp(r'[0-9]').hasMatch(password) &&
          RegExp(r'[a-zA-Z]').hasMatch(password)) {
        return 'متوسطة';
      }
      return 'ضعيفة';
    }
    if (password.length >= 10) {
      // تحتوي على أرقام وحروف ورموز خاصة
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

  // إعادة تعيين كلمة المرور
  void resetPassword() {
    String newPassword = newPasswordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    // التحقق من أن الحقول ليست فارغة
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

    // التحقق من تطابق كلمتي المرور
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

    // التحقق من قوة كلمة المرور
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

    // محاكاة تحميل
    isLoading.value = true;

    // هنا يمكن إضافة استدعاء API
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
      // التوجيه إلى شاشة تسجيل الدخول
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