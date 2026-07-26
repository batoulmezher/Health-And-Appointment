import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_appointment_app/constant/colors.dart' as appColor;
import 'package:health_appointment_app/screens/appointments_screen.dart';
import 'package:health_appointment_app/screens/home_screen.dart';
import 'package:health_appointment_app/screens/messages_screen.dart';
import 'package:health_appointment_app/screens/my_appointments_screen.dart';
import 'package:health_appointment_app/screens/profile_screen.dart';
import 'package:health_appointment_app/screens/wallet_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MainScreenController());
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode
          ? Colors.grey.shade900
          : appColor.appColor.grownd,
      body: Obx(() => controller.pages[controller.currentIndex.value]),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          onTap: (index) => controller.changePage(index),
          backgroundColor: isDarkMode ? Colors.black : Colors.white,
          selectedItemColor: appColor.appColor.primary,
          unselectedItemColor: isDarkMode
              ? Colors.white54
              : Colors.grey.shade600,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(),
          elevation: 8,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_outlined),
              activeIcon: const Icon(Icons.home),
              label: 'nav_home'.tr,
            ),

            BottomNavigationBarItem(
              icon: const Icon(Icons.calendar_today_outlined),
              activeIcon: const Icon(Icons.calendar_today),
              label: 'nav_appointments'.tr,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.publish_outlined),
              activeIcon: const Icon(Icons.publish),
              label: 'nav_post'.tr,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.chat_bubble_outline),
              activeIcon: const Icon(Icons.chat_bubble),
              label: 'nav_messages'.tr,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person_outline),
              activeIcon: const Icon(Icons.person),
              label: 'nav_profile'.tr,
            ),
          ],
        ),
      ),
    );
  }
}

class MainScreenController extends GetxController {
  var currentIndex = 0.obs;

  final pages = [
    const HomeScreen(),
    const MyAppointmentsScreen(),
    const WalletScreen(),

    const ProfileScreen(),
  ];

  void changePage(int index) {
    currentIndex.value = index;
  }
}
