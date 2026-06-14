
import 'package:get/get.dart';
import 'package:health_appointment_app/Routes/pages.dart';
import 'package:health_appointment_app/screens/home.dart';
import 'package:health_appointment_app/screens/onboarding/onboarding.dart';
import 'package:health_appointment_app/screens/sitting_screen.dart';
import 'package:health_appointment_app/screens/splash/splash.dart';

final pages = <GetPage>[
  GetPage(
    name: AppRoutes.splashScreen,
    page: () =>  SplashScreen(),
  ),
   GetPage(
    name: AppRoutes.onboarding,
    page: () =>  Onboarding(),
  ),
  GetPage(
    name: AppRoutes.homeScreen,
    page: () => HomeScreen(),
  ),
  GetPage(
    name: AppRoutes.settingScreen,
    page: () => SettingsScreen(),
  ),
 
];
