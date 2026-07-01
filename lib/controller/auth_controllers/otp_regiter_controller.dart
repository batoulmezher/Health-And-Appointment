import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_appointment_app/Routes/pages.dart';

class OtpRegiterController extends GetxController {
  final TextEditingController otpController = TextEditingController();
  final FocusNode otpFocusNode = FocusNode();

  var remainingSeconds = 120.obs;
  var isLoading = false.obs;

  Timer? _timer;
  bool _isClosed = false; // ✅ علم لمنع الوصول بعد الإغلاق

  @override
  void onInit() {
    super.onInit();
    startTimer();
  }

  void startTimer() {
    if (_isClosed) return;
    _timer?.cancel();
    remainingSeconds.value = 120;
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (_isClosed) {
          timer.cancel();
          return;
        }
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
    if (_isClosed) return;
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
    if (_isClosed) return;
    String otp = otpController.text.trim();

    if (otp.length < 6) {
      Get.snackbar(
        'تنبيه',
        'يرجى إدخال الرمز المكون من 6 أرقام بالكامل',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
      return;
    }

    // الانتقال إلى شاشة تسجيل الدخول
    Get.offAllNamed(AppRoutes.login);

    // عرض رسالة نجاح (قد تظهر قبل الانتقال، لكنها لا تؤثر)
    Get.snackbar(
      'نجاح',
      'تم التحقق من هويتك بنجاح',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.shade100,
      colorText: Colors.green.shade900,
    );
  }

  @override
  void onClose() {
    _isClosed = true;
    _timer?.cancel();
    _timer = null;
    // لا نحرر الـ Controllers يدوياً (نتركها للـ Garbage Collector)
    super.onClose();
  }
} 