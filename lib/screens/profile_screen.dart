// lib/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:health_appointment_app/constant/colors.dart' as appColor;
import 'package:health_appointment_app/controller/profile_controller.dart';
import 'package:health_appointment_app/screens/edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
    final isDarkMode = Get.isDarkMode;

    final backgroundColor = isDarkMode ? const Color(0xFF0F0F1A) : const Color(0xFFF0F2F8);
    final cardColor = isDarkMode ? const Color(0xFF1A1A2E) : Colors.white;
    final textColor = isDarkMode ? Colors.white : const Color(0xFF1A1A2E);
    final subTextColor = isDarkMode ? Colors.white70 : const Color(0xFF6B7280);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'الملف الشخصي',
          style: TextStyle(
            color: textColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: textColor),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: textColor),
            onPressed: () => Get.to(() => const EditProfileScreen()),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(appColor.appColor.primary),
            ),
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
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: controller.fetchProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appColor.appColor.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text('إعادة المحاولة'),
                ),
              ],
            ),
          );
        }
        if (controller.userProfile.value == null) {
          return Center(
            child: Text(
              'لا توجد بيانات',
              style: TextStyle(color: subTextColor),
            ),
          );
        }

        final profile = controller.userProfile.value!;
        final patient = profile.patient;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: appColor.appColor.primary,
                        width: 4,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: appColor.appColor.primary.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: profile.profilePictureUrl != null &&
                              profile.profilePictureUrl!.isNotEmpty
                          ? Image.network(
                              profile.profilePictureUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => _buildAvatarFallback(profile.fullName),
                            )
                          : _buildAvatarFallback(profile.fullName),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () => Get.to(() => const EditProfileScreen()),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: appColor.appColor.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                profile.fullName,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 4),
              // ===== حالة الحساب =====
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: profile.isActive
                      ? Colors.green.withOpacity(0.1)
                      : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: profile.isActive
                        ? Colors.green.withOpacity(0.3)
                        : Colors.red.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      profile.isActive ? Icons.check_circle : Icons.cancel,
                      color: profile.isActive ? Colors.green : Colors.red,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      controller.getStatusLabel(profile.isActive),
                      style: TextStyle(
                        color: profile.isActive ? Colors.green : Colors.red,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildInfoTile(
                      icon: Icons.email_outlined,
                      label: 'البريد الإلكتروني',
                      value: profile.email,
                      textColor: textColor,
                      subTextColor: subTextColor,
                    ),
                    const Divider(height: 24),
                    _buildInfoTile(
                      icon: Icons.phone_outlined,
                      label: 'رقم الهاتف',
                      value: profile.phoneNumber,
                      textColor: textColor,
                      subTextColor: subTextColor,
                    ),
                    const Divider(height: 24),
                    _buildInfoTile(
                      icon: Icons.person_outline,
                      label: 'الجنس',
                      value: controller.getGenderLabel(profile.gender),
                      textColor: textColor,
                      subTextColor: subTextColor,
                    ),
                    const Divider(height: 24),
                    _buildInfoTile(
                      icon: Icons.medical_services_outlined,
                      label: 'الدور',
                      value: controller.getRoleLabel(profile.role),
                      textColor: textColor,
                      subTextColor: subTextColor,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // ===== المعلومات الطبية =====
              if (patient != null)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.health_and_safety,
                            color: appColor.appColor.primary,
                            size: 22,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'المعلومات الطبية',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildInfoTile(
                        icon: Icons.cake_outlined,
                        label: 'العمر',
                        value: '${patient.age} سنة',
                        textColor: textColor,
                        subTextColor: subTextColor,
                      ),
                      if (patient.weight != null) const Divider(height: 24),
                      if (patient.weight != null)
                        _buildInfoTile(
                          icon: Icons.monitor_weight_outlined,
                          label: 'الوزن',
                          value: '${patient.weight} كجم',
                          textColor: textColor,
                          subTextColor: subTextColor,
                        ),
                      if (patient.height != null) const Divider(height: 24),
                      if (patient.height != null)
                        _buildInfoTile(
                          icon: Icons.height,
                          label: 'الطول',
                          value: '${patient.height} سم',
                          textColor: textColor,
                          subTextColor: subTextColor,
                        ),
                      if (patient.bloodType != null) const Divider(height: 24),
                      if (patient.bloodType != null)
                        _buildInfoTile(
                          icon: Icons.bloodtype_outlined,
                          label: 'فصيلة الدم',
                          value: patient.bloodType!,
                          textColor: textColor,
                          subTextColor: subTextColor,
                        ),
                      const Divider(height: 24),
                      _buildInfoTile(
                        icon: patient.hasChronicDisease
                            ? Icons.warning_outlined
                            : Icons.check_circle_outline,
                        label: 'أمراض مزمنة',
                        value: patient.hasChronicDisease
                            ? (patient.chronicDiseaseDescription ?? 'يوجد')
                            : 'لا يوجد',
                        textColor: textColor,
                        subTextColor: subTextColor,
                        valueColor: patient.hasChronicDisease
                            ? Colors.orange
                            : Colors.green,
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 24),

              /// lib/screens/profile_screen.dart

SizedBox(
  width: double.infinity,
  child: ElevatedButton.icon(
    onPressed: () {
      Get.defaultDialog(
        title: 'تسجيل الخروج',
        middleText: 'هل أنت متأكد من رغبتك في تسجيل الخروج؟',
        textConfirm: 'تسجيل الخروج',
        textCancel: 'إلغاء',
        confirmTextColor: Colors.white,
        onConfirm: () {
          Get.back();  
          controller.logout();
        },
      );
    },
    icon: const Icon(Icons.logout),
    label: const Text('تسجيل الخروج'),
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.red.shade400,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
  ),
),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildAvatarFallback(String name) {
    return Container(
      color: appColor.appColor.primary,
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : '?',
          style: const TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String label,
    required String value,
    required Color textColor,
    required Color subTextColor,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: appColor.appColor.primary.withOpacity(0.08),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 18, color: appColor.appColor.primary),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: subTextColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: valueColor ?? textColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}