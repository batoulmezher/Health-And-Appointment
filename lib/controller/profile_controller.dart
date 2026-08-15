// lib/controller/profile_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:health_appointment_app/models/user_profile.dart';
import 'package:health_appointment_app/services/profile_service.dart';

class ProfileController extends GetxController {
  final ProfileService _profileService = ProfileService();

  var userProfile = Rxn<UserProfile>();
  var isLoading = false.obs;
  var isUpdating = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final result = await _profileService.getProfile();
      isLoading.value = false;
      if (result != null) {
        userProfile.value = result;
      } else {
        errorMessage.value = 'فشل تحميل الملف الشخصي';
      }
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = 'حدث خطأ غير متوقع';
      print('❌ Profile error: $e');
    }
  }

  Future<void> updateProfile({
    required String fullName,
    required String phoneNumber,
    required double weight,
    required String bloodType,
  }) async {
    isUpdating.value = true;
    try {
      final result = await _profileService.updateProfile(
        fullName: fullName,
        phoneNumber: phoneNumber,
        weight: weight,
        bloodType: bloodType,
      );
      isUpdating.value = false;
      if (result != null) {
        userProfile.value = result;
        Get.snackbar(
          'نجاح',
          'تم تحديث الملف الشخصي بنجاح',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade100,
          colorText: Colors.green.shade900,
        );
        Get.back();
      } else {
        Get.snackbar(
          'خطأ',
          'فشل تحديث الملف الشخصي',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900,
        );
      }
    } catch (e) {
      isUpdating.value = false;
      Get.snackbar('خطأ', 'حدث خطأ غير متوقع');
    }
  }

  String getGenderLabel(String gender) {
    switch (gender) {
      case 'M':
        return 'ذكر';
      case 'F':
        return 'أنثى';
      default:
        return 'غير محدد';
    }
  }

  String getRoleLabel(String role) {
    switch (role) {
      case 'PATIENT':
        return 'مريض';
      case 'DOCTOR':
        return 'طبيب';
      case 'SEC':
        return 'سكرتير';
      default:
        return role;
    }
  }

  String getStatusLabel(bool isActive) {
    return isActive ? 'نشط' : 'غير نشط';
  }

   Future<void> logout() async {
    await _profileService.logout();

    GetStorage().remove('token');
    GetStorage().remove('user_id');
    GetStorage().remove('rememberMe');

    Get.offAllNamed('/login');
  }

}