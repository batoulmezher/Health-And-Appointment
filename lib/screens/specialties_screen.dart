import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_appointment_app/Routes/pages.dart';
import 'package:health_appointment_app/constant/colors.dart';
import 'package:health_appointment_app/controller/specialties_controller.dart';
import 'package:health_appointment_app/models/specialty_model.dart';
import 'package:health_appointment_app/widgets/selver_app_bar.dart';

class SpecialtiesScreen extends StatelessWidget {
  const SpecialtiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SpecialtiesController());
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? Colors.grey.shade900 : const Color(0xFFF5F7FA);
    final textColor = isDarkMode ? Colors.white : const Color(0xFF1A1A2E);
    final subTextColor = isDarkMode ? Colors.white70 : const Color(0xFF6B7280);
    final cardColor = isDarkMode ? Colors.grey.shade800 : Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 60, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  controller.errorMessage.value,
                  style: TextStyle(color: subTextColor),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.fetchSpecialties(),
                  child: const Text('إعادة المحاولة'),
                ),
              ],
            ),
          );
        }

        if (controller.filteredSpecialties.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.medical_services, size: 60, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  'لا توجد تخصصات',
                  style: TextStyle(color: subTextColor),
                ),
              ],
            ),
          );
        }
        return CustomScrollView(
          slivers: [
            ProAppBar(
              title: 'specialties'.tr,
              subtitle: '${controller.filteredSpecialties.length} تخصص',
              onBackPressed: () => Get.back(),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Container(
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextFormField(
                    controller: controller.searchController,
                    style: TextStyle(color: textColor),
                    textAlign: TextAlign.right,
                    onChanged: (value) => controller.filterSpecialties(value),
                    decoration: InputDecoration(
                      hintText: 'ابحث عن تخصص...',
                      hintStyle: TextStyle(color: subTextColor),
                      prefixIcon: Icon(Icons.search, color: subTextColor),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.9,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final specialty = controller.filteredSpecialties[index];
                    return _buildSpecialtyCard(
                      specialty,
                      isDarkMode,
                      cardColor,
                      textColor,
                      subTextColor,
                      controller,
                    );
                  },
                  childCount: controller.filteredSpecialties.length,
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildSpecialtyCard(
    SpecialtyModel specialty,
    bool isDarkMode,
    Color cardColor,
    Color textColor,
    Color subTextColor,
    SpecialtiesController controller,
  ) {
    return GestureDetector(
      onTap: () {
        Get.snackbar(
          specialty.name,
          'سيتم عرض الأطباء في تخصص ${specialty.name}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.amber.withOpacity(0.9),
          colorText: Colors.white,
        );
         Get.toNamed(AppRoutes.allDoctors, arguments: specialty.name);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade200,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: appColor.primary.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                controller.getIconForSpecialty(specialty.name),
                color: appColor.primary,
                size: 32,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              specialty.name,
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            if (specialty.description != null && specialty.description!.isNotEmpty)
              Text(
                specialty.description!,
                style: TextStyle(
                  color: subTextColor,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
      ),
    );
  }
}