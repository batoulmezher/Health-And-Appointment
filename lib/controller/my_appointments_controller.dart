// lib/controller/my_appointments_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_appointment_app/models/appointment%20_model.dart';
import 'package:health_appointment_app/services/appointment_service.dart';

class MyAppointmentsController extends GetxController {
  final AppointmentService _appointmentService = AppointmentService();

  var appointments = <AppointmentModel>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  
  var isCancelling = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAppointments();
  }

  Future<void> fetchAppointments() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final result = await _appointmentService.getAppointments();
      isLoading.value = false;
      if (result != null) {
        appointments.value = result;
        if (result.isEmpty) {
          errorMessage.value = 'لا توجد مواعيد حالياً';
        }
      } else {
        errorMessage.value = 'حدث خطأ أثناء جلب المواعيد';
      }
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = 'حدث خطأ غير متوقع';
    }
  }

  Future<void> cancelAppointment(int appointmentId, int index) async {
    if (isCancelling.value) return;
    
    isCancelling.value = true;
    try {
      final success = await _appointmentService.cancelAppointment(appointmentId);
      isCancelling.value = false;
      
      if (success) {
        appointments.removeAt(index);
        Get.snackbar(
          'نجاح',
          'تم إلغاء الموعد بنجاح',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade100,
          colorText: Colors.green.shade900,
        );
      } else {
        Get.snackbar(
          'خطأ',
          'فشل إلغاء الموعد، يرجى المحاولة لاحقاً',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900,
        );
      }
    } catch (e) {
      isCancelling.value = false;
      Get.snackbar('خطأ', 'حدث خطأ غير متوقع');
    }
  }
}