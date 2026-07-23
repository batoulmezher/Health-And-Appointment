// lib/controller/specialties_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:health_appointment_app/models/specialty_model.dart';
import 'package:health_appointment_app/services/specialties_service.dart';

class SpecialtiesController extends GetxController {
  final searchController = TextEditingController();
  final SpecialtiesService _specialtiesService = SpecialtiesService();

  var allSpecialties = <SpecialtyModel>[].obs;
  var filteredSpecialties = <SpecialtyModel>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSpecialties();
  }

  Future<void> fetchSpecialties() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final result = await _specialtiesService.getSpecialties();
      if (result != null && result.isNotEmpty) {
        allSpecialties.value = result;
        filteredSpecialties.value = result;
        print("✅ Specialties loaded: ${result.length}");
      } else {
        if (GetStorage().read('token') == null) {
          errorMessage.value = 'يرجى تسجيل الدخول مرة أخرى';
        } else {
          errorMessage.value = 'لم نتمكن من تحميل التخصصات';
        }
      }
    } catch (e) {
      errorMessage.value = 'حدث خطأ أثناء تحميل البيانات';
      print("❌ Specialties fetch error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void filterSpecialties(String query) {
    if (query.isEmpty) {
      filteredSpecialties.value = allSpecialties;
      return;
    }
    filteredSpecialties.value = allSpecialties
        .where((spec) => spec.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  IconData getIconForSpecialty(String name) {
    final lowerName = name.toLowerCase();
    if (lowerName.contains('cardio') || lowerName.contains('heart')) return Icons.favorite;
    if (lowerName.contains('derma') || lowerName.contains('skin')) return Icons.spa;
    if (lowerName.contains('neuro') || lowerName.contains('brain')) return Icons.psychology;
    if (lowerName.contains('ophthal') || lowerName.contains('eye')) return Icons.visibility;
    if (lowerName.contains('pediat') || lowerName.contains('child')) return Icons.child_care;
    if (lowerName.contains('ortho') || lowerName.contains('bone')) return Icons.accessibility_new;
    if (lowerName.contains('psych') || lowerName.contains('mental')) return Icons.mood;
    if (lowerName.contains('dent') || lowerName.contains('tooth')) return Icons.medical_services;
    if (lowerName.contains('ent') || lowerName.contains('ear')) return Icons.hearing;
    if (lowerName.contains('general') || lowerName.contains('family')) return Icons.local_hospital;
    if (lowerName.contains('emergency')) return Icons.emergency;
    return Icons.medical_services;
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}