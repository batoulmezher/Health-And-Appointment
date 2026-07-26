// lib/controller/doctor_filter_controller.dart
import 'package:get/get.dart';
import '../models/doctor_model.dart';

class DoctorFilterController extends GetxController {
  final List<DoctorModel> allDoctors;
  var filteredDoctors = <DoctorModel>[].obs;

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
    List<DoctorModel> result = List.from(allDoctors);

    // Filter by Gender (from user.gender)
    if (selectedGender.value != 'الكل') {
      result = result.where((d) {
        final gender = d.data?.user?.gender;
        return gender == selectedGender.value;
      }).toList();
    }

    // Filter by Governorate (from clinicLocation)
    if (selectedGovernorate.value != 'الكل') {
      result = result.where((d) {
        final location = d.data?.city ?? '';
        return location.contains(selectedGovernorate.value);
      }).toList();
    }

    // Filter by Rating (ratingAverage)
    if (selectedRating.value > 0) {
      result = result.where((d) {
        final rating = double.tryParse(d.data?.ratingAverage ?? '0') ?? 0;
        return rating >= selectedRating.value;
      }).toList();
    }

    // Filter by Favorites
    if (showFavoritesOnly.value) {
      result = result.where((d) {
        final name = d.data?.user?.fullName ?? '';
        return favoriteIds.contains(name);
      }).toList();
    }

    // Sort by Price (consultationFee)
    if (selectedPriceSort.value == 'السعر: منخفض ← مرتفع') {
      result.sort((a, b) {
        final priceA = double.tryParse(a.data?.consultationFee ?? '0') ?? 0;
        final priceB = double.tryParse(b.data?.consultationFee ?? '0') ?? 0;
        return priceA.compareTo(priceB);
      });
    } else if (selectedPriceSort.value == 'السعر: مرتفع ← منخفض') {
      result.sort((a, b) {
        final priceA = double.tryParse(a.data?.consultationFee ?? '0') ?? 0;
        final priceB = double.tryParse(b.data?.consultationFee ?? '0') ?? 0;
        return priceB.compareTo(priceA);
      });
    }

    filteredDoctors.value = result;
  }

  void toggleFavorite(String doctorName) {
    if (favoriteIds.contains(doctorName)) {
      favoriteIds.remove(doctorName);
    } else {
      favoriteIds.add(doctorName);
    }
    applyFilters();
  }

  void resetFilters() {
    selectedGender.value = 'الكل';
    selectedGovernorate.value = 'الكل';
    selectedRating.value = 0.0;
    selectedPriceSort.value = 'بدون ترتيب';
    showFavoritesOnly.value = false;
  }

  List<String> get uniqueGovernorates {
    final locations = allDoctors
        .map((d) => d.data?.city ?? '')
        .where((loc) => loc.isNotEmpty)
        .toSet();
    return ['الكل', ...locations];
  }

  List<String> get genders => ['الكل', 'M', 'F'];
}