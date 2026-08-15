// lib/screens/edit_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_appointment_app/constant/colors.dart' as appColor;
import 'package:health_appointment_app/controller/profile_controller.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();
    final user = controller.userProfile.value!;
    final patient = user.patient!;

    final isDarkMode = Get.isDarkMode;

    final backgroundColor = isDarkMode ? Colors.grey.shade900 : const Color(0xFFF8F9FB);
    final cardColor = isDarkMode ? Colors.grey.shade800 : Colors.white;
    final textColor = isDarkMode ? Colors.white : const Color(0xFF1A1A2E);
    final subTextColor = isDarkMode ? Colors.white70 : const Color(0xFF6B7280);

    final TextEditingController nameController = TextEditingController(text: user.fullName);
    final TextEditingController phoneController = TextEditingController(text: user.phoneNumber);
    final TextEditingController weightController = TextEditingController(
      text: patient.weight?.toStringAsFixed(0) ?? '',
    );
    final TextEditingController bloodTypeController = TextEditingController(
      text: patient.bloodType ?? '',
    );

    final bloodTypes = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
    String selectedBloodType = patient.bloodType ?? 'A+';

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: Text(
          'تعديل الملف الشخصي',
          style: TextStyle(
            color: textColor,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: textColor),
          onPressed: () => Get.back(),
        ),
        actions: [
          Obx(() {
            return TextButton(
              onPressed: controller.isUpdating.value
                  ? null
                  : () {
                      final name = nameController.text.trim();
                      final phone = phoneController.text.trim();
                      final weight = double.tryParse(weightController.text.trim()) ?? 0;
                      final bloodType = selectedBloodType;

                      if (name.isEmpty || phone.isEmpty || weight <= 0) {
                        Get.snackbar('تنبيه', 'يرجى ملء جميع الحقول بشكل صحيح');
                        return;
                      }

                      controller.updateProfile(
                        fullName: name,
                        phoneNumber: phone,
                        weight: weight,
                        bloodType: bloodType,
                      );
                    },
              child: controller.isUpdating.value
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: appColor.appColor.primary,
                      ),
                    )
                  : Text(
                      'حفظ',
                      style: TextStyle(
                        color: appColor.appColor.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            );
          }),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // أيقونة التعديل
              Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: appColor.appColor.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.edit,
                    color: appColor.appColor.primary,
                    size: 40,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              Text(
                'الاسم الكامل',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: subTextColor,
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: 'أدخل اسمك الكامل',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade50,
                ),
                style: TextStyle(color: textColor),
              ),
              const SizedBox(height: 16),

              Text(
                'رقم الهاتف',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: subTextColor,
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: 'أدخل رقم الهاتف',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade50,
                ),
                style: TextStyle(color: textColor),
              ),
              const SizedBox(height: 16),

              Text(
                'الوزن (كجم)',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: subTextColor,
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: weightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'أدخل الوزن',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade50,
                  suffixIcon: const Icon(Icons.monitor_weight),
                ),
                style: TextStyle(color: textColor),
              ),
              const SizedBox(height: 16),

              Text(
                'فصيلة الدم',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: subTextColor,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedBloodType,
                    isExpanded: true,
                    dropdownColor: isDarkMode ? Colors.grey.shade800 : Colors.white,
                    items: bloodTypes.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(
                          type,
                          style: TextStyle(color: textColor),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        selectedBloodType = value;
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue.shade700),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'يمكنك تعديل معلوماتك الشخصية وسيتم تحديثها في حسابك',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}