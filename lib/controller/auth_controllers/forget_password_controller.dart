import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_appointment_app/Routes/pages.dart';
import '../../screens/auth/otp_verification_screen.dart';

class ForgetPasswordController extends GetxController {
  // حقل الإدخال
  final emailOrPhoneController = TextEditingController();

  // حالة التحميل (للتحقق من عدم إرسال طلبين)
  var isLoading = false.obs;

  // دالة إرسال رمز الاستعادة
  void sendResetCode() {
    // التحقق من الحقل
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

    // تحميل البيانات وإرسال الطلب (محاكاة)
    isLoading.value = true;

    // هنا يمكن إضافة استدعاء API
    // مثال:
    // await apiService.sendResetCode(emailOrPhoneController.text);

    // محاكاة نجاح العملية
    Future.delayed(const Duration(seconds: 2), () {
      isLoading.value = false;
      
      // إظهار رسالة نجاح
      Get.snackbar(
        'نجاح',
        'تم إرسال رمز الاستعادة إلى بريدك الإلكتروني',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade900,
      );

      // ✅ التوجيه إلى شاشة التحقق من الهوية مع تمرير البريد الإلكتروني أو رقم الهاتف
      // يمكن تمرير البيانات عبر arguments
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