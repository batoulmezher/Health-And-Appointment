// lib/screens/all_doctors_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_appointment_app/Routes/pages.dart';
import 'package:health_appointment_app/constant/colors.dart';
import 'package:health_appointment_app/controller/doctor_filter_controller.dart';
import 'package:health_appointment_app/controller/doctors_controller.dart';
import 'package:health_appointment_app/models/doctor_model.dart';
import 'package:health_appointment_app/widgets/selver_app_bar.dart';

class AllDoctorsScreen extends StatelessWidget {
  final String? specialtyName;

  const AllDoctorsScreen({super.key, this.specialtyName});

  @override
  Widget build(BuildContext context) {
    final doctorsController = Get.find<DoctorsController>();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final String? specialty = specialtyName ?? Get.arguments as String?;

    if (doctorsController.allDoctors.isEmpty && !doctorsController.isLoading.value) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        doctorsController.fetchAllDoctors();
      });
    }

    return Obx(() {
      if (doctorsController.isLoading.value) {
        return Scaffold(
          backgroundColor: isDarkMode ? Colors.grey.shade900 : const Color(0xFFF7F8FC),
          body: const Center(child: CircularProgressIndicator()),
        );
      }

      //  Error state
      if (doctorsController.errorMessage.isNotEmpty) {
        return Scaffold(
          backgroundColor: isDarkMode ? Colors.grey.shade900 : const Color(0xFFF7F8FC),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 60, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  doctorsController.errorMessage.value,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white70 : Colors.grey.shade700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => doctorsController.fetchAllDoctors(),
                  child: const Text('إعادة المحاولة'),
                ),
              ],
            ),
          ),
        );
      }

      //  Filter doctors by specialty (case-insensitive)
      final List<DoctorModel> filteredDoctors = specialty != null && specialty.isNotEmpty
          ? doctorsController.allDoctors.where((d) {
              final docSpecialty = d.data?.specialty?.name ?? '';
              return docSpecialty.toLowerCase() == specialty.toLowerCase();
            }).toList()
          : doctorsController.allDoctors;

      //  No doctors found
      if (filteredDoctors.isEmpty) {
        return Scaffold(
          backgroundColor: isDarkMode ? Colors.grey.shade900 : const Color(0xFFF7F8FC),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.medical_information, size: 60, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  specialty != null
                      ? 'لا يوجد أطباء في تخصص $specialty'
                      : 'لا يوجد أطباء',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white70 : Colors.grey.shade700,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        );
      }

      //  Create filter controller
      final filterController = Get.put(
        DoctorFilterController(allDoctors: filteredDoctors),
        tag: 'doctorFilter',
      );

      final backgroundColor = isDarkMode ? Colors.grey.shade900 : const Color(0xFFF7F8FC);

      return Scaffold(
        backgroundColor: backgroundColor,
        body: CustomScrollView(
          slivers: [
            ProAppBar(
              title: specialty ?? 'all_doctors'.tr,
              subtitle: '${filterController.filteredDoctors.length} ${'doctor_singular'.tr}',
              onBackPressed: () {
                Get.delete<DoctorFilterController>(tag: 'doctorFilter');
                Get.back();
              },
            ),
            SliverToBoxAdapter(
              child: _buildFilterBar(filterController, isDarkMode),
            ),
            Obx(
              () => SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final doctor = filterController.filteredDoctors[index];
                    return _buildDoctorCard(doctor, isDarkMode, filterController);
                  },
                  childCount: filterController.filteredDoctors.length,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  // ============================================================
  // FILTER BAR
  // ============================================================
  Widget _buildFilterBar(DoctorFilterController controller, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.transparent,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            // ---- Price Filter ----
            Obx(
              () => _buildFilterChip(
                label: controller.selectedPriceSort.value == 'بدون ترتيب'
                    ? 'price'.tr
                    : controller.selectedPriceSort.value,
                icon: Icons.attach_money,
                onTap: () => _showPriceMenu(controller),
                isDarkMode: isDarkMode,
                isActive: controller.selectedPriceSort.value != 'بدون ترتيب',
              ),
            ),
            const SizedBox(width: 8),

            // ---- Gender Filter ----
            Obx(
              () => _buildFilterChip(
                label: controller.selectedGender.value == 'الكل'
                    ? 'gender'.tr
                    : controller.selectedGender.value,
                icon: Icons.person,
                onTap: () => _showGenderMenu(controller),
                isDarkMode: isDarkMode,
                isActive: controller.selectedGender.value != 'الكل',
              ),
            ),
            const SizedBox(width: 8),

            // ---- Governorate Filter ----
            Obx(
              () => _buildFilterChip(
                label: controller.selectedGovernorate.value == 'الكل'
                    ? 'governorate'.tr
                    : controller.selectedGovernorate.value,
                icon: Icons.location_on,
                onTap: () => _showGovernorateMenu(controller),
                isDarkMode: isDarkMode,
                isActive: controller.selectedGovernorate.value != 'الكل',
              ),
            ),
            const SizedBox(width: 8),

            // ---- Rating Filter ----
            Obx(
              () => _buildFilterChip(
                label: controller.selectedRating.value > 0
                    ? '${controller.selectedRating.value}★+'
                    : 'rating'.tr,
                icon: Icons.star,
                onTap: () => _showRatingMenu(controller),
                isDarkMode: isDarkMode,
                isActive: controller.selectedRating.value > 0,
              ),
            ),
            const SizedBox(width: 8),

            // ---- Favorites Filter ----
            Obx(
              () => _buildFilterChip(
                label: controller.showFavoritesOnly.value ? 'favorites'.tr + ' ✓' : 'favorites'.tr,
                icon: controller.showFavoritesOnly.value ? Icons.favorite : Icons.favorite_border,
                onTap: () => controller.showFavoritesOnly.toggle(),
                isDarkMode: isDarkMode,
                isActive: controller.showFavoritesOnly.value,
              ),
            ),
            const SizedBox(width: 8),

            // ---- Reset Button ----
            GestureDetector(
              onTap: controller.resetFilters,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.red.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.clear, color: Colors.red[400], size: 16),
                    const SizedBox(width: 4),
                    Text(
                      'reset'.tr,
                      style: TextStyle(
                        color: Colors.red[400],
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // FILTER CHIP
  // ============================================================
  Widget _buildFilterChip({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
    required bool isDarkMode,
    bool isActive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isActive
              ? Colors.amber.withOpacity(0.2)
              : isDarkMode
                  ? Colors.grey.shade800
                  : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive
                ? Colors.amber
                : isDarkMode
                    ? Colors.grey.shade700
                    : Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: isActive ? Colors.amber : Colors.grey.shade600,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isActive
                    ? Colors.amber
                    : isDarkMode
                        ? Colors.white
                        : Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // FILTER MENUS
  // ============================================================
  void _showPriceMenu(DoctorFilterController controller) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('sort_by_price'.tr, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildOptionTile(
              title: 'no_sort'.tr,
              onTap: () { controller.selectedPriceSort.value = 'بدون ترتيب'; Get.back(); },
              isSelected: controller.selectedPriceSort.value == 'بدون ترتيب',
            ),
            _buildOptionTile(
              title: 'low_to_high'.tr,
              onTap: () { controller.selectedPriceSort.value = 'السعر: منخفض ← مرتفع'; Get.back(); },
              isSelected: controller.selectedPriceSort.value == 'السعر: منخفض ← مرتفع',
            ),
            _buildOptionTile(
              title: 'high_to_low'.tr,
              onTap: () { controller.selectedPriceSort.value = 'السعر: مرتفع ← منخفض'; Get.back(); },
              isSelected: controller.selectedPriceSort.value == 'السعر: مرتفع ← منخفض',
            ),
          ],
        ),
      ),
    );
  }

  void _showGenderMenu(DoctorFilterController controller) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('select_gender'.tr, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ...controller.genders.map(
              (gender) => _buildOptionTile(
                title: gender == 'الكل' ? 'all'.tr : gender,
                onTap: () { controller.selectedGender.value = gender; Get.back(); },
                isSelected: controller.selectedGender.value == gender,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showGovernorateMenu(DoctorFilterController controller) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: ListView(
         // mainAxisSize: MainAxisSize.min,
          children: [
            Text('select_governorate'.tr, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ...controller.uniqueGovernorates.map(
              (gov) => _buildOptionTile(
                title: gov == 'الكل' ? 'all'.tr : gov,
                onTap: () { controller.selectedGovernorate.value = gov; Get.back(); },
                isSelected: controller.selectedGovernorate.value == gov,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showRatingMenu(DoctorFilterController controller) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('select_rating'.tr, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildOptionTile(
              title: 'all'.tr,
              onTap: () { controller.selectedRating.value = 0.0; Get.back(); },
              isSelected: controller.selectedRating.value == 0.0,
            ),
            _buildOptionTile(
              title: 'rating_4_plus'.tr,
              onTap: () { controller.selectedRating.value = 4.0; Get.back(); },
              isSelected: controller.selectedRating.value == 4.0,
            ),
            _buildOptionTile(
              title: 'rating_4_5_plus'.tr,
              onTap: () { controller.selectedRating.value = 4.5; Get.back(); },
              isSelected: controller.selectedRating.value == 4.5,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile({
    required String title,
    required VoidCallback onTap,
    required bool isSelected,
  }) {
    return ListTile(
      title: Text(title),
      trailing: isSelected ? const Icon(Icons.check, color: Colors.amber) : null,
      onTap: onTap,
      tileColor: isSelected ? Colors.amber.withOpacity(0.1) : null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  // ============================================================
  // DOCTOR CARD
  // ============================================================
  Widget _buildDoctorCard(
    DoctorModel doctorModel,
    bool isDarkMode,
    DoctorFilterController filterController,
  ) {
    final data = doctorModel.data;
    final user = data?.user;
    final specialty = data?.specialty;
    final textColor = isDarkMode ? Colors.white : const Color(0xFF1A1A2E);
    final subTextColor = isDarkMode ? Colors.white70 : Colors.grey.shade600;
    final name = user?.fullName ?? 'طبيب';
    final specialtyName = specialty?.name ?? 'تخصص غير معروف';
    final rating = data?.ratingAverage ?? '0.0';
    final price = data?.consultationFee ?? '0';
    final imageUrl = user?.profilePictureUrl ?? '';
    final availableTime = _formatWorkingHours(data?.workingDaysHours);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey.shade800 : Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: textColor,
                        ),
                      ),
                    ),
                    Obx(
                      () => GestureDetector(
                        onTap: () => filterController.toggleFavorite(name),
                        child: Icon(
                          filterController.favoriteIds.contains(name)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: filterController.favoriteIds.contains(name)
                              ? Colors.red
                              : Colors.grey.shade400,
                          size: 22,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  specialtyName,
                  style: TextStyle(color: subTextColor, fontSize: 13),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 15),
                    const SizedBox(width: 4),
                    Text(
                      rating,
                      style: TextStyle(color: subTextColor, fontSize: 12),
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: Colors.grey.shade500,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      availableTime,
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: appColor.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        data?.city ?? 'غير محدد',
                        style: TextStyle(fontSize: 10, color: appColor.primary),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        user?.gender ?? 'غير محدد',
                        style: TextStyle(fontSize: 10, color: Colors.amber[700]),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      '${double.tryParse(price)?.toInt() ?? price} ل.س',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: appColor.primary,
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: 80,
                      height: 36,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: appColor.primary,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          Get.toNamed(AppRoutes.doctorProfileScreen, arguments: data?.id);
                        },
                        child: Text(
                          'book_now'.tr,
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              imageUrl.isNotEmpty
                  ? imageUrl
                  : 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(name)}&background=001b48&color=fff&size=150',
              width: 90,
              height: 130,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 90,
                height: 130,
                color: Colors.grey.shade300,
                child: Center(
                  child: Text(
                    name.isNotEmpty ? name[0].toUpperCase() : '?',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // HELPERS
  // ============================================================
  String _formatWorkingHours(WorkingDaysHours? hours) {
    if (hours == null) return 'غير متاح';
    final day = hours.monday ?? hours.sunday ?? hours.tuesday ?? hours.wednesday ?? hours.thursday;
    if (day != null && day.start != null && day.end != null) {
      return '${day.start} - ${day.end}';
    }
    return 'غير متاح';
  }
}