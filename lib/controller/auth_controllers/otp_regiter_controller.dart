// lib/controller/auth_controllers/otp_regiter_controller.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:health_appointment_app/Routes/pages.dart';
import 'package:health_appointment_app/controller/user_controller.dart';
import 'package:health_appointment_app/models/doctor_model.dart';
import 'package:health_appointment_app/services/auth/sign_up_otp_service.dart';

class OtpRegiterController extends GetxController {
  final TextEditingController otpController = TextEditingController();
  final FocusNode otpFocusNode = FocusNode();
  final SignUpOtpService _signUpOtpService = SignUpOtpService();

  var remainingSeconds = 120.obs;
  var isLoading = false.obs;

  Timer? _timer;
  bool _isClosed = false;
  String? _email;

  @override
  void onInit() {
    super.onInit();
    startTimer();
    _email = Get.arguments as String?;
    if (_email == null || _email!.isEmpty) {
      Future.delayed(Duration.zero, () {
        Get.snackbar('خطأ', 'لم يتم تمرير البريد الإلكتروني');
        Get.back();
      });
    }
  }

  void startTimer() {
    if (_isClosed) return;
    _timer?.cancel();
    remainingSeconds.value = 120;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
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
    });
  }

  Future<void> resendCode() async {
    if (_isClosed) return;
    startTimer();
    Get.snackbar('نجاح', 'تم إعادة إرسال الرمز إلى بريدك الإلكتروني',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade900);
  }

  Future<void> verifyOtp() async {
    if (_isClosed) return;

    final String otp = otpController.text.trim();

    if (otp.length < 6) {
      Get.snackbar('تنبيه', 'يرجى إدخال الرمز المكون من 6 أرقام بالكامل',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900);
      return;
    }

    if (_email == null || _email!.isEmpty) {
      Get.snackbar('خطأ', 'البريد الإلكتروني غير موجود',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900);
      return;
    }

    isLoading.value = true;

    try {
      final response = await _signUpOtpService.postOtpData(
        otp: otp,
        email: _email!,
      );

      if (response != null && response['status'] == 'success') {
  final token = response['data']?['token'];
  if (token != null) {
    await GetStorage().write('token', token);
  }

  final userData = response['data']?['user'];
  if (userData != null) {
    final user = User.fromJson(userData);
    Get.find<UserController>().setUser(user);
    print("📸 Profile picture URL: ${user.profilePictureUrl}");
  }

  Get.snackbar('نجاح', 'تم التحقق من هويتك بنجاح');
  await Future.delayed(const Duration(seconds: 1));
  Get.offAllNamed(AppRoutes.login);
} else {
        String errorMessage =
            response?['message'] ?? "الرمز غير صحيح أو منتهي الصلاحية";
        Get.snackbar('فشل التحقق', errorMessage,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.shade100,
            colorText: Colors.red.shade900);

      }
    } catch (e) {
      Get.snackbar('خطأ', 'حدث خطأ في الاتصال بالخادم: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900);
      print("❌ Verification error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    _isClosed = true;
    _timer?.cancel();
    _timer = null;
    super.onClose();
  }
}