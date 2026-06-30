import 'package:flutter/material.dart';
import 'package:health_appointment_app/constant/colors.dart';

class AuthTextField extends StatelessWidget {
  AuthTextField({
    super.key,
    required this.controller,
    required this.hintText,
     this.icon,
    required this.obscureText,
    this.suffixIcon,
     this.text,
    this.keyboardType,
    this.onChanged
  });
  String hintText;
  String? text;

  TextEditingController controller;
  IconData? icon;
  bool obscureText;
  Widget? suffixIcon;
  TextInputType? keyboardType = TextInputType.text;
Function(String)? onChanged;
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final fillColor = isDarkMode ? Colors.grey[800] : appColor.grownd;
    final primaryTextColor = isDarkMode ? Colors.white : appColor.primary;
    final hintColor = isDarkMode
        ? Colors.white60
        : appColor.primary.withOpacity(0.6);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          text!,
          textAlign: TextAlign.right,
          style: TextStyle(
            color: primaryTextColor,
            fontWeight: FontWeight.w600,
          ),
        ),

        TextFormField(
          controller: controller,
          obscureText: obscureText,
          style: TextStyle(color: primaryTextColor),
     keyboardType: keyboardType,
onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: hintColor),
            prefixIcon: Icon(icon, color: appColor.primary),
            filled: true,
            suffixIcon: suffixIcon,
            fillColor: fillColor,

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ],
    );
  }
}
