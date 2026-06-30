import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_appointment_app/Routes/pages.dart';

class OtpVerificationController extends GetxController {
  // 🔥 استخدام TextEditingController واحد بدلاً من قائمة
  final TextEditingController otpController = TextEditingController();
  final FocusNode otpFocusNode = FocusNode();

  // متغيرات العداد
  var remainingSeconds = 120.obs;
  var isLoading = false.obs;

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    startTimer();
  }

  void startTimer() {
    _timer?.cancel();
    remainingSeconds.value = 120;
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (remainingSeconds.value > 0) {
          remainingSeconds.value--;
        } else {
          timer.cancel();
          _timer = null;
        }
      },
    );
  }

  void resendCode() {
    startTimer();
    Get.snackbar(
      'نجاح',
      'تم إعادة إرسال الرمز إلى هاتفك المحمول',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.shade100,
      colorText: Colors.green.shade900,
    );
  }

  void verifyOtp() {
    String otp = otpController.text.trim();

    if (otp.length < 4) {
      Get.snackbar(
        'تنبيه',
        'يرجى إدخال الرمز المكون من 4 أرقام بالكامل',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
      return;
    }
  Get.offAllNamed(AppRoutes.resetPassword);

    // هنا يمكن استدعاء API للتحقق
    // await apiService.verifyOtp(otp);

    Get.snackbar(
      'نجاح',
      'تم التحقق من هويتك بنجاح',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.shade100,
      colorText: Colors.green.shade900,
    );

    // التوجيه إلى شاشة إعادة تعيين كلمة المرور
    // Get.offAllNamed('/reset-password');
  }

  @override
  void onClose() {
    _timer?.cancel();
    _timer = null;
    otpController.dispose();
    otpFocusNode.dispose();
    super.onClose();
  }
}