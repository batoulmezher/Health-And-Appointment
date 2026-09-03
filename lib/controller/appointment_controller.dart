// lib/controller/appointment_controller.dart
import 'package:get/get.dart';
import 'package:health_appointment_app/services/appointment_service.dart';
import 'package:health_appointment_app/services/doctors_service.dart';
import 'package:intl/intl.dart';

class AppointmentController extends GetxController {
  final DoctorsService _doctorsService = DoctorsService();
  final AppointmentService _appointmentService = AppointmentService();

  var selectedDate = ''.obs;          // YYYY-MM-DD
  var selectedTime = ''.obs;
  var availableTimes = <String>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  var currentMonth = DateTime.now().month.obs;
  var currentYear = DateTime.now().year.obs;
  var daysList = <Map<String, dynamic>>[].obs; 

  int? doctorId;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is Map) {
      doctorId = Get.arguments['doctorId'];
    }
    if (doctorId == null) {
      errorMessage.value = 'لم يتم تحديد الطبيب';
    } else {
      _generateDaysForMonth(currentYear.value, currentMonth.value);
      final today = DateTime.now();
      if (today.year == currentYear.value && today.month == currentMonth.value) {
        final dateStr = DateFormat('yyyy-MM-dd').format(today);
        selectedDate.value = dateStr;
        fetchAvailableTimes(dateStr);
      } else {
        final firstDay = DateTime(currentYear.value, currentMonth.value, 1);
        final dateStr = DateFormat('yyyy-MM-dd').format(firstDay);
        selectedDate.value = dateStr;
        fetchAvailableTimes(dateStr);
      }
    }
  }

  void _generateDaysForMonth(int year, int month) {
    final firstDayOfMonth = DateTime(year, month, 1);
    final lastDayOfMonth = DateTime(year, month + 1, 0);
    final today = DateTime.now();
    final List<Map<String, dynamic>> days = [];

    for (int day = 1; day <= lastDayOfMonth.day; day++) {
      final date = DateTime(year, month, day);
      final dateStr = DateFormat('yyyy-MM-dd').format(date);
      final isPast = date.isBefore(DateTime(today.year, today.month, today.day));
      final isToday = date.year == today.year && date.month == today.month && date.day == today.day;

      if (year > today.year || (year == today.year && month > today.month)) {
        days.add({
          'day': day.toString(),
          'dateString': dateStr,
          'isToday': false,
          'isPast': false,
        });
      } else if (year == today.year && month == today.month) {
        if (!isPast || isToday) {
          days.add({
            'day': day.toString(),
            'dateString': dateStr,
            'isToday': isToday,
            'isPast': false,
          });
        }
      } else {
       
      }
    }
    daysList.value = days;
    update();
  }

  void changeMonth(int delta) {
    int newMonth = currentMonth.value + delta;
    int newYear = currentYear.value;
    if (newMonth > 12) {
      newMonth = 1;
      newYear++;
    } else if (newMonth < 1) {
      newMonth = 12;
      newYear--;
    }
    final now = DateTime.now();
    if (newYear < now.year || (newYear == now.year && newMonth < now.month)) {
      return;
    }
    currentYear.value = newYear;
    currentMonth.value = newMonth;
    _generateDaysForMonth(newYear, newMonth);
    if (daysList.isNotEmpty) {
      final firstDateStr = daysList.first['dateString'];
      selectedDate.value = firstDateStr;
      fetchAvailableTimes(firstDateStr);
    }
  }

  void selectDate(String dateString) {
    selectedDate.value = dateString;
    selectedTime.value = '';
    fetchAvailableTimes(dateString);
  }

  void selectTime(String time) {
    selectedTime.value = time;
    update();
  }

  Future<void> fetchAvailableTimes(String date) async {
    if (doctorId == null) {
      errorMessage.value = 'معرف الطبيب غير موجود';
      return;
    }
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final times = await _doctorsService.getDoctorAvailability(doctorId!, date);
      isLoading.value = false;
      if (times != null && times.isNotEmpty) {
        availableTimes.value = times;
      } else if (times != null && times.isEmpty) {
        availableTimes.clear();
        errorMessage.value = 'لا توجد مواعيد متاحة لهذا التاريخ';
      } else {
        availableTimes.clear();
        errorMessage.value = 'حدث خطأ أثناء جلب المواعيد';
      }
      update();
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = 'حدث خطأ: $e';
      update();
    }
  }

  Future<void> bookAppointment() async {
    if (doctorId == null) {
      Get.snackbar('خطأ', 'معرف الطبيب غير موجود');
      return;
    }
    if (selectedDate.value.isEmpty || selectedTime.value.isEmpty) {
      Get.snackbar('تنبيه', 'يرجى اختيار التاريخ والوقت');
      return;
    }
    isLoading.value = true;
    try {
      final result = await _appointmentService.createAppointment(
        doctorId: doctorId!,
        appointmentDate: selectedDate.value,
        appointmentTime: selectedTime.value,
      );
      isLoading.value = false;
      if (result != null && result['status'] == 'success') {
        Get.snackbar('نجاح', 'تم حجز الموعد بنجاح');
        Future.delayed(const Duration(seconds: 2), () => Get.back());
      } else {
        final msg = result?['message'] ?? 'فشل في حجز الموعد';
        Get.snackbar('خطأ', msg);
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('خطأ', 'حدث خطأ غير متوقع');
    }
  }

  String getMonthName(int month) {
    const months = {
      1: 'يناير',
      2: 'فبراير',
      3: 'مارس',
      4: 'أبريل',
      5: 'مايو',
      6: 'يونيو',
      7: 'يوليو',
      8: 'أغسطس',
      9: 'سبتمبر',
      10: 'أكتوبر',
      11: 'نوفمبر',
      12: 'ديسمبر',
    };
    return months[month] ?? '';
  }

  void resetSelection() {
    selectedDate.value = '';
    selectedTime.value = '';
    availableTimes.clear();
    errorMessage.value = '';
    update();
  }
}