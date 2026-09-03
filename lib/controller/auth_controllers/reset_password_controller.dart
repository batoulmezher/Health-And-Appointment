// lib/controller/auth_controllers/reset_password_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_appointment_app/Routes/pages.dart';
import 'package:health_appointment_app/services/auth/forget_password_services.dart';

class ResetPasswordController extends GetxController {
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final ForgetPasswordServices _forgetPasswordServices =
      ForgetPasswordServices();

  var obscureNewPassword = true.obs;
  var obscureConfirmPassword = true.obs;
  var isLoading = false.obs;
  var passwordStrength = ''.obs;

  String? _email;
  String? _otp;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;
    if (args is Map) {
      _email = args['email'];
      _otp = args['otp'];
    }

    if (_email == null || _email!.isEmpty || _otp == null || _otp!.isEmpty) {
      Future.delayed(Duration.zero, () {
        Get.snackbar(
          'خطأ',
          'بيانات غير مكتملة',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900,
        );
        Get.back();
      });
    }
  }

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

  Future<void> resetPassword() async {
    final String newPassword = newPasswordController.text.trim();
    final String confirmPassword = confirmPasswordController.text.trim();

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

    if (_email == null || _email!.isEmpty || _otp == null || _otp!.isEmpty) {
      Get.snackbar(
        'خطأ',
        'بيانات غير مكتملة',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
      return;
    }

    isLoading.value = true;

    try {
      final response = await _forgetPasswordServices.resetPassword(
        email: _email!,
        otp: _otp!,
        password: newPassword,
      );

      print("📥 API RESPONSE (reset-password): $response");
      print("00000000000$_otp");
      if (response != null && response['status'] == 'success') {
        Get.snackbar(
          'نجاح',
          response['message'] ?? 'تم إعادة تعيين كلمة المرور بنجاح',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade100,
          colorText: Colors.green.shade900,
        );

        await Future.delayed(const Duration(seconds: 1));
        Get.offAllNamed(AppRoutes.login);
      } else {
        String errorMessage =
            response?['message'] ?? 'حدث خطأ أثناء إعادة تعيين كلمة المرور';
        Get.snackbar(
          'فشل الإعادة',
          errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900,
        );
      }
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'حدث خطأ في الاتصال بالخادم: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
      print("❌ Reset password error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
