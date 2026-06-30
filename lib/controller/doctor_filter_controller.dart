// lib/controller/doctor_filter_controller.dart
import 'package:get/get.dart';
import '../models/doctor_model.dart';

class DoctorFilterController extends GetxController {
  final List<Doctor> allDoctors;
  var filteredDoctors = <Doctor>[].obs;
  var selectedGender = 'الكل'.obs;
  var selectedGovernorate = 'الكل'.obs;
  var selectedRating = 0.0.obs;
  var selectedPriceSort = 'بدون ترتيب'.obs;
  var showFavoritesOnly = false.obs;

  final favoriteIds = <String>{}.obs;

  DoctorFilterController({required this.allDoctors}) {
    applyFilters();
    ever(selectedGender, (_) => applyFilters());
    ever(selectedGovernorate, (_) => applyFilters());
    ever(selectedRating, (_) => applyFilters());
    ever(selectedPriceSort, (_) => applyFilters());
    ever(showFavoritesOnly, (_) => applyFilters());
  }

  void applyFilters() {
    List<Doctor> result = List.from(allDoctors);

    if (selectedGender.value != 'الكل') {
      result = result.where((d) => d.gender == selectedGender.value).toList();
    }

    if (selectedGovernorate.value != 'الكل') {
      result = result.where((d) => d.governorate == selectedGovernorate.value).toList();
    }

    if (selectedRating.value > 0) {
      result = result.where((d) => d.rating >= selectedRating.value).toList();
    }

    if (showFavoritesOnly.value) {
      result = result.where((d) => favoriteIds.contains(d.name)).toList();
    }

    if (selectedPriceSort.value == 'السعر: منخفض ← مرتفع') {
      result.sort((a, b) => a.price.compareTo(b.price));
    } else if (selectedPriceSort.value == 'السعر: مرتفع ← منخفض') {
      result.sort((a, b) => b.price.compareTo(a.price));
    }

    filteredDoctors.value = result;
  }

  void toggleFavorite(String doctorName) {
    if (favoriteIds.contains(doctorName)) {
      favoriteIds.remove(doctorName);
    } else {
      favoriteIds.add(doctorName);
    }
  }

  void resetFilters() {
    selectedGender.value = 'الكل';
    selectedGovernorate.value = 'الكل';
    selectedRating.value = 0.0;
    selectedPriceSort.value = 'بدون ترتيب';
    showFavoritesOnly.value = false;
  }

  List<String> get uniqueGovernorates {
    final set = allDoctors.map((d) => d.governorate).toSet();
    return ['الكل', ...set];
  }

  List<String> get genders => ['الكل', 'ذكر', 'أنثى'];
}