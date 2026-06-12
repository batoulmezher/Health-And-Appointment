import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_appointment_app/controller/settings_controller.dart';
import 'package:health_appointment_app/screens/sitting_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final SettingsController settings = Get.find();

  @override
  Widget build(BuildContext context) {
   
    return Obx(() {
      debugPrint("HomeScreen rebuilt with fontSize: ${settings.fontSize.value}");
      
      return Scaffold(
        appBar: AppBar(
          title: Text('home'.tr),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () async {
                await Get.to(() =>  SettingsScreen());
                settings.update(); 
              },
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'welcome'.tr,
                style: TextStyle(fontSize: settings.fontSize.value),
              ),
              const SizedBox(height: 20),
              Text(
                'font_size'.tr,
                style: TextStyle(fontSize: settings.fontSize.value),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.teal.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      'current_font_size'.tr,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${settings.fontSize.value.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    Text(
                      settings.getCurrentFontLevel(),
                      style: const TextStyle(color: Colors.teal),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}