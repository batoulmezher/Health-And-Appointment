import 'package:get/get.dart';

class DoctorProfileController extends GetxController {
  var selectedTab = 0.obs;
  var selectedTime = ''.obs;

  void selectTime(String time) {
    selectedTime.value = time;
  }
}
