// lib/controller/auth_controllers/login_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:health_appointment_app/Routes/pages.dart';
import 'package:health_appointment_app/controller/user_controller.dart';
import 'package:health_appointment_app/models/doctor_model.dart';
import 'package:health_appointment_app/services/auth/log_in_services.dart';
import 'package:health_appointment_app/services/notification_service.dart';

class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  var obscurePassword = true.obs;
  var isLoading = false.obs;
  var rememberMe = false.obs;

  final GetStorage _box = GetStorage();
  final LogInService _loginService = LogInService();

  @override
  void onInit() {
    super.onInit();
    _loadSavedCredentials();
  }

  void _loadSavedCredentials() {
    final bool? savedRemember = _box.read('rememberMe');
    if (savedRemember == true) {
      rememberMe.value = true;
      final String? savedEmail = _box.read('email');
      final String? savedPassword = _box.read('password');
      if (savedEmail != null && savedPassword != null) {
        emailController.text = savedEmail;
        passwordController.text = savedPassword;
      }
    }
  }

  void toggleRememberMe() {
    rememberMe.value = !rememberMe.value;
    if (!rememberMe.value) {
      _box.remove('email');
      _box.remove('password');
      _box.write('rememberMe', false);
    }
    update();
  }

  Future<void> login() async {
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('تنبيه', 'يرجى إدخال البريد الإلكتروني وكلمة المرور',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900);
      return;
    }

    isLoading.value = true;

    try {
      final response = await _loginService.postData(
        email: email,
        password: password,
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

        if (rememberMe.value) {
          _box.write('email', email);
          _box.write('password', password);
          _box.write('rememberMe', true);
        }

        Get.snackbar('نجاح', response['message'] ?? 'تم تسجيل الدخول بنجاح',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green.shade100,
            colorText: Colors.green.shade900);

        await Future.delayed(const Duration(seconds: 1));


final int userId = userData['id'];

                await NotificationService.saveTokenToBackend(userId);

        Get.offAllNamed(AppRoutes.mainScreen);
      } else {
        String errorMessage = response?['message'] ?? 'فشل تسجيل الدخول';
        Get.snackbar('خطأ', errorMessage,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.shade100,
            colorText: Colors.red.shade900);
      }
    } catch (e) {
      Get.snackbar('خطأ', 'حدث خطأ في الاتصال بالخادم: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900);
      print("❌ Login error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void goToRegister() {
    Get.toNamed(AppRoutes.register);
  }

  void goToForgetPassword() {
    Get.toNamed(AppRoutes.forgotPassword);
  }

  @override
  void onClose() {
    super.onClose();
  }
}