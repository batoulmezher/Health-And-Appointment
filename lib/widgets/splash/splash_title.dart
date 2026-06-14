import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class SplashTitle extends StatelessWidget {
  double opacity;
  double opacity1;

  SplashTitle({super.key, required this.opacity, required this.opacity1});
  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: Duration(milliseconds: 600),
      opacity: opacity,
      //controller.showText1.value ? 1.0 : 0.0,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 600),
        transform: Matrix4.translationValues(
          0,
          // controller.showText1.value ? 0 : 30,
          opacity1,
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
    );
  }
}
