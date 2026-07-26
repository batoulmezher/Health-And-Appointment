// lib/screens/my_appointments_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_appointment_app/models/appointment%20_model.dart';
import 'package:intl/intl.dart';
import 'package:health_appointment_app/constant/colors.dart' as appColor;
import 'package:health_appointment_app/controller/my_appointments_controller.dart';

class MyAppointmentsScreen extends StatelessWidget {
  const MyAppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MyAppointmentsController());
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
        title: Text(
          'مواعيدي',
          style: TextStyle(color: textColor, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: textColor),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
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
                  onPressed: controller.fetchAppointments,
                  child: const Text('إعادة المحاولة'),
                ),
              ],
            ),
          );
        }
        if (controller.appointments.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.calendar_today, size: 60, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text(
                  'لا توجد مواعيد حالياً',
                  style: TextStyle(fontSize: 18, color: subTextColor),
                ),
                const SizedBox(height: 8),
                Text(
                  'يمكنك حجز موعد جديد من خلال ملف الطبيب',
                  style: TextStyle(fontSize: 14, color: subTextColor),
                ),
              ],
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: controller.fetchAppointments,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.appointments.length,
            itemBuilder: (context, index) {
              final appointment = controller.appointments[index];
              return _buildAppointmentCard(
                appointment,
                index,
                controller,
                cardColor,
                textColor,
                subTextColor,
                context,
              );
            },
          ),
        );
      }),
    );
  }

  Widget _buildAppointmentCard(
    AppointmentModel appointment,
    int index,
    MyAppointmentsController controller,
    Color cardColor,
    Color textColor,
    Color subTextColor,
    BuildContext context,
  ) {
    String formattedDate = appointment.appointmentDate;
    try {
      final dateTime = DateTime.parse(appointment.appointmentDate);
      formattedDate = DateFormat('EEEE، d MMMM yyyy', 'ar').format(dateTime);
    } catch (_) {}

    String formattedTime = appointment.appointmentTime;
    try {
      final timeParts = appointment.appointmentTime.split(':');
      if (timeParts.length >= 2) {
        final hour = int.parse(timeParts[0]);
        final minute = timeParts[1];
        final period = hour >= 12 ? 'م' : 'ص';
        final hour12 = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
        formattedTime = '$hour12:$minute $period';
      }
    } catch (_) {}

    Color statusColor;
    String statusText;
    IconData statusIcon;
    switch (appointment.status) {
      case 'PENDING':
        statusColor = Colors.orange;
        statusText = 'قيد الانتظار';
        statusIcon = Icons.pending_outlined;
        break;
      case 'APPROVED':
        statusColor = Colors.green;
        statusText = "مقبول";
        statusIcon = Icons.check_circle_outline;
        break;
      case 'CANCELED':
        statusColor = Colors.red;
        statusText = 'ملغي';
        statusIcon = Icons.cancel_outlined;
        break;
      default:
        statusColor = Colors.grey;
        statusText = appointment.status;
        statusIcon = Icons.help_outline;
    }

    final bool canCancel = appointment.status == 'PENDING';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: appointment.doctorProfilePic != null
                      ? NetworkImage(appointment.doctorProfilePic!)
                      : null,
                  backgroundColor: Colors.grey.shade200,
                  child: appointment.doctorProfilePic == null
                      ? Text(
                          appointment.doctorName.isNotEmpty
                              ? appointment.doctorName[0].toUpperCase()
                              : '?',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: appColor.appColor.primary,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment.doctorName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: textColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        appointment.specialtyName,
                        style: TextStyle(
                          fontSize: 13,
                          color: subTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: statusColor.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon, color: statusColor, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        statusText,
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
               
              ],
            ),
            
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: subTextColor),
                const SizedBox(width: 6),
                Text(
                  formattedDate,
                  style: TextStyle(color: subTextColor, fontSize: 14),
                ),
                const SizedBox(width: 20),
                Icon(Icons.access_time, size: 16, color: subTextColor),
                const SizedBox(width: 6),
                Text(
                  formattedTime,
                  style: TextStyle(color: subTextColor, fontSize: 14),
                ),
                
              ],
            ),
            if (appointment.clinicLocation != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: subTextColor),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      appointment.clinicLocation!,
                      style: TextStyle(color: subTextColor, fontSize: 13),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                   if (canCancel) ...[
                  const SizedBox(width: 8),
                  Obx(() {
                    final isCancelling = controller.isCancelling.value;
                    return IconButton(
                      icon: Icon(
                        Icons.delete_outline,
                        color: isCancelling ? Colors.grey : Colors.red.shade400,
                        size: 22,
                      ),
                      onPressed: isCancelling
                          ? null
                          : () => _showCancelDialog(
                              context,
                              appointment.id,
                              index,
                              controller,
                            ),
                      splashRadius: 20,
                    );
                  }),
                ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showCancelDialog(
    BuildContext context,
    int appointmentId,
    int index,
    MyAppointmentsController controller,
  ) {
    Get.dialog(
      AlertDialog(
        title: const Text('تأكيد الإلغاء'),
        content: const Text('هل أنت متأكد من رغبتك في إلغاء هذا الموعد؟'),
        actions: [
          TextButton(
            onPressed: () => Get.back(), // إغلاق الـ Dialog
            child: const Text('تراجع'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.cancelAppointment(appointmentId, index);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('تأكيد الإلغاء'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }
}