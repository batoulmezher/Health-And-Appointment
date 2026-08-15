// lib/screens/alarms/alarms_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_appointment_app/constant/colors.dart' as appColor;
import 'package:health_appointment_app/controller/alarm_controller.dart';
import 'package:health_appointment_app/models/alarm_model.dart';
import 'package:health_appointment_app/screens/create_alarm_screen.dart';

class AlarmsScreen extends StatelessWidget {
  const AlarmsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AlarmController());
    final isDarkMode = Get.isDarkMode;

    final backgroundColor = isDarkMode
        ? const Color(0xFF0F0F1A)
        : const Color(0xFFF0F2F8);
    final cardColor = isDarkMode ? const Color(0xFF1A1A2E) : Colors.white;
    final textColor = isDarkMode ? Colors.white : const Color(0xFF1A1A2E);
    final subTextColor = isDarkMode ? Colors.white70 : const Color(0xFF6B7280);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: Text(
          'المنبهات',
          style: TextStyle(
            color: textColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: textColor),
          onPressed: () => Get.back(),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: appColor.appColor.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(Icons.add, color: appColor.appColor.primary),
              onPressed: () => Get.to(() => const CreateAlarmScreen()),
            ),
          ),
          IconButton(
            icon: Icon(Icons.refresh, color: textColor),
            onPressed: controller.fetchAlarms,
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
                  onPressed: controller.fetchAlarms,
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
        if (controller.alarms.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: appColor.appColor.primary.withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.alarm_off,
                    size: 64,
                    color: appColor.appColor.primary.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'لا توجد منبهات',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'أضف تذكير دواء جديد',
                  style: TextStyle(color: subTextColor),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => Get.to(() => const CreateAlarmScreen()),
                  icon: const Icon(Icons.add),
                  label: const Text('إضافة منبه'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appColor.appColor.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: controller.fetchAlarms,
          color: appColor.appColor.primary,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.alarms.length,
            itemBuilder: (context, index) {
              final alarm = controller.alarms[index];
              return _buildAlarmCard(alarm, controller, cardColor, textColor, subTextColor);
            },
          ),
        );
      }),
    );
  }

  Widget _buildAlarmCard(
    AlarmModel alarm,
    AlarmController controller,
    Color cardColor,
    Color textColor,
    Color subTextColor,
  ) {
    final isUpcoming = alarm.status == 'قادمة';
    final isMissed = alarm.status == 'فائتة';
    final statusColor = isUpcoming
        ? Colors.green.shade500
        : isMissed
            ? Colors.red.shade400
            : Colors.orange.shade400;
    final statusText = isUpcoming
        ? 'قادم'
        : isMissed
            ? 'فائت'
            : 'غير معروف';
    final statusIcon = isUpcoming
        ? Icons.pending
        : isMissed
            ? Icons.close
            : Icons.help_outline;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            cardColor,
            const Color(0xFFF8F9FC),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: alarm.isActive
              ? appColor.appColor.primary.withOpacity(0.15)
              : Colors.grey.shade300,
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: alarm.isActive
                            ? [
                                appColor.appColor.primary,
                                appColor.appColor.primary.withGreen(50),
                              ]
                            : [Colors.grey.shade400, Colors.grey.shade500],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: alarm.isActive
                              ? appColor.appColor.primary.withOpacity(0.3)
                              : Colors.grey.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.medication,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          alarm.medicineName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: textColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 14,
                              color: subTextColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              alarm.alarmTime,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: appColor.appColor.primary,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Icon(
                              Icons.repeat,
                              size: 14,
                              color: subTextColor,
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                alarm.frequency,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: subTextColor,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: statusColor.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(statusIcon, color: statusColor, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          statusText,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: statusColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildInfoChip(
                            icon: Icons.medication_liquid,
                            label: alarm.dosage,
                            color: subTextColor,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildInfoChip(
                            icon: Icons.numbers,
                            label: '${alarm.quantity}',
                            color: subTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Transform.scale(
                        scale: 0.8,
                        child: Switch(
                          value: alarm.isActive,
                          onChanged: (value) => controller.toggleAlarm(alarm.id, value),
                          activeColor: appColor.appColor.primary,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.delete_outline,
                          color: Colors.red.shade400,
                          size: 22,
                        ),
                        onPressed: () {
                          Get.dialog(
                            AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              title: Row(
                                children: [
                                  Icon(Icons.warning, color: Colors.red.shade400),
                                  const SizedBox(width: 8),
                                  const Text('تأكيد الحذف'),
                                ],
                              ),
                              content: Text('هل أنت متأكد من حذف منبه ${alarm.medicineName}؟'),
                              actions: [
                                TextButton(
                                  onPressed: () => Get.back(),
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.grey.shade600,
                                  ),
                                  child: const Text('إلغاء'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Get.back();
                                    controller.deleteAlarm(alarm.id);
                                  },
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.red.shade400,
                                  ),
                                  child: const Text('حذف'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}