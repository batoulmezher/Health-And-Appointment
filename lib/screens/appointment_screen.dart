import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_appointment_app/constant/colors.dart' as appColor;
import 'package:health_appointment_app/controller/appointment_conroller.dart';
import 'package:health_appointment_app/widgets/selver_app_bar.dart';


class AppointmentScreen extends StatelessWidget {
  const AppointmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AppointmentController());
    final isDarkMode = Get.isDarkMode;

    final backgroundColor = isDarkMode
        ? Colors.grey.shade900
        : const Color(0xFFF8F9FB);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: CustomScrollView(
        slivers: [
          ProAppBar(
            title: 'appointment_title'.tr,
            onBackPressed: () => Get.back(),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        'appointment_subtitle'.tr,
                        style: TextStyle(
                          fontSize: 14,
                          color: isDarkMode
                              ? Colors.white70
                              : Colors.grey.shade600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    CalendarSection(controller: controller),
                    const SizedBox(height: 20),
                    TimeSlotsSection(controller: controller),
                    const SizedBox(height: 20),
                    const DoctorInfoSection(),
                    const SizedBox(height: 20),
                    BookingSummarySection(timeText:controller.selectedTime.value.isEmpty
                            ? 'لم يتم الاختيار'
                            : controller.selectedTime.value, dataText:  controller.selectedDate.value.isEmpty
                            ? 'لم يتم الاختيار'
                            : 'Friday, Oct ${controller.selectedDate.value}, 2023',onPressed:  () {
                if (controller.selectedDate.value.isEmpty ||
                    controller.selectedTime.value.isEmpty) {
                  Get.snackbar(
                    'تنبيه',
                    'يرجى اختيار التاريخ والوقت',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.orange.shade100,
                    colorText: Colors.orange.shade900,
                  );
                  return;
                }
                Get.snackbar(
                  'success'.tr,
                  'booked_successfully'.tr,
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.green.shade100,
                  colorText: Colors.green.shade900,
                );
              },),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// Calendar Section Widget (مع Obx)
// ============================================================
class CalendarSection extends StatelessWidget {
  final AppointmentController controller;

  const CalendarSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Get.isDarkMode;
    final textColor = isDarkMode ? Colors.white : appColor.appColor.primary;
    final cardColor = isDarkMode ? Colors.grey.shade800 : Colors.white;

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
                onPressed: () {},
              ),
              Text(
                'october_2023'.tr,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () {},
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildDayHeader('sun'.tr),
              _buildDayHeader('mon'.tr),
              _buildDayHeader('tue'.tr),
              _buildDayHeader('wed'.tr),
              _buildDayHeader('thu'.tr),
              _buildDayHeader('fri'.tr),
              _buildDayHeader('sat'.tr),
            ],
          ),
          const SizedBox(height: 8),
          Obx(
            () => GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 1.2,
              ),
              itemCount: 14,
              itemBuilder: (context, index) {
                final day = (index + 4).toString();
                final isSelected = controller.selectedDate.value == day;
                return GestureDetector(
                  onTap: () => controller.selectDate(day),
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? appColor.appColor.primary
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        day,
                        style: TextStyle(
                          color: isSelected ? Colors.white : textColor,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayHeader(String day) {
    return Expanded(
      child: Center(
        child: Text(
          day,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}

// ============================================================
// Time Slots Section Widget (مع Obx)
// ============================================================
class TimeSlotsSection extends StatelessWidget {
  final AppointmentController controller;

  const TimeSlotsSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Get.isDarkMode;
    final textColor = isDarkMode ? Colors.white : appColor.appColor.primary;
    final subTextColor = isDarkMode ? Colors.white70 : const Color(0xFF44464F);
    final cardColor = isDarkMode ? Colors.grey.shade800 : Colors.white;

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
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 16),

          // Morning
          Text(
            'morning'.tr,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: subTextColor,
            ),
          ),
          const SizedBox(height: 8),
          Obx(
            () => Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _buildTimeChip('08:30 AM', controller.selectedTime.value == '08:30 AM'),
                _buildTimeChip('09:15 AM', controller.selectedTime.value == '09:15 AM'),
                _buildTimeChip('10:00 AM', controller.selectedTime.value == '10:00 AM'),
                _buildTimeChip('11:30 AM', controller.selectedTime.value == '11:30 AM'),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Afternoon
          Text(
            'afternoon'.tr,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: subTextColor,
            ),
          ),
          const SizedBox(height: 8),
          Obx(
            () => Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _buildTimeChip('01:45 PM', controller.selectedTime.value == '01:45 PM'),
                _buildTimeChip('02:30 PM', controller.selectedTime.value == '02:30 PM'),
                _buildTimeChip('03:15 PM', controller.selectedTime.value == '03:15 PM'),
                _buildTimeChip('04:00 PM', controller.selectedTime.value == '04:00 PM'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeChip(String time, bool isSelected) {
    return GestureDetector(
      onTap: () => controller.selectTime(time),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? appColor.appColor.primary : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? appColor.appColor.primary : Colors.grey.shade300,
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

// ============================================================
// Doctor Info Section Widget
// ============================================================
class DoctorInfoSection extends StatelessWidget {
  const DoctorInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Get.isDarkMode;
    final textColor = isDarkMode ? Colors.white : appColor.appColor.primary;
    final subTextColor = isDarkMode ? Colors.white70 : const Color(0xFF44464F);
    final cardColor = isDarkMode ? Colors.grey.shade800 : Colors.white;

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
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey.shade200,
            child: Text(
              'AT',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: appColor.appColor.primary,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'dr_aris_thorne'.tr,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: textColor,
                  ),
                ),
                Text(
                  'senior_cardiologist'.tr,
                  style: TextStyle(fontSize: 13, color: subTextColor),
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'expert'.tr,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.amber[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              Text(
                '14 ${'years'.tr}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              Text(
                'experience_label'.tr,
                style: TextStyle(fontSize: 12, color: subTextColor),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 14),
                  const SizedBox(width: 2),
                  Text(
                    '4.9',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ],
              ),
              Text(
                '(126)',
                style: TextStyle(fontSize: 12, color: subTextColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ============================================================
// Booking Summary Section Widget (مع Obx)
// ============================================================
class BookingSummarySection extends StatelessWidget {
 // final AppointmentController controller;
String? dataText ;
String? timeText ;
void Function()? onPressed;
   BookingSummarySection({super.key, required this.timeText,required this.dataText,this.onPressed});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Get.isDarkMode;
    final textColor = isDarkMode ? Colors.white : appColor.appColor.primary;
    final subTextColor = isDarkMode ? Colors.white70 : const Color(0xFF44464F);
    final cardColor = isDarkMode ? Colors.grey.shade800 : Colors.white;

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
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 12),
          Obx(
            () => Row(
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
                        dataText!,
                        // controller.selectedDate.value.isEmpty
                        //     ? 'لم يتم الاختيار'
                        //     : 'Friday, Oct ${controller.selectedDate.value}, 2023',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
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
                        timeText!,
                        // controller.selectedTime.value.isEmpty
                        //     ? 'لم يتم الاختيار'
                        //     : controller.selectedTime.value,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'total_label'.tr,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              Text(
                '500 ${'sp_currency'.tr}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: appColor.appColor.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
               onPressed:onPressed,
              //  () {
              //   if (controller.selectedDate.value.isEmpty ||
              //       controller.selectedTime.value.isEmpty) {
              //     Get.snackbar(
              //       'تنبيه',
              //       'يرجى اختيار التاريخ والوقت',
              //       snackPosition: SnackPosition.BOTTOM,
              //       backgroundColor: Colors.orange.shade100,
              //       colorText: Colors.orange.shade900,
              //     );
              //     return;
              //   }
              //   Get.snackbar(
              //     'success'.tr,
              //     'booked_successfully'.tr,
              //     snackPosition: SnackPosition.BOTTOM,
              //     backgroundColor: Colors.green.shade100,
              //     colorText: Colors.green.shade900,
              //   );
              // },
              style: ElevatedButton.styleFrom(
                backgroundColor: appColor.appColor.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'confirm_booking'.tr,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}