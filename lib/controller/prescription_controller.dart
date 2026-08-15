// lib/controller/prescription_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_appointment_app/models/prescription.dart';
import 'package:health_appointment_app/services/prescription_service.dart';

class PrescriptionController extends GetxController {
  final PrescriptionService _prescriptionService = PrescriptionService();

  var prescriptions = <Prescription>[].obs;
  var filteredPrescriptions = <Prescription>[].obs;
  var isLoading = false.obs;
  var isDownloading = false.obs;
  var errorMessage = ''.obs;
  var searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPrescriptions();
  }

  Future<void> fetchPrescriptions() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final result = await _prescriptionService.getPrescriptions();
      isLoading.value = false;
      if (result != null) {
        prescriptions.value = result;
        filteredPrescriptions.value = result;
        if (result.isEmpty) {
          errorMessage.value = 'لا توجد وصفات طبية';
        }
      } else {
        errorMessage.value = 'فشل تحميل الوصفات';
      }
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = 'حدث خطأ غير متوقع';
    }
  }

  void search(String query) {
    searchQuery.value = query;
    if (query.trim().isEmpty) {
      filteredPrescriptions.value = prescriptions;
    } else {
      filteredPrescriptions.value = prescriptions.where((p) {
        final doctorName = p.appointment.doctorName.toLowerCase();
        final instructions = p.instructions.toLowerCase();
        final searchLower = query.toLowerCase();
        return doctorName.contains(searchLower) ||
            instructions.contains(searchLower);
      }).toList();
    }
  }

  void clearSearch() {
    searchQuery.value = '';
    filteredPrescriptions.value = prescriptions;
  }

  Future<void> downloadPrescription(int id) async {
    isDownloading.value = true;
    try {
      final filePath = await _prescriptionService.downloadPrescriptionFile(id);
      isDownloading.value = false;
      if (filePath != null) {
        Get.snackbar(
          'نجاح',
          'تم تحميل الملف بنجاح',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade100,
          colorText: Colors.green.shade900,
        );
       // await OpenFile.open(filePath);
      } else {
        Get.snackbar('خطأ', 'فشل تحميل الملف');
      }
    } catch (e) {
      isDownloading.value = false;
      Get.snackbar('خطأ', 'حدث خطأ غير متوقع');
    }
  }
}