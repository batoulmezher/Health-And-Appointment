// lib/controller/doctors_controller.dart
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart' hide Data;
import 'package:health_appointment_app/Routes/pages.dart';
import 'package:health_appointment_app/models/doctor_model.dart';
import 'package:health_appointment_app/services/doctors_service.dart';

class DoctorsController extends GetxController {
  final DoctorsService _doctorsService = DoctorsService();

  var allDoctors = <DoctorModel>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var isSessionExpired = false.obs;

  var filteredDoctors = <DoctorModel>[].obs;
  var isFiltering = false.obs;

  var selectedGender = 'الكل'.obs;
  var selectedCity = 'الكل'.obs;
  var showTopRated = false.obs;
  var availableCities = <String>[].obs;
  var availableGenders = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllDoctors();
  }

  Future<void> fetchAllDoctors() async {
    isLoading.value = true;
    errorMessage.value = '';
    isSessionExpired.value = false;

    try {
      final result = await _doctorsService.getAllDoctors();
      if (result != null && result.isNotEmpty) {
        allDoctors.value = result.map((data) {
          return DoctorModel(status: 'success', data: data);
        }).toList();
        _extractFilterOptions(result);
        print("✅ Doctors loaded: ${allDoctors.length}");
      } else {
        if (GetStorage().read('token') == null) {
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

  void _extractFilterOptions(List<Data> doctors) {
    final cities = <String>{};
    final genders = <String>{};

    for (var doctor in doctors) {
      if (doctor.city != null && doctor.city!.isNotEmpty) {
        cities.add(doctor.city!);
      }
      if (doctor.user?.gender != null && doctor.user!.gender!.isNotEmpty) {
        genders.add(doctor.user!.gender!);
      }
    }

    availableCities.value = ['الكل', ...cities];
    availableGenders.value = ['الكل', ...genders];
  }

  Future<void> applyFilters() async {
    isFiltering.value = true;

    try {
      final result = await _doctorsService.getFilteredDoctors(
        topRated: showTopRated.value ? true : null,
        gender: selectedGender.value != 'الكل' ? selectedGender.value : null,
        city: selectedCity.value != 'الكل' ? selectedCity.value : null,
      );

      if (result != null) {
        filteredDoctors.value = result.map((data) {
          return DoctorModel(status: 'success', data: data);
        }).toList();
        print("✅ Filtered doctors: ${filteredDoctors.length}");
      } else {
        filteredDoctors.clear();
      }
    } catch (e) {
      print("❌ Filter error: $e");
      filteredDoctors.clear();
    } finally {
      isFiltering.value = false;
    }
  }

  void resetFilters() {
    selectedGender.value = 'الكل';
    selectedCity.value = 'الكل';
    showTopRated.value = false;
    filteredDoctors.clear();
    isFiltering.value = false;
  }

  void clearFilter(String filterType) {
    switch (filterType) {
      case 'gender':
        selectedGender.value = 'الكل';
        break;
      case 'city':
        selectedCity.value = 'الكل';
        break;
      case 'topRated':
        showTopRated.value = false;
        break;
    }
    applyFilters();
  }

  List<DoctorModel> get displayedDoctors {
    if (filteredDoctors.isNotEmpty) return filteredDoctors;
    return allDoctors;
  }

  void logoutAndRedirect() {
    GetStorage().remove('token');
    Get.offAllNamed(AppRoutes.login);
  }
}