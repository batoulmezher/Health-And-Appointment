// lib/controller/auth_controllers/register_controller.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:health_appointment_app/controller/user_controller.dart';
import 'package:health_appointment_app/models/doctor_model.dart';
import 'package:health_appointment_app/services/auth/sign_up_service.dart';
import 'package:image_picker/image_picker.dart';

class RegisterController extends GetxController {
  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  final ageController = TextEditingController();
  final chronicDiseaseController = TextEditingController();
  final familyHistoryController = TextEditingController();
  final medicationsController = TextEditingController();

  var selectedGender = "".obs;
  var selectedBloodType = "".obs;
  var hasChronicDisease = false.obs;

  var imageFile = Rx<File?>(null);
  final ImagePicker _picker = ImagePicker();

  var obscurePassword = true.obs;
  var isLoading = false.obs;

  final SignUpService _registerService = SignUpService();

  void togglePasswordVisibility() => obscurePassword.toggle();

  void setGender(String value) => selectedGender.value = value;
  void setBloodType(String value) => selectedBloodType.value = value;
  void setHasChronicDisease(bool value) => hasChronicDisease.value = value;

  Future<void> pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );
      if (pickedFile != null) {
        imageFile.value = File(pickedFile.path);
        print("📸 Image selected: ${imageFile.value?.path}");
      } else {
        print("⚠️ No image selected");
      }
    } catch (e) {
      print("❌ Image picker error: $e");
      if (e.toString().contains('already_active')) {
        await Future.delayed(const Duration(milliseconds: 500));
      }
    }
  }

  Future<void> pickImageFromCamera() async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );
      if (pickedFile != null) {
        imageFile.value = File(pickedFile.path);
        print("📸 Image captured: ${imageFile.value?.path}");
      }
    } catch (e) {
      print("❌ Camera error: $e");
      if (e.toString().contains('already_active')) {
        await Future.delayed(const Duration(milliseconds: 500));
      }
    }
  }

  Future<void> register() async {
    if (fullNameController.text.isEmpty) {
      Get.snackbar('خطأ', 'يرجى إدخال الاسم الكامل',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900);
      return;
    }
    if (phoneController.text.isEmpty) {
      Get.snackbar('خطأ', 'يرجى إدخال رقم الهاتف',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900);
      return;
    }
    if (emailController.text.isEmpty || !_isValidEmail(emailController.text)) {
      Get.snackbar('خطأ', 'يرجى إدخال بريد إلكتروني صحيح',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900);
      return;
    }
    if (passwordController.text.isEmpty || passwordController.text.length < 6) {
      Get.snackbar('خطأ', 'كلمة المرور يجب أن تكون 6 أحرف على الأقل',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900);
      return;
    }
    if (selectedGender.value.isEmpty) {
      Get.snackbar('خطأ', 'يرجى اختيار الجنس',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900);
      return;
    }
    if (selectedBloodType.value.isEmpty) {
      Get.snackbar('خطأ', 'يرجى اختيار فصيلة الدم',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900);
      return;
    }
    if (ageController.text.isEmpty) {
      Get.snackbar('خطأ', 'يرجى إدخال العمر',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900);
      return;
    }

    final int phoneNumber = int.tryParse(phoneController.text.trim()) ?? 0;
    final int age = int.tryParse(ageController.text.trim()) ?? 0;
    final double weight = double.tryParse(weightController.text.trim()) ?? 0;
    final double height = double.tryParse(heightController.text.trim()) ?? 0;

    if (phoneNumber <= 0 || age <= 0 || weight <= 0 || height <= 0) {
      Get.snackbar('خطأ', 'يرجى إدخال قيم صحيحة للأرقام',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900);
      return;
    }

    isLoading.value = true;

    try {
      print("📸 Image file: ${imageFile.value?.path ?? 'None'}");

      final response = await _registerService.registerWithImage(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        fullName: fullNameController.text.trim(),
        phoneNumber: phoneNumber,
        gender: selectedGender.value,
        age: age,
        weight: weight,
        height: height,
        bloodType: selectedBloodType.value,
        hasChronicDisease: hasChronicDisease.value,
        chronicDiseaseDescription: chronicDiseaseController.text.trim(),
        currentMedications: medicationsController.text.trim(),
        imageFile: imageFile.value,
      );

      if (response != null && response['status'] == 'success') {
        final token = response['data']?['token'];
        if (token != null) {
          await GetStorage().write('token', token);
        }

        final userData = response['data'];
        if (userData != null) {
          final user = User.fromJson(userData);
          Get.find<UserController>().setUser(user);
          print("📸 Profile picture URL: ${user.profilePictureUrl}");
        }

        Get.snackbar('نجاح', response['message'] ?? 'تم إنشاء الحساب بنجاح',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green.shade100,
            colorText: Colors.green.shade900);

        await Future.delayed(const Duration(seconds: 1));
        Get.toNamed('/otpRegister', arguments: emailController.text.trim());
      } else {
        String errorMessage = response?['message'] ?? 'حدث خطأ أثناء التسجيل';
        Get.snackbar('فشل التسجيل', errorMessage,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.shade100,
            colorText: Colors.red.shade900);
      }
    } catch (e) {
      Get.snackbar('خطأ', 'حدث خطأ في الاتصال بالخادم: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900);
      print("❌ Registration error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  @override
  void onClose() {
    fullNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    heightController.dispose();
    weightController.dispose();
    ageController.dispose();
    chronicDiseaseController.dispose();
    familyHistoryController.dispose();
    medicationsController.dispose();
    super.onClose();
  }
}