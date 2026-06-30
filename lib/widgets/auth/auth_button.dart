import 'package:flutter/material.dart';
import 'package:health_appointment_app/constant/colors.dart';

class AuthButton extends StatelessWidget {
  AuthButton({super.key, required this.onPressed, required this.text});
  String text;
  void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: appColor.primary,
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: Colors.amber, width: 2),
      ),
      child: MaterialButton(
        onPressed: onPressed,
        minWidth: 100,

        child: Text(
          text,
          style: TextStyle(fontSize: 18, color: appColor.grownd),
        ),
      ),
    );
  }
}
