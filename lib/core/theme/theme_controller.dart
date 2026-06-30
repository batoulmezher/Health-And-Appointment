import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'app_theme.dart';

class ThemeController extends GetxController {
  final GetStorage _box = GetStorage();
  final String _themeKey = 'isDarkMode';
  var isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadTheme();
    _applyTheme();
  }

  void _loadTheme() {
    isDarkMode.value = _box.read(_themeKey) ?? false;
  }

  void _applyTheme() {
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    _box.write(_themeKey, isDarkMode.value);
    _applyTheme();
  }
}