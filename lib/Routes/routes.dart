
import 'package:get/get.dart';
import 'package:health_appointment_app/Routes/pages.dart';
import 'package:health_appointment_app/screens/all_doctors_screen.dart';
import 'package:health_appointment_app/screens/auth/forget_password_screen.dart';
import 'package:health_appointment_app/screens/auth/login_screen.dart';
import 'package:health_appointment_app/screens/auth/otp_register_screen.dart';
import 'package:health_appointment_app/screens/auth/otp_verification_screen.dart';
import 'package:health_appointment_app/screens/auth/register_screen.dart';
import 'package:health_appointment_app/screens/auth/reset_password_screen.dart';
import 'package:health_appointment_app/screens/doctor_profile_screen.dart';
import 'package:health_appointment_app/screens/home_screen.dart';
import 'package:health_appointment_app/screens/main_screen.dart';
import 'package:health_appointment_app/screens/onboarding/onboarding.dart';
import 'package:health_appointment_app/screens/sitting_screen.dart';
import 'package:health_appointment_app/screens/specialties_screen.dart';
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
    name: AppRoutes.settingScreen,
    page: () => SettingsScreen(),
  ),
   GetPage(
    name: AppRoutes.login,
    page: () => LoginScreen(),
  ),
  GetPage(
    name: AppRoutes.register,
    page: () => RegisterScreen(),
  ),
   GetPage(
    name: AppRoutes.forgotPassword,
    page: () => ForgetPasswordScreen(),
  ),
    GetPage(
    name: AppRoutes.otpVerification,
    page: () => OtpVerificationScreen(),
  ),
   GetPage(
    name: AppRoutes.resetPassword,
    page: () => ResetPasswordScreen(),
  ),
    GetPage(
    name: AppRoutes.homeScreen,
    page: () => HomeScreen(),
  ),
   GetPage(
    name: AppRoutes.mainScreen,
    page: () => MainScreen(),
  ),
   GetPage(
    name: AppRoutes.specialtiesScreen,
    page: () => SpecialtiesScreen(),
  ),
   GetPage(
    name: AppRoutes.allDoctors,
    page: () => AllDoctorsScreen(),
  ),
  GetPage(
    name: AppRoutes.otpRegister,
    page: () => OtpRegisterScreen(),
  ),
   GetPage(
    name: AppRoutes.doctorProfileScreen,
    page: () => DoctorProfileScreen(),
  ),
];
