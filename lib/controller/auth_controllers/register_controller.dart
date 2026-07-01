import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_appointment_app/Routes/pages.dart';
import 'package:health_appointment_app/services/auth/sign_up_service.dart';
import 'dart:io';
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

  final SignUpService _signUpService = SignUpService();

  void togglePasswordVisibility() => obscurePassword.toggle();

  void setGender(String value) => selectedGender.value = value;
  void setBloodType(String value) => selectedBloodType.value = value;
  void setHasChronicDisease(bool value) => hasChronicDisease.value = value;

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageFile.value = File(pickedFile.path);
    }
  }

  Future<void> register() async {
    if (fullNameController.text.isEmpty) {
      Get.snackbar("خطأ", "يرجى إدخال الاسم الكامل",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900);
      return;
    }

    if (phoneController.text.isEmpty) {
      Get.snackbar("خطأ", "يرجى إدخال رقم الهاتف",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900);
      return;
    }

    if (emailController.text.isEmpty || !_isValidEmail(emailController.text)) {
      Get.snackbar("خطأ", "يرجى إدخال بريد إلكتروني صحيح",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900);
      return;
    }

    if (passwordController.text.isEmpty || passwordController.text.length < 6) {
      Get.snackbar("خطأ", "كلمة المرور يجب أن تكون 6 أحرف على الأقل",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900);
      return;
    }

    if (selectedGender.value.isEmpty) {
      Get.snackbar("خطأ", "يرجى اختيار الجنس",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900);
      return;
    }

    if (selectedBloodType.value.isEmpty) {
      Get.snackbar("خطأ", "يرجى اختيار فصيلة الدم",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900);
      return;
    }

    if (ageController.text.isEmpty) {
      Get.snackbar("خطأ", "يرجى إدخال العمر",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900);
      return;
    }
 
    // تحويل البيانات
    final int age = int.tryParse(ageController.text.trim()) ?? 0;
    final double weight = double.tryParse(weightController.text.trim()) ?? 0;
    final double height = double.tryParse(heightController.text.trim()) ?? 0;

    if ( age <= 0) {
      Get.snackbar("خطأ", "يرجى إدخال قيم صحيحة للأرقام",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900);
      return;
    }

    // بدء التحميل
    isLoading.value = true;

    try {
      final response = await _signUpService.postSignUpData(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        full_name: fullNameController.text.trim(),
        phone_number: phoneController.text.trim(),
        gender: selectedGender.value,
        age: age,
        weight: weight,
        height: height,
        blood_type: selectedBloodType.value,
        has_chronic_disease: hasChronicDisease.value,
        chronic_disease_description: chronicDiseaseController.text.trim(),
        current_medications: medicationsController.text.trim(),
      );

      if (response != null && response['status'] == 'success') {
        Get.snackbar(
          "نجاح",
          response['message'] ?? "تم إنشاء الحساب بنجاح",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade100,
          colorText: Colors.green.shade900,
        );
        Future.delayed(const Duration(seconds: 1), () {
          Get.offAllNamed(AppRoutes.otpRegister);
        });
      } else {
        String errorMessage = response?['message'] ?? "حدث خطأ أثناء التسجيل";
        Get.snackbar(
          "فشل التسجيل",
          errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900,
        );
      }
    } catch (e) {
      Get.snackbar(
        "خطأ",
        "حدث خطأ في الاتصال بالخادم: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
      print("Registration error: $e");
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