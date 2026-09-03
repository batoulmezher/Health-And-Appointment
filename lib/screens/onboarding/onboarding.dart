import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_appointment_app/constant/colors.dart';
import 'package:health_appointment_app/controller/onboarding_controller.dart';
import 'package:health_appointment_app/widgets/onboarding/dot_indicator.dart';
class Onboarding extends StatelessWidget {
  Onboarding({super.key});
  OnboardingController controller = Get.put(OnboardingController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<OnboardingController>(
      builder: (controller) {
        return Scaffold(
          body: PageView.builder(
            reverse: true,
            //  physics: NeverScrollableScrollPhysics(),
            onPageChanged: (value) {
              controller.currentPage = value;
              controller.update();
            },
            itemCount: controller.pageCount,
            controller: controller.pageController,
            itemBuilder: (context, index) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    //AppImages.onboaringPhoto1,
                    controller.pages[index].image,
                    fit: BoxFit.cover,
                    colorBlendMode: BlendMode.hardLight,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 200.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.white70,
                        gradient: LinearGradient(
                          begin: Alignment.bottomRight,
                          end: AlignmentGeometry.topLeft,
                          colors: [
                            Colors.white24,
                            ui.Color.fromARGB(255, 12, 35, 75),

                            appColor.primary,
                          ],
                        ),
                      ),
                      height: 300,
                      width: 400,
                    ),
                  ),
                  Padding(  
                    padding: const EdgeInsets.only(top: 250),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: controller.pages[index].title1,
                                style: TextStyle(
                                  fontSize: 50,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: controller.pages[index].title2,
                                style: TextStyle(
                                  fontSize: 55,
                                  color: Colors.amberAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: controller.pages[index].title3,
                                style: TextStyle(
                                  fontSize: 50,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          controller.pages[index].subTitle,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 100),
                        DotIndicator(),
                        Container(
                          margin: EdgeInsets.only(top: 90),
                          decoration: BoxDecoration(
                            color: appColor.primary,
                            borderRadius: BorderRadius.circular(40),
                            border: Border.all(color: Colors.amber, width: 2),
                          ),
                          child: MaterialButton(
                            minWidth: 180,
                            onPressed: () {
                              controller.next();
                            },
                            child: Text(
                              "Continue",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
