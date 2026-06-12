import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_appointment_app/controller/settings_controller.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});
  final SettingsController settings = Get.find();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('settings'.tr),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          //      قسم اللغة 
          _buildSectionHeader('language'.tr),
          _buildLanguageOptions(),

          const Divider(),
          
          //      قسم الثيم 
          _buildSectionHeader('theme'.tr),
          _buildThemeOptions(),
          
          const Divider(),
          
          //       قسم حجم الخط  
          _buildSectionHeader('font_size'.tr),
          _buildFontSizeOptions(),
          
          // معاينة النص
          const SizedBox(height: 20),
          _buildFontPreview(),
        ],
      ),
    );
  }
  
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.teal,
        ),
      ),
    );
  }
  
  // خيارات اللغة
  Widget _buildLanguageOptions() {
    final SettingsController settings = Get.find();
    
    return Obx(() => Column(
      children: [
        RadioListTile<String>(
          title: const Text('العربية'),
          subtitle: const Text('Arabic'),
          value: 'ar',
          groupValue: settings.currentLocale.value.languageCode,
          onChanged: (value) {
            settings.changeLanguage('ar');
          },
        ),
        RadioListTile<String>(
          title: const Text('English'),
          subtitle: const Text('الإنجليزية'),
          value: 'en',
          groupValue: settings.currentLocale.value.languageCode,
          onChanged: (value) {
            settings.changeLanguage('en');
          },
        ),
      ],
    ));
  }
  
  Widget _buildThemeOptions() {
    final SettingsController settings = Get.find();
    
    return Obx(() => Column(
      children: [
        RadioListTile<ThemeMode>(
          title: Text('light_mode'.tr),
          value: ThemeMode.light,
          groupValue: settings.currentThemeMode.value,
          onChanged: (value) {
            settings.changeTheme(value!);
          },
        ),
        RadioListTile<ThemeMode>(
          title: Text('dark_mode'.tr),
          value: ThemeMode.dark,
          groupValue: settings.currentThemeMode.value,
          onChanged: (value) {
            settings.changeTheme(value!);
          },
        ),
        RadioListTile<ThemeMode>(
          title: Text('system_default'.tr),
          value: ThemeMode.system,
          groupValue: settings.currentThemeMode.value,
          onChanged: (value) {
            settings.changeTheme(value!);
          },
        ),
      ],
    ));
  }
  
  Widget _buildFontSizeOptions() {
    final SettingsController settings = Get.find();
    
    return Obx(() => Column(
      children: [
        // زر صغير
        _buildFontSizeButton(
          label: 'small'.tr,
          fontSize: 14,
          isSelected: settings.fontSize.value == 14,
          icon: Icons.text_decrease,
          onTap: () => settings.setSmallFont(),
        ),
        
        // زر متوسط
        _buildFontSizeButton(
          label: 'medium'.tr,
          fontSize: 16,
          isSelected: settings.fontSize.value == 16,
          icon: Icons.text_fields,
          onTap: () => settings.setMediumFont(),
        ),
        
        // زر كبير
        _buildFontSizeButton(
          label: 'large'.tr,
          fontSize: 20,
          isSelected: settings.fontSize.value == 20,
          icon: Icons.text_increase,
          onTap: () => settings.setLargeFont(),
        ),
      ],
    ));
  }
  
  Widget _buildFontSizeButton({
    required String label,
    required double fontSize,
    required bool isSelected,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected ? Colors.teal.withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? Colors.teal : Colors.grey.shade300,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.teal : Colors.grey,
                size: 30,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.teal : null,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'نموذج نص تجريبي',
                      style: TextStyle(
                        fontSize: fontSize,
                        color: isSelected ? Colors.teal : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: Colors.teal,
                  size: 28,
                ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildFontPreview() {
    final SettingsController settings = Get.find();
    
    return Obx(() => Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.teal.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            'معاينة حجم الخط',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'هذا نص تجريبي لتوضيح حجم الخط',
            style: TextStyle(fontSize: settings.fontSize.value),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'This is a sample text to show font size',
            style: TextStyle(fontSize: settings.fontSize.value),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ));
  }
}