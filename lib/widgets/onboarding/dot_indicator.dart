import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_appointment_app/controller/onboarding_controller.dart';

class DotIndicator extends StatelessWidget {
  const DotIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OnboardingController>(
      init:
          OnboardingController(), 
      builder: (controller) {
        return Directionality(
          textDirection: TextDirection.ltr,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              controller.pages.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 350),
                margin: const EdgeInsets.only(right: 5, bottom: 20),
                height: 5,
                width: controller.currentPage == index ? 20 : 10,
                decoration: BoxDecoration(
                  color: controller.currentPage == index
                      ? Colors.amber
                      : Colors.grey[400],
                  borderRadius: BorderRadius.circular(90),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
