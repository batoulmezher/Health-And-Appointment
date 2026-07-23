// lib/main.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:health_appointment_app/Routes/pages.dart';
import 'package:health_appointment_app/Routes/routes.dart';
import 'package:health_appointment_app/controller/doctors_controller.dart';
import 'package:health_appointment_app/controller/home_controller.dart';
import 'package:health_appointment_app/controller/settings_controller.dart';
import 'package:health_appointment_app/controller/user_controller.dart';
import 'package:health_appointment_app/translations/app_translations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  Get.put(SettingsController());
  
  Get.lazyPut(() => UserController(), fenix: true);
  Get.lazyPut(() => HomeController(), fenix: true);
  Get.lazyPut(() => DoctorsController(), fenix: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final SettingsController settings = Get.find<SettingsController>();

    return Obx(
      () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'app_name'.tr,

        translations: AppTranslations(),
        locale: settings.currentLocale.value,
        fallbackLocale: const Locale('ar', 'SA'),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('ar', 'SA'), Locale('en', 'US')],

        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: settings.currentThemeMode.value,

        builder: (context, child) {
          return Directionality(
            textDirection: TextDirection.ltr,
            child: MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaleFactor: settings.fontSize.value / 16,
              ),
              child: child!,
            ),
          );
        },

        initialRoute: AppRoutes.login,
        getPages: pages,
      ),
    );
  }
}