import 'package:flutter/material.dart';

class SplashSubtitle2 extends StatelessWidget {
  double opacity;
double opacity1;
   SplashSubtitle2({super.key,required this.opacity,required this.opacity1});

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
                    duration: Duration(milliseconds: 600),
                    opacity:opacity,
                    // controller.showText3.value ? 1.0 : 0.0,
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 600),
                      transform: Matrix4.translationValues(
                        0,
                        opacity1,
                        //controller.showText3.value ? 0 : 30,
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
                  );
  }
}