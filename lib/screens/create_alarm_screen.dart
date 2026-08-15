// lib/screens/alarms/create_alarm_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_appointment_app/constant/colors.dart' as appColor;
import 'package:health_appointment_app/controller/alarm_controller.dart';

class CreateAlarmScreen extends StatelessWidget {
  const CreateAlarmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AlarmController>();
    final isDarkMode = Get.isDarkMode;

    final backgroundColor = isDarkMode
        ? Colors.grey.shade900
        : const Color(0xFFF8F9FB);
    final textColor = isDarkMode ? Colors.white : const Color(0xFF1A1A2E);
    final subTextColor = isDarkMode ? Colors.white70 : const Color(0xFF6B7280);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: Text(
          'إضافة منبه',
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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: appColor.appColor.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.medication,
                size: 48,
                color: appColor.appColor.primary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'أضف تذكير دواء جديد',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'سيصلك إشعار في الوقت المحدد',
              style: TextStyle(color: subTextColor),
            ),
            const SizedBox(height: 30),

            _buildTextField(
              controller: controller.medicineNameController,
              label: 'اسم الدواء',
              hint: 'مثل: Panadol Extra',
              icon: Icons.medication,
            ),
            const SizedBox(height: 16),

            _buildTextField(
              controller: controller.dosageController,
              label: 'الجرعة',
              hint: 'مثل: حبة واحدة',
              icon: Icons.medication_liquid,
            ),
            const SizedBox(height: 16),

            _buildTextField(
              controller: controller.quantityController,
              label: 'الكمية',
              hint: 'مثل: 20',
              icon: Icons.numbers,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),

            _buildTextField(
              controller: controller.frequencyController,
              label: 'التكرار',
              hint: 'مثل: كل 12 ساعة',
              icon: Icons.access_time,
            ),
            const SizedBox(height: 16),

            _buildTimePickerField(
              controller: controller.alarmTimeController,
              label: 'وقت المنبه',
              hint: 'اختر الوقت',
            ),
            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: Obx(() {
                return ElevatedButton(
                  onPressed: controller.isSaving.value
                      ? null
                      : controller.createAlarm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appColor.appColor.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    shadowColor: appColor.appColor.primary.withOpacity(0.3),
                  ),
                  child: controller.isSaving.value
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'إضافة المنبه',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: appColor.appColor.primary),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: appColor.appColor.primary),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  Widget _buildTimePickerField({
    required TextEditingController controller,
    required String label,
    required String hint,
  }) {
    return GestureDetector(
      onTap: () async {
        final TimeOfDay? picked = await showTimePicker(
          context: Get.context!,
          initialTime: TimeOfDay.now(),
          builder: (context, child) {
            return Theme(
              data: ThemeData.light().copyWith(
                colorScheme: const ColorScheme.light(
                  primary: appColor.appColor.primary,
                ),
              ),
              child: child!,
            );
          },
        );
        if (picked != null) {
          
          final pii = picked.hour - 3;
          final timeStr =
              '${pii.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
          controller.text = timeStr;
        }
      },
      child: AbsorbPointer(
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            hintText: hint,
            prefixIcon: Icon(Icons.alarm, color: appColor.appColor.primary),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: appColor.appColor.primary),
            ),
            filled: true,
            fillColor: Colors.white,
            suffixIcon: Icon(
              Icons.keyboard_arrow_down,
              color: Colors.grey.shade400,
            ),
          ),
        ),
      ),
    );
  }
}
