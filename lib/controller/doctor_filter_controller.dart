// lib/controller/doctor_filter_controller.dart
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:health_appointment_app/models/doctor_model.dart';

class DoctorFilterController extends GetxController {
  final List<DoctorModel> allDoctors;

  var favoriteIds = <int>[].obs;
  final GetStorage _storage = GetStorage();

  var selectedPriceSort = 'بدون ترتيب'.obs;
  var selectedGender = 'الكل'.obs;
  var selectedGovernorate = 'الكل'.obs;
  var selectedRating = 0.0.obs;
  var showFavoritesOnly = false.obs;

  final genders = ['الكل', 'ذكر', 'أنثى'];

  List<String> get uniqueGovernorates {
    final govs = allDoctors
        .map((d) => d.data?.city ?? '')
        .where((c) => c.isNotEmpty)
        .toSet()
        .toList();
    govs.sort();
    return ['الكل', ...govs];
  }

  DoctorFilterController({required this.allDoctors}) {
    _loadFavorites(); // تحميل المفضلة عند الإنشاء
  }

  void _loadFavorites() {
    final saved = _storage.read('favorites');
    if (saved != null && saved is List) {
      try {
        favoriteIds.value = saved.map((e) => e as int).toList();
      } catch (e) {
        favoriteIds.clear();
      }
    } else {
      favoriteIds.clear();
    }
  }

  void _saveFavorites() {
    _storage.write('favorites', favoriteIds.toList());
  }

  void toggleFavorite(int doctorId) {
    if (favoriteIds.contains(doctorId)) {
      favoriteIds.remove(doctorId);
    } else {
      favoriteIds.add(doctorId);
    }
    _saveFavorites();
  }

  bool isFavorite(int doctorId) => favoriteIds.contains(doctorId);

  void resetFilters() {
    selectedPriceSort.value = 'بدون ترتيب';
    selectedGender.value = 'الكل';
    selectedGovernorate.value = 'الكل';
    selectedRating.value = 0.0;
    showFavoritesOnly.value = false;
  }

  List<DoctorModel> get filteredDoctors {
    var list = allDoctors;

    if (selectedGovernorate.value != 'الكل') {
      list = list
          .where((d) => d.data?.city == selectedGovernorate.value)
          .toList();
    }

    if (selectedGender.value != 'الكل') {
      final genderMap = {'ذكر': 'M', 'أنثى': 'F'};
      final genderCode = genderMap[selectedGender.value];
      if (genderCode != null) {
        list = list.where((d) => d.data?.user?.gender == genderCode).toList();
      }
    }

    if (selectedRating.value > 0) {
      list = list.where((d) {
        final rating = double.tryParse(d.data?.ratingAverage ?? '0') ?? 0.0;
        return rating >= selectedRating.value;
      }).toList();
    }

    if (showFavoritesOnly.value) {
      list = list.where((d) => favoriteIds.contains(d.data?.id)).toList();
    }

    if (selectedPriceSort.value == 'السعر: منخفض ← مرتفع') {
      list.sort((a, b) {
        final priceA = double.tryParse(a.data?.consultationFee ?? '0') ?? 0;
        final priceB = double.tryParse(b.data?.consultationFee ?? '0') ?? 0;
        return priceA.compareTo(priceB);
      });
    } else if (selectedPriceSort.value == 'السعر: مرتفع ← منخفض') {
      list.sort((a, b) {
        final priceA = double.tryParse(a.data?.consultationFee ?? '0') ?? 0;
        final priceB = double.tryParse(b.data?.consultationFee ?? '0') ?? 0;
        return priceB.compareTo(priceA);
      });
    }

    return list;
  }
}
