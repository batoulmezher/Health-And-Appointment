// lib/controller/auth_controllers/otp_verification_controller.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_appointment_app/Routes/pages.dart';
import 'package:health_appointment_app/services/auth/forget_password_services.dart';

class OtpVerificationController extends GetxController {
  final TextEditingController otpController = TextEditingController();
  final FocusNode otpFocusNode = FocusNode();
  final ForgetPasswordServices _forgetPasswordServices = ForgetPasswordServices();

  var remainingSeconds = 120.obs;
  var isLoading = false.obs;
  bool _isClosed = false;
  String? _email;

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    startTimer();

    final args = Get.arguments;
    if (args is String) {
      _email = args;
    } else if (args is Map) {
      _email = args['email'] ?? args['emailOrPhone'] as String?;
    }

    if (_email == null || _email!.isEmpty) {
      Future.delayed(Duration.zero, () {
        Get.snackbar(
          'خطأ',
          'لم يتم تمرير البريد الإلكتروني',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900,
        );
        Get.back();
      });
    }
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

  Future<void> resendCode() async {
    if (_isClosed) return;

    if (_email == null || _email!.isEmpty) {
      Get.snackbar(
        'خطأ',
        'البريد الإلكتروني غير موجود',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
      return;
    }

    startTimer();
    Get.snackbar(
      'نجاح',
      'تم إعادة إرسال الرمز إلى بريدك الإلكتروني',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.shade100,
      colorText: Colors.green.shade900,
    );

    try {
      await _forgetPasswordServices.resendOtp(email: _email!);
    } catch (e) {
      print("❌ Error resending OTP: $e");
    }
  }
////////////////////////////
  Future<void> verifyOtp() async {
    

    final String otp = otpController.text.trim();

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

    if (_email == null || _email!.isEmpty) {
      Get.snackbar(
        'خطأ',
        'البريد الإلكتروني غير موجود',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
      return;
    }

    isLoading.value = true;

     Get.offAllNamed(
          AppRoutes.resetPassword,
          arguments: {
            'email': _email!,
            'otp': otp,
          },
        );
  }

  @override
  void onClose() {
    _isClosed = true;
    _timer?.cancel();
    _timer = null;
    super.onClose();
  }
}