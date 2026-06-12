import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_appointment_app/Routes/pages.dart';
import 'dart:ui' as ui;
import 'package:health_appointment_app/constant/colors.dart';
import 'package:health_appointment_app/constant/imagesRoute.dart';
import 'package:health_appointment_app/controller/splash_controller.dart';

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
                  () => AnimatedOpacity(
                    duration: Duration(milliseconds: 600),
                    opacity: controller.showText1.value ? 1.0 : 0.0,
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 600),
                      transform: Matrix4.translationValues(
                        0,
                        controller.showText1.value ? 0 : 30,
                        0,
                      ),
                      child: Text(
                        'Health & Appointment',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),

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
                  () => AnimatedOpacity(
                    duration: Duration(milliseconds: 600),
                    opacity: controller.showText2.value ? 1.0 : 0.0,
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 600),
                      transform: Matrix4.translationValues(
                        0,
                        controller.showText2.value ? 0 : 30,
                        0,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 50.0,),
                        child: Text(
                          "رعاية طبية بمستوى عالمي ,مصممة\n لأجلك",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                Obx(
                  () => AnimatedOpacity(
                    duration: Duration(milliseconds: 600),
                    opacity: controller.showText3.value ? 1.0 : 0.0,
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 600),
                      transform: Matrix4.translationValues(
                        0,
                        controller.showText3.value ? 0 : 30,
                        0,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 10.0,
                          bottom: 10,
                          left: 30,
                          right: 30,
                        ),
                        child: Text(
                          "اكتشف تجربة صحية فاخرة تجمع بين الدقة الطبية والراحة الاستثنائية في أرقى المرافق العلاجية.",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 17),
                        ),
                      ),
                    ),
                  ),
                ),

                Obx(
                  () => AnimatedOpacity(
                    duration: Duration(milliseconds: 600),
                    opacity: controller.showButton.value ? 1.0 : 0.0,
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 600),
                      transform: Matrix4.translationValues(
                        0,
                        controller.showButton.value ? 0 : 30,
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
                            // التنقل إلى الشاشة التالية
                            Get.offAllNamed(AppRoutes.homeScreen);
                            // أو يمكنك إضافة أي إجراء آخر
                            print("بدء الرحلة");
                          },
                          color: appColor.grownd,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                               Icon(Icons.arrow_back, size: 28,color: appColor.primary,),
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
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
