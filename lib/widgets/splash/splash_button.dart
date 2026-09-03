import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:health_appointment_app/Routes/pages.dart';
import 'package:health_appointment_app/constant/colors.dart';

class SplashButton extends StatelessWidget {
  double opacity;
  double opacity1;
   SplashButton({super.key,required this.opacity,required this.opacity1});

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
                    duration: Duration(milliseconds: 600),
                    opacity:opacity,
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 600),
                      transform: Matrix4.translationValues(
                        0,
                        opacity1,
                       // controller.showButton.value ? 0 : 30,
                        0,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 50.0,
                          left: 70,
                          right: 70,
                        ),
                        child: MaterialButton(
                          height: 60,
                          onPressed: () {
                            Get.toNamed(AppRoutes.onboarding);
                            print("بدء الرحلة");
                          },
                          color: appColor.grownd,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.arrow_back,
                                size: 28,
                                color: appColor.primary,
                              ),
                              const SizedBox(width: 20),
                              Text(
                                "ابدأ الرحلة",
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: appColor.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
  }
}