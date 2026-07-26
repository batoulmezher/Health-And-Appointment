// lib/controller/doctor_profile_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_appointment_app/models/doctor_model.dart';
import 'package:health_appointment_app/services/doctors_service.dart';

class DoctorProfileController extends GetxController {
  final DoctorsService _doctorsService = DoctorsService();

  var selectedTab = 0.obs;
  var selectedDayIndex = 0.obs;
  var selectedTimeIndex = 0.obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  var doctor = Rxn<DoctorModel>();
  var doctorData = Rxn<Data>();

  var isFollowing = false.obs;
  var isFollowLoading = false.obs;

  var workingDaysList = <DaySchedule>[].obs;
  var dayNames = <String>[].obs;
  List<String> timeSlots = ['09:00 ص', '10:30 ص', '01:00 م', '02:30 م', '04:00 م'];

  @override
  void onInit() {
    super.onInit();
    final int? doctorId = Get.arguments as int?;
    if (doctorId != null) {
      fetchDoctorDetails(doctorId);
    } else {
      errorMessage.value = 'لم يتم تمرير معرف الطبيب';
    }
  }

  Future<void> fetchDoctorDetails(int id) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final result = await _doctorsService.getDoctorById(id);
      if (result != null) {
        doctor.value = result;
        doctorData.value = result.data;
        _extractWorkingDays(result.data?.workingDaysHours);
        // For now, we assume default false; user can toggle.
        print("✅ Doctor loaded: ${result.data?.user?.fullName}");
      } else {
        errorMessage.value = 'لم نتمكن من تحميل بيانات الطبيب';
      }
    } catch (e) {
      errorMessage.value = 'حدث خطأ أثناء تحميل البيانات';
      print("❌ Doctor fetch error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void _extractWorkingDays(WorkingDaysHours? hours) {
    if (hours == null) return;
    final map = {
      'الإثنين': hours.monday,
      'الثلاثاء': hours.tuesday,
      'الأربعاء': hours.wednesday,
      'الخميس': hours.thursday,
      'الجمعة': hours.friday,
      'السبت': hours.saturday,
      'الأحد': hours.sunday,
    };
    dayNames.clear();
    workingDaysList.clear();
    map.forEach((name, schedule) {
      if (schedule != null && schedule.start != null && schedule.end != null) {
        dayNames.add(name);
        workingDaysList.add(schedule);
      }
    });
    if (dayNames.isEmpty) {
      dayNames.addAll(['الإثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة']);
    }
  }

  Future<void> toggleFollow() async {
    if (doctorData.value == null) return;
    isFollowLoading.value = true;
    try {
      final result = await _doctorsService.toggleFollowDoctor(doctorData.value!.id!);
      if (result != null && result['status'] == 'success') {
        isFollowing.value = !isFollowing.value;
        Get.snackbar('نجاح', result['message'] ?? 'تم تحديث حالة المتابعة');
      } else {
        Get.snackbar('خطأ', result?['message'] ?? 'فشل تحديث المتابعة');
      }
    } catch (e) {
      Get.snackbar('خطأ', 'حدث خطأ غير متوقع');
    } finally {
      isFollowLoading.value = false;
    }
  }

  // Getters
  String getFullName() => doctorData.value?.user?.fullName ?? 'طبيب';
  String getSpecialtyName() => doctorData.value?.specialty?.name ?? 'تخصص غير معروف';
  String getRating() => doctorData.value?.ratingAverage ?? '0.0';
  String getConsultationFee() => doctorData.value?.consultationFee ?? '0';
  String getBio() => doctorData.value?.bio ?? 'لا يوجد وصف';
  String getProfileImage() => doctorData.value?.user?.profilePictureUrl ?? '';
  String getEmail() => doctorData.value?.user?.email ?? 'غير متوفر';
  String getPhone() => doctorData.value?.user?.phoneNumber ?? 'غير متوفر';
  String getClinicLocation() => doctorData.value?.clinicLocation ?? 'غير محدد';
  String getGender() {
    final g = doctorData.value?.user?.gender;
    if (g == 'M') return 'ذكر';
    if (g == 'F') return 'أنثى';
    return 'غير محدد';
  }
  String getStatus() => doctorData.value?.status ?? 'غير معروف';
  int getExperience() => doctorData.value?.yearsOfExperience ?? 0;

  void selectDay(int index) => selectedDayIndex.value = index;
  void selectTime(int index) => selectedTimeIndex.value = index;
  void selectTab(int index) => selectedTab.value = index;

  @override
  void onClose() {
    super.onClose();
  }
}