// lib/screens/user_settings_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:health_appointment_app/Routes/pages.dart';
import 'package:health_appointment_app/constant/colors.dart' as appColor;
import 'package:health_appointment_app/controller/user_controller.dart';

class UserSettingsScreen extends StatelessWidget {
  const UserSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Get.find<UserController>();
    final isDarkMode = Get.isDarkMode;

    final backgroundColor = isDarkMode ? const Color(0xFF0F0F1A) : const Color(0xFFF0F2F8);
    final cardColor = isDarkMode ? const Color(0xFF1A1A2E) : Colors.white;
    final textColor = isDarkMode ? Colors.white : const Color(0xFF1A1A2E);
    final subTextColor = isDarkMode ? Colors.white70 : const Color(0xFF6B7280);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: Text(
          'الإعدادات',
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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ===== بطاقة المستخدم =====
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
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: userController.userImage.isNotEmpty
                        ? NetworkImage(userController.userImage)
                        :  NetworkImage(
                            'https://ui-avatars.com/api/?name=User&background=001b48&color=fff&size=150',
                          ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userController.userName, // ✅ أضف .value
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        Text(
                          userController.userEmail.isNotEmpty // ✅ أضف .value
                              ? userController.userEmail // ✅ أضف .value
                              : 'user@example.com',
                          style: TextStyle(
                            fontSize: 14,
                            color: subTextColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.green.withOpacity(0.3)),
                          ),
                          child: Text(
                            'عضوية بريميوم',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.green.shade600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ===== قائمة الإعدادات =====
            _buildSettingsCard(
              title: 'الحساب',
              cardColor: cardColor,
              textColor: textColor,
              children: [
                _buildSettingsTile(
                  icon: Icons.person_outline,
                  title: 'الملف الشخصي',
                  subtitle: 'تعديل المعلومات الشخصية',
                  onTap: () => Get.toNamed(AppRoutes.profileScreen),
                  textColor: textColor,
                  subTextColor: subTextColor,
                ),
                _buildSettingsTile(
                  icon: Icons.medical_information,
                  title: 'الوصفات الطبية',
                  subtitle: 'عرض جميع الوصفات الطبية',
                  onTap: () => Get.toNamed(AppRoutes.prescriptions),
                  textColor: textColor,
                  subTextColor: subTextColor,
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: appColor.appColor.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '3 وصفات',
                      style: TextStyle(
                        fontSize: 11,
                        color: appColor.appColor.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                _buildSettingsTile(
                  icon: Icons.account_balance_wallet,
                  title: 'المحفظة',
                  subtitle: 'عرض الرصيد وإدارة الشحن',
                  onTap: () => Get.toNamed(AppRoutes.wallet),
                  textColor: textColor,
                  subTextColor: subTextColor,
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '1500 نقطة',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.amber.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            _buildSettingsCard(
              title: 'التطبيق',
              cardColor: cardColor,
              textColor: textColor,
              children: [
                _buildSettingsTile(
                  icon: Icons.notifications,
                  title: 'الإشعارات',
                  subtitle: 'إدارة إعدادات الإشعارات',
                  onTap: () => Get.toNamed(AppRoutes.notifications),
                  textColor: textColor,
                  subTextColor: subTextColor,
                ),
                _buildSettingsTile(
                  icon: Icons.language,
                  title: 'اللغة',
                  subtitle: 'العربية',
                  onTap: () {},
                  textColor: textColor,
                  subTextColor: subTextColor,
                ),
                _buildSettingsTile(
                  icon: Icons.dark_mode_outlined,
                  title: 'المظهر',
                  subtitle: 'وضع النظام',
                  onTap: () {},
                  textColor: textColor,
                  subTextColor: subTextColor,
                ),
              ],
            ),
            const SizedBox(height: 16),

            _buildSettingsCard(
              title: 'الدعم',
              cardColor: cardColor,
              textColor: textColor,
              children: [
                _buildSettingsTile(
                  icon: Icons.help_outline,
                  title: 'مركز المساعدة',
                  subtitle: 'الأسئلة الشائعة والدعم',
                  onTap: () {},
                  textColor: textColor,
                  subTextColor: subTextColor,
                ),
                _buildSettingsTile(
                  icon: Icons.privacy_tip_outlined,
                  title: 'سياسة الخصوصية',
                  subtitle: 'سياسة الخصوصية وشروط الاستخدام',
                  onTap: () {},
                  textColor: textColor,
                  subTextColor: subTextColor,
                ),
                _buildSettingsTile(
                  icon: Icons.logout,
                  title: 'تسجيل الخروج',
                  subtitle: 'تسجيل الخروج من الحساب',
                  onTap: () {
                    Get.defaultDialog(
                      title: 'تسجيل الخروج',
                      middleText: 'هل أنت متأكد من رغبتك في تسجيل الخروج؟',
                      textConfirm: 'تسجيل الخروج',
                      textCancel: 'إلغاء',
                      confirmTextColor: Colors.white,
                      onConfirm: () {
                        GetStorage().remove('token');
                        GetStorage().remove('user_id');
                        Get.offAllNamed('/login');
                      },
                    );
                  },
                  isLogout: true,
                  textColor: textColor,
                  subTextColor: subTextColor,
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsCard({
    required String title,
    required Color cardColor,
    required Color textColor,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color textColor,
    required Color subTextColor,
    Widget? trailing,
    bool isLogout = false,
  }) {
    final color = isLogout ? Colors.red : null;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isLogout
              ? Colors.red.withOpacity(0.1)
              : appColor.appColor.primary.withOpacity(0.08),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isLogout ? Colors.red : appColor.appColor.primary,
          size: 22,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isLogout ? Colors.red : textColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: subTextColor,
          fontSize: 12,
        ),
      ),
      trailing: trailing ?? Icon(Icons.arrow_forward_ios, color: Colors.grey.shade400, size: 16),
      onTap: onTap,
    );
  }
}