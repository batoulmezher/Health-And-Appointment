import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_appointment_app/Routes/pages.dart';
import 'package:health_appointment_app/constant/imagesRoute.dart';
import 'package:health_appointment_app/models/onboarding_model.dart';

class OnboardingController extends GetxController {
  int currentPage = 0;
  final PageController pageController = PageController();

  List<OnboardingModel> pages = [
    OnboardingModel(
      image: AppImages.onboaringPhoto1,
      title1: "عناية",
      title2: "فائقة",
      title3: "الدقة",
      subTitle: "نراقب صحتك لحظة بلحظة لضمان حياة افضل وأسهل ",
    ),
    OnboardingModel(
      image: AppImages.onboaringPhoto4,
      title1: "متابعة",
      title2: "شاملة",
      title3: "آمنة",
      subTitle: "سجلّك الطبي معك أينما ذهبت، بشكل آمن ومحدث",
    ),
    OnboardingModel(
      image: AppImages.onboaringPhoto3,
      title1: "مواعيد",
      title2: "مرنة",
      title3: "دقيقة",
      subTitle: "اختر الوقت والطبيب المناسب لك بكل سهولة",
    ),
  ];
  late int pageCount = pages.length;

  Future<void> next() async {
    if (currentPage < pageCount - 1) {
      pageController.animateToPage(
        currentPage + 1,
        duration: Duration(milliseconds: 20),
        curve: Curves.easeInOut,
      );
      currentPage++;
      update();
    } else {
       Get.toNamed(AppRoutes.settingScreen);
    }

    update();
  }

  @override
  void onInit() {
    currentPage;
    super.onInit();
  }
}
