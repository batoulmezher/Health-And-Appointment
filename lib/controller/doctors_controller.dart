import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:health_appointment_app/Routes/pages.dart';
import 'package:health_appointment_app/models/doctor_model.dart';
import 'package:health_appointment_app/services/doctors_service.dart';

class DoctorsController extends GetxController {
  final DoctorsService _doctorsService = DoctorsService();
  var allDoctors = <DoctorModel>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var isSessionExpired = false.obs;

  

  Future<void> fetchAllDoctors() async {
    isLoading.value = true;
    errorMessage.value = '';
    isSessionExpired.value = false;

    try {
      final result = await _doctorsService.getAllDoctors();
      if (result != null && result.isNotEmpty) {
              isLoading.value = false;

        allDoctors.value = result.map((data) {
          return DoctorModel(
            status: 'success',
            data: data,
            
          );
          
        }).toList();
        print("✅ Doctors loaded: ${allDoctors.length}");
      } else {
        // Check if token is missing
        if (GetStorage().read('token') == null) {
          // Token was removed due to 403/401
          isSessionExpired.value = true;
          errorMessage.value = 'انتهت صلاحية الجلسة، يرجى تسجيل الدخول مرة أخرى';
        } else {
          errorMessage.value = 'لم نتمكن من تحميل الأطباء';
        }
      }
    } catch (e) {
      errorMessage.value = 'حدث خطأ أثناء تحميل البيانات';
      print("❌ Doctors fetch error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void logoutAndRedirect() {
    GetStorage().remove('token');
    Get.offAllNamed(AppRoutes.login);
  }
  @override
  void onInit() {
    super.onInit();
    fetchAllDoctors();
  }
}