import 'package:get/get.dart';

class SplashController extends GetxController {
  var showText1 = false.obs;
  var showText2 = false.obs;
  var showText3 = false.obs;
  var showButton = false.obs;

  @override
  void onInit() {
    super.onInit();
    startAnimation();
  }

  void startAnimation() async {
    await Future.delayed(Duration(seconds: 0));
    showText1.value = true;

    await Future.delayed(Duration(seconds: 2));
    showText2.value = true;

    await Future.delayed(Duration(seconds: 2));
    showText3.value = true;

    await Future.delayed(Duration(seconds: 1));
    showButton.value = true;
  }
}