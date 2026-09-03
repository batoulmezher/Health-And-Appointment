import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui' as ui;
import 'package:health_appointment_app/constant/imagesRoute.dart';
import 'package:health_appointment_app/controller/splash_controller.dart';
import 'package:health_appointment_app/widgets/splash/splash_button.dart';
import 'package:health_appointment_app/widgets/splash/splash_subtitle.dart';
import 'package:health_appointment_app/widgets/splash/splash_subtitle2.dart';
import 'package:health_appointment_app/widgets/splash/splash_title.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SplashController controller = Get.put(SplashController());

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(AppImages.splahPhoto, fit: BoxFit.cover),

          Container(color: const Color(0xFF00040c).withOpacity(0.8)),

          ClipRect(
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 9.0, sigmaY: 9.0),
              child: Container(color: Colors.transparent),
            ),
          ),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(
                  () => 
                SplashTitle(
                  opacity: controller.showText1.value ? 1.0 : 0.0,
                  opacity1: controller.showText1.value ? 0 : 30,
                ),),

                Padding(
                  padding: const EdgeInsets.only(
                    top: 20.0,
                    bottom: 20,
                    left: 30,
                    right: 30,
                  ),
                  child: LinearProgressIndicator(
                    minHeight: 2,
                    backgroundColor: Colors.transparent,
                    color: const Color(0xFF006D4F),
                  ),
                ),

                Obx(
                  () => SplashSubtitle(opacity: controller.showText2.value ? 1.0 : 0.0, opacity1: controller.showText2.value ? 0 : 30,)
                ),

                Obx(
                  () => SplashSubtitle2(opacity: controller.showText3.value ? 1.0 : 0.0, opacity1: controller.showText3.value ? 0 : 30,)
                ),

                Obx(
                  () => SplashButton(opacity1: controller.showButton.value ? 0 : 30, opacity: controller.showButton.value ? 1.0 : 0.0,)
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
