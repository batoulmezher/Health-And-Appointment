// lib/screens/prescription_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_appointment_app/constant/colors.dart' as appColor;
import 'package:health_appointment_app/controller/prescription_controller.dart';
import 'package:health_appointment_app/models/prescription.dart';
import 'package:intl/intl.dart';

class PrescriptionDetailScreen extends StatelessWidget {
  final int prescriptionId;

  const PrescriptionDetailScreen({
    super.key,
    required this.prescriptionId,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PrescriptionController());
    final isDarkMode = Get.isDarkMode;

    final backgroundColor = isDarkMode ? const Color(0xFF0F0F1A) : const Color(0xFFF0F2F8);
    final cardColor = isDarkMode ? const Color(0xFF1A1A2E) : Colors.white;
    final textColor = isDarkMode ? Colors.white : const Color(0xFF1A1A2E);
    final subTextColor = isDarkMode ? Colors.white70 : const Color(0xFF6B7280);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cached = controller.prescriptions.firstWhereOrNull(
        (p) => p.id == prescriptionId,
      );
      if (cached != null) {
      }
    });

    final prescription = controller.prescriptions.firstWhereOrNull(
      (p) => p.id == prescriptionId,
    );

    if (prescription == null) {
      return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: backgroundColor,
          elevation: 0,
          title: Text(
            'تفاصيل الوصفة',
            style: TextStyle(color: textColor, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: textColor),
            onPressed: () => Get.back(),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 60, color: Colors.grey.shade400),
              const SizedBox(height: 16),
              Text(
                'لم يتم العثور على الوصفة',
                style: TextStyle(color: subTextColor),
              ),
            ],
          ),
        ),
      );
    }

    final appointment = prescription.appointment;
    final date = DateFormat('dd/MM/yyyy').format(prescription.createdAt);
    final time = appointment.appointmentTime;
    final hasFile = prescription.fileUrl != null && prescription.fileUrl!.isNotEmpty;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: Text(
          'تفاصيل الوصفة',
          style: TextStyle(color: textColor, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: textColor),
          onPressed: () => Get.back(),
        ),
        actions: [
          if (hasFile)
            Obx(() {
              return IconButton(
                icon: Icon(
                  Icons.download,
                  color: controller.isDownloading.value ? Colors.grey : textColor,
                ),
                onPressed: controller.isDownloading.value
                    ? null
                    : () => controller.downloadPrescription(prescription.id),
              );
            }),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20),
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
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: appColor.appColor.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          Icons.medication,
                          color: appColor.appColor.primary,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              appointment.doctorName,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                            Text(
                              'وصفة طبية',
                              style: TextStyle(
                                fontSize: 14,
                                color: subTextColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.green.withOpacity(0.3)),
                        ),
                        child: Text(
                          'نشطة',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.green.shade600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 12),
                  _buildDetailRow(
                    icon: Icons.calendar_today,
                    label: 'تاريخ الوصفة',
                    value: date,
                    textColor: textColor,
                    subTextColor: subTextColor,
                  ),
                  const SizedBox(height: 8),
                  _buildDetailRow(
                    icon: Icons.access_time,
                    label: 'وقت الموعد',
                    value: time,
                    textColor: textColor,
                    subTextColor: subTextColor,
                  ),
                  const SizedBox(height: 8),
                  _buildDetailRow(
                    icon: Icons.person,
                    label: 'المريض',
                    value: appointment.patientName,
                    textColor: textColor,
                    subTextColor: subTextColor,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20),
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
                        Icons.notes,
                        color: appColor.appColor.primary,
                        size: 22,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'التعليمات',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    prescription.instructions,
                    style: TextStyle(
                      fontSize: 16,
                      color: subTextColor,
                      height: 1.8,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20),
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
                        Icons.medication,
                        color: appColor.appColor.primary,
                        size: 22,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'الأدوية الموصوفة',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ..._extractMedicines(prescription.instructions).map((medicine) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: subTextColor.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: subTextColor.withOpacity(0.1),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.circle,
                            size: 8,
                            color: appColor.appColor.primary,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              medicine,
                              style: TextStyle(
                                fontSize: 15,
                                color: textColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    required Color textColor,
    required Color subTextColor,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: subTextColor),
        const SizedBox(width: 12),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: subTextColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ],
    );
  }

  List<String> _extractMedicines(String instructions) {
    final lines = instructions.split('\n');
    final medicines = <String>[];
    for (var line in lines) {
      final trimmed = line.trim();
      if (trimmed.isNotEmpty && !trimmed.startsWith('المدة') && !trimmed.startsWith('جرعة')) {
        medicines.add(trimmed);
      }
    }
    if (medicines.isEmpty && instructions.isNotEmpty) {
      return [instructions];
    }
    return medicines;
  }
}