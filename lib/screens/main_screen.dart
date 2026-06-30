import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_appointment_app/constant/colors.dart' as appColor;
import 'package:health_appointment_app/screens/appointments_screen.dart';
import 'package:health_appointment_app/screens/home_screen.dart';
import 'package:health_appointment_app/screens/messages_screen.dart';
import 'package:health_appointment_app/screens/profile_screen.dart';


class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MainScreenController());
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey.shade900 : appColor.appColor.grownd,
      body: Obx(() => controller.pages[controller.currentIndex.value]),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          onTap: (index) => controller.changePage(index),
          backgroundColor: isDarkMode ? Colors.black : Colors.white,
          selectedItemColor: appColor.appColor.primary,
          unselectedItemColor: isDarkMode ? Colors.white54 : Colors.grey.shade600,
          selectedLabelStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: appColor.appColor.primary,
          ),
          unselectedLabelStyle: TextStyle(
            color: isDarkMode ? Colors.white54 : Colors.grey.shade600,
          ),
          elevation: 8,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'الرئيسية',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today_outlined),
              activeIcon: Icon(Icons.calendar_today),
              label: 'الحجوزات',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline),
              activeIcon: Icon(Icons.chat_bubble),
              label: 'الرسائل',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'ملفي',
            ),
          ],
        ),
      ),
    );
  }
}

// ✅ Controller لإدارة التنقل بين الصفحات
class MainScreenController extends GetxController {
  var currentIndex = 0.obs;

  final pages = [
    const HomeScreen(),
    const AppointmentsScreen(),
    const MessagesScreen(),
    const ProfileScreen(),
  ];

  void changePage(int index) {
    currentIndex.value = index;
  }
}