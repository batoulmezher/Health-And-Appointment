import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'ar_SA': {
      // عام
      'app_name': 'تطبيقي',
      'welcome': 'مرحباً بك',
      'settings': 'الإعدادات',
      'home': 'الرئيسية',
      
      // الإعدادات
      'language': 'اللغة',
      'arabic': 'العربية',
      'english': 'English',
      'theme': 'المظهر',
      'light_mode': 'وضع نهاري',
      'dark_mode': 'وضع ليلي',
      'system_default': 'إعدادات النظام',
      'font_size': 'حجم الخط',
      'small': 'صغير',
      'medium': 'متوسط',
      'large': 'كبير',
      
      // رسائل
      'language_changed': 'تم تغيير اللغة',
      'theme_changed': 'تم تغيير المظهر',
      'font_size_changed': 'تم تغيير حجم الخط',
    },
    'en_US': {
      // General
      'app_name': 'My App',
      'welcome': 'Welcome',
      'settings': 'Settings',
      'home': 'Home',
      
      // Settings
      'language': 'Language',
      'arabic': 'العربية',
      'english': 'English',
      'theme': 'Theme',
      'light_mode': 'Light Mode',
      'dark_mode': 'Dark Mode',
      'system_default': 'System Default',
      'font_size': 'Font Size',
      'small': 'Small',
      'medium': 'Medium',
      'large': 'Large',
      
      // Messages
      'language_changed': 'Language changed',
      'theme_changed': 'Theme changed',
      'font_size_changed': 'Font size changed',
    }
  };
}