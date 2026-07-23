// lib/controllers/appointment_controller.dart
import 'package:get/get.dart';

class AppointmentController extends GetxController {
  var selectedDate = ''.obs;
  var selectedTime = ''.obs;

  void selectDate(String date) {
    selectedDate.value = date;
  }

  void selectTime(String time) {
    selectedTime.value = time;
  }
}   