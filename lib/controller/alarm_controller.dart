// lib/controller/alarm_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_appointment_app/models/alarm_model.dart';
import 'package:health_appointment_app/services/alarm_service.dart';
import 'package:health_appointment_app/services/local_notification_service.dart';
import 'package:health_appointment_app/utils/time_utils.dart';

class AlarmController extends GetxController {
  final AlarmService _alarmService = AlarmService();

  var alarms = <AlarmModel>[].obs;
  var isLoading = false.obs;
  var isSaving = false.obs;
  var errorMessage = ''.obs;

  final TextEditingController medicineNameController = TextEditingController();
  final TextEditingController dosageController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController frequencyController = TextEditingController();
  final TextEditingController alarmTimeController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    requestPermissions();
    fetchAlarms();
  }

  @override
  void onClose() {
    medicineNameController.dispose();
    dosageController.dispose();
    quantityController.dispose();
    frequencyController.dispose();
    alarmTimeController.dispose();
    super.onClose();
  }

  Future<void> requestPermissions() async {}

  Future<void> fetchAlarms() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final result = await _alarmService.getAlarms();
      isLoading.value = false;
      if (result != null) {
        alarms.value = result;
        await _scheduleAlarms(result);
        if (result.isEmpty) errorMessage.value = 'لا توجد منبهات';
      } else {
        errorMessage.value = 'فشل تحميل المنبهات';
      }
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = 'حدث خطأ غير متوقع';
      print('❌ Fetch alarms error: $e');
    }
  }

  Future<void> createAlarm() async {
    final medicineName = medicineNameController.text.trim();
    final dosage = dosageController.text.trim();
    final quantity = int.tryParse(quantityController.text.trim()) ?? 0;
    final frequency = frequencyController.text.trim();
    final alarmTime = alarmTimeController.text.trim();

    if (medicineName.isEmpty ||
        dosage.isEmpty ||
        quantity <= 0 ||
        frequency.isEmpty ||
        alarmTime.isEmpty) {
      Get.snackbar(
        'تنبيه',
        'يرجى ملء جميع الحقول بشكل صحيح',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.shade100,
        colorText: Colors.orange.shade900,
      );
      return;
    }

    isSaving.value = true;
    try {
      final result = await _alarmService.createAlarm(
        medicineName: medicineName,
        dosage: dosage,
        quantity: quantity,
        frequency: frequency,
        alarmTime: alarmTime,
      );
      isSaving.value = false;
      if (result != null) {
        alarms.add(result);
        await _scheduleSingleAlarm(result);
        Get.snackbar(
          'نجاح',
          'تم إنشاء المنبه بنجاح',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade100,
          colorText: Colors.green.shade900,
        );
        medicineNameController.clear();
        dosageController.clear();
        quantityController.clear();
        frequencyController.clear();
        alarmTimeController.clear();
      } else {
        Get.snackbar(
          'خطأ',
          'فشل إنشاء المنبه',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900,
        );
      }
    } catch (e) {
      isSaving.value = false;
      Get.snackbar('خطأ', 'حدث خطأ غير متوقع');
    }
  }

  Future<void> toggleAlarm(int id, bool isActive) async {
    final success = await _alarmService.toggleAlarm(id, isActive);
    if (success) {
      final index = alarms.indexWhere((a) => a.id == id);
      if (index != -1) {
        final old = alarms[index];
        alarms[index] = AlarmModel(
          id: old.id,
          medicineName: old.medicineName,
          dosage: old.dosage,
          quantity: old.quantity,
          frequency: old.frequency,
          alarmTime: old.alarmTime,
          isActive: isActive,
          status: old.status,
          createdAt: old.createdAt,
          updatedAt: DateTime.now(),
          patient: old.patient,
        );
        alarms.refresh();
        if (!isActive) {
          //  await AlarmPlusService.cancelAlarm(id);
        } else {
          await _scheduleSingleAlarm(alarms[index]);
        }
      }
    } else {
      Get.snackbar('خطأ', 'فشل تحديث حالة المنبه');
    }
  }

  Future<void> deleteAlarm(int id) async {
    final success = await _alarmService.deleteAlarm(id);
    if (success) {
      alarms.removeWhere((a) => a.id == id);
      // await AlarmPlusService.cancelAlarm(id);
      Get.snackbar(
        'نجاح',
        'تم حذف المنبه',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade900,
      );
    } else {
      Get.snackbar(
        'خطأ',
        'فشل حذف المنبه',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
    }
  }

  Future<void> _scheduleAlarms(List<AlarmModel> alarms) async {
    for (final alarm in alarms) {
      if (alarm.isActive) {
        await _scheduleSingleAlarm(alarm);
      }
    }
  }

  // lib/controller/alarm_controller.dart

  Future<void> _scheduleSingleAlarm(AlarmModel alarm) async {
    if (!alarm.isActive) return;

    try {
      final now = DateTime.now();
      final localTime = parseAlarmTime(alarm.alarmTime, now);
      var finalTime = localTime;
      if (finalTime.isBefore(now)) {
        finalTime = finalTime.add(const Duration(days: 1));
      }
      final utcTime = finalTime.toUtc();

      await LocalNotificationService.scheduleNotification(
        id: alarm.id,
        title: '💊 تذكير دواء',
        body: 'حان وقت تناول ${alarm.medicineName} - ${alarm.dosage}',
        scheduledTime: utcTime,
        payload: 'alarm_${alarm.id}',
      );
    } catch (e) {
      print('❌ Schedule error for ${alarm.medicineName}: $e');
    }
  }
  

  Future<void> openSettings() async {
  }
}
