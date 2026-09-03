import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class SettingsController extends GetxController {
  var currentThemeMode = ThemeMode.system.obs;
  var currentLocale = Locale('ar', 'SA').obs;
  var fontSize = 16.0.obs;  

  final GetStorage _box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
  }

  void _loadSettings() {
    int? savedTheme = _box.read<int>('theme_mode');
    if (savedTheme != null) {
      currentThemeMode.value = ThemeMode.values[savedTheme];
    }

    String? savedLocale = _box.read<String>('locale');
    if (savedLocale != null) {
      currentLocale.value = savedLocale == 'ar'
          ? Locale('ar', 'SA')
          : Locale('en', 'US');
    }

    var savedFontSize = _box.read('font_size');
    if (savedFontSize != null) {
      if (savedFontSize is int) {
        fontSize.value = savedFontSize.toDouble();
      } else if (savedFontSize is double) {
        fontSize.value = savedFontSize;
      }
    }
  }

  void changeTheme(ThemeMode themeMode) {
    currentThemeMode.value = themeMode;
    _box.write('theme_mode', themeMode.index);
    update();
  }

  void changeLanguage(String languageCode) {
    Locale locale = languageCode == 'ar'
        ? Locale('ar', 'SA')
        : Locale('en', 'US');
    currentLocale.value = locale;
    _box.write('locale', languageCode);
    Get.updateLocale(locale);
  }

  void setSmallFont() {
    fontSize.value = 14;
    _box.write('font_size', 14);
  }

  void setMediumFont() {
    fontSize.value = 16;
    _box.write('font_size', 16);
  }

  void setLargeFont() {
    fontSize.value = 20;
    _box.write('font_size', 20);
  }

  String getCurrentFontLevel() {
    if (fontSize.value == 14) return 'small'.tr;
    if (fontSize.value == 20) return 'large'.tr;
    return 'medium'.tr;
  }
}
