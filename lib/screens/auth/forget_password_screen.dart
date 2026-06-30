import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_appointment_app/constant/colors.dart' as appColor;
import 'package:health_appointment_app/controller/auth_controllers/forget_password_controller.dart';
import 'package:health_appointment_app/widgets/auth/auth_button.dart';
import 'package:health_appointment_app/widgets/auth/text_field.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgetPasswordController());
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final primaryTextColor = isDarkMode
        ? Colors.white
        : appColor.appColor.primary;
    final secondaryTextColor = isDarkMode
        ? Colors.white70
        : appColor.appColor.primary.withOpacity(0.8);
    final hintColor = isDarkMode
        ? Colors.white60
        : appColor.appColor.primary.withOpacity(0.6);
    final backgroundColor = isDarkMode
        ? Colors.grey.shade900
        : appColor.appColor.grownd;
    final cardColor = isDarkMode ? Colors.black : Colors.white;
    final fillColor = isDarkMode
        ? Colors.grey.shade800
        : appColor.appColor.grownd;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: Text(
          "Health & Appointment",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: primaryTextColor,
            letterSpacing: 1.2,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryTextColor),
          onPressed: () => Get.back(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 105),
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(400),
              color: appColor.appColor.primary,
            ),
            child: Icon(
              Icons.lock_outline,
              size: 55,
              color: appColor.appColor.grownd,
            ),
          ),
          const SizedBox(height: 30),
          Text(
            "نسيت كلمة المرور؟",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: primaryTextColor,
            ),
          ),
          const SizedBox(height: 12),
          // النص التوضيحي
          Text(
            "أدخل بريدك الإلكتروني أو رقم هاتفك وسنرسل لك رمزًا لاستعادة الوصول إلى حسابك بشكل آمن.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: secondaryTextColor,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 40),
          // البطاقة الرئيسية
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(40),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
               
                AuthTextField(
                  controller: controller.emailOrPhoneController,
                  hintText: "example@clinical.com",
                  obscureText: false,
                  text: "البريد الإلكتروني   ",
                  icon: Icons.email_outlined,
                ),
               
                const SizedBox(height: 30),
                // زر "إرسال الرمز"
                AuthButton(onPressed:  controller.sendResetCode, text: "إرسال الرمز"),
             
                const SizedBox(height: 24),
                // معلومات الدعم
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.access_time,
                      color: appColor.appColor.amber,
                      size: 20,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "24/7 متاحة",
                      style: TextStyle(color: secondaryTextColor, fontSize: 13),
                    ),
                    const SizedBox(width: 20),
                    Icon(
                      Icons.security,
                      color: appColor.appColor.amber,
                      size: 20,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "تغير كامل",
                      style: TextStyle(color: secondaryTextColor, fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          // التذييل (الروابط وحقوق النشر)
          Column(
            children: [
              const SizedBox(height: 50),
              Text(
                "App & Appointment. All rights reserved 2024 ©",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: secondaryTextColor),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ],
      ),
    );
  }
}
