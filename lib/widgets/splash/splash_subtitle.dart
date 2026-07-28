import 'package:flutter/material.dart';

class SplashSubtitle extends StatelessWidget {
  double opacity;
  double opacity1;
  SplashSubtitle({super.key, required this.opacity, required this.opacity1});

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: Duration(milliseconds: 600),
      opacity: opacity,
      //controller.showText2.value ? 1.0 : 0.0,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 600),
        transform: Matrix4.translationValues(
          0,
          opacity1,
          // controller.showText2.value ? 0 : 30,
          0,
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 50.0),
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
    );
  }
}
