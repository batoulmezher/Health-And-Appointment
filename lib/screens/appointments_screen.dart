// lib/screens/appointment_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_appointment_app/constant/colors.dart' as appColor;
import 'package:health_appointment_app/controller/appointment_controller.dart';
import 'package:intl/intl.dart';

class AppointmentScreen extends StatelessWidget {
  const AppointmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AppointmentController());
    final isDarkMode = Get.isDarkMode;

    final backgroundColor = isDarkMode ? Colors.grey.shade900 : const Color(0xFFF8F9FB);
    final cardColor = isDarkMode ? Colors.grey.shade800 : Colors.white;
    final textColor = isDarkMode ? Colors.white : appColor.appColor.primary;
    final subTextColor = isDarkMode ? Colors.white70 : const Color(0xFF44464F);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: textColor),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'schedule_appointment'.tr,
          style: TextStyle(color: textColor, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'select_preferred_date_time'.tr,
              style: TextStyle(fontSize: 14, color: subTextColor),
            ),
            const SizedBox(height: 24),

            GetBuilder<AppointmentController>(
              builder: (controller) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.chevron_left),
                            onPressed: () => controller.changeMonth(-1),
                          ),
                          Text(
                            '${controller.getMonthName(controller.currentMonth.value)} ${controller.currentYear.value}',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
                          ),
                          IconButton(
                            icon: const Icon(Icons.chevron_right),
                            onPressed: () => controller.changeMonth(1),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildDayHeader('أحد'),
                          _buildDayHeader('إثن'),
                          _buildDayHeader('ثلاث'),
                          _buildDayHeader('أربع'),
                          _buildDayHeader('خميس'),
                          _buildDayHeader('جمعة'),
                          _buildDayHeader('سبت'),
                        ],
                      ),
                      const SizedBox(height: 8),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 7,
                          childAspectRatio: 1.0, 
                        ),
                        itemCount: controller.daysList.length,
                        itemBuilder: (context, index) {
                          final dayData = controller.daysList[index];
                          final day = dayData['day'];
                          final dateString = dayData['dateString'];
                          final isToday = dayData['isToday'];
                          final isSelected = controller.selectedDate.value == dateString;
                          final isPast = dayData['isPast'] ?? false;

                          return GestureDetector(
                            onTap: () => controller.selectDate(dateString),
                            child: Container(
                              margin: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? appColor.appColor.primary
                                    : isToday
                                        ? appColor.appColor.primary.withOpacity(0.1)
                                        : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (isToday)
                                      Text(
                                        'اليوم',
                                        style: TextStyle(
                                          fontSize: 8,
                                          color: isSelected ? Colors.white : appColor.appColor.primary,
                                        ),
                                      ),
                                    Text(
                                      day,
                                      style: TextStyle(
                                        color: isSelected ? Colors.white : textColor,
                                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 20),

            GetBuilder<AppointmentController>(
              builder: (controller) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'available_time_slots'.tr,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
                      ),
                      const SizedBox(height: 16),
                      if (controller.isLoading.value)
                        const Center(child: CircularProgressIndicator())
                      else if (controller.errorMessage.isNotEmpty)
                        Text(
                          controller.errorMessage.value,
                          style: TextStyle(color: Colors.red.shade700),
                        )
                      else if (controller.availableTimes.isEmpty)
                        Text(
                          'لا توجد مواعيد متاحة لهذا التاريخ',
                          style: TextStyle(color: subTextColor),
                        )
                      else
                        Wrap(
                          spacing: 7,
                          runSpacing: 10,
                          children: controller.availableTimes.map((time) {
                            return _buildTimeChip(
                              time,
                              controller.selectedTime.value == time,
                              controller,
                            );
                          }).toList(),
                        ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 20),


            GetBuilder<AppointmentController>(
              builder: (controller) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'booking_summary'.tr,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'date_label'.tr,
                                  style: TextStyle(fontSize: 12, color: subTextColor),
                                ),
                                Text(
                                  controller.selectedDate.value.isEmpty
                                      ? 'لم يتم الاختيار'
                                      : DateFormat('EEEE، d MMMM yyyy', 'ar')
                                          .format(DateTime.parse(controller.selectedDate.value)),
                                  style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'time_label'.tr,
                                  style: TextStyle(fontSize: 12, color: subTextColor),
                                ),
                                Text(
                                  controller.selectedTime.value.isEmpty
                                      ? 'لم يتم الاختيار'
                                      : controller.selectedTime.value,
                                  style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'total_label'.tr,
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
                          ),
                          Text(
                            '500 ${'sp_currency'.tr}',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: appColor.appColor.primary),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: controller.isLoading.value ? null : () => controller.bookAppointment(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: appColor.appColor.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: controller.isLoading.value
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text('confirm_booking'.tr, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(Icons.info_outline, size: 16, color: Colors.grey.shade400),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'changes_up_to_24h'.tr,
                              style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayHeader(String day) {
    return Expanded(
      child: Center(
        child: Text(
          day,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildTimeChip(String time, bool isSelected, AppointmentController controller) {
    return GestureDetector(
      onTap: () => controller.selectTime(time),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? appColor.appColor.primary : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? appColor.appColor.amber : Colors.grey.shade300,
          ),
        ),
        child: Text(
          time,
          style: TextStyle(
            color: isSelected ? Colors.white : appColor.appColor.primary,
            fontWeight: FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}