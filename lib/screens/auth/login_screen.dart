import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_appointment_app/Routes/pages.dart';
import 'package:health_appointment_app/constant/colors.dart' as appColor;
import 'package:health_appointment_app/controller/auth_controllers/login_controller.dart';
import 'package:health_appointment_app/widgets/auth/auth_button.dart';
import 'package:health_appointment_app/widgets/auth/text_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDarkMode
        ? Colors.amber
        : appColor.appColor.primary;
    final secondaryTextColor = isDarkMode
        ? Colors.white
        : appColor.appColor.primary.withOpacity(0.8);
    final hintColor = isDarkMode
        ? Colors.white60
        : appColor.appColor.primary.withOpacity(0.6);
    final backgroundColor = isDarkMode
        ? Color.fromARGB(255, 8, 34, 80)
        : appColor.appColor.grownd;
    final cardColor = isDarkMode ? appColor.appColor.primary : Colors.white;
    final fillColor = isDarkMode ? Colors.grey[200] : appColor.appColor.grownd;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          children: [
            const SizedBox(height: 40),
            Text(
              "Health & Appointment",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: primaryTextColor,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 30),
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
                  Text(
                    '1'.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: primaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '2'.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: secondaryTextColor),
                  ),
                  const SizedBox(height: 40),

                  const SizedBox(height: 6),
                  AuthTextField(
                    controller: controller.emailController,
                    hintText: "example@elite.com",
                    icon: Icons.email_outlined,
                    obscureText: false,
                    text: '3'.tr,
                    keyboardType: TextInputType.emailAddress,
                  ),

                  const SizedBox(height: 20),

                  Obx(
                    () => AuthTextField(
                      controller: controller.passwordController,
                      hintText: "••••••••",
                      icon: Icons.lock_outline,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: controller.obscurePassword.value,
                      text: '4'.tr,
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.obscurePassword.value
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: appColor.appColor.primary,
                        ),

                        onPressed: () => controller.obscurePassword.toggle(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          controller.goToForgetPassword();
                        },
                        child: Text(
                          '5'.tr,
                          style: TextStyle(
                            color: secondaryTextColor,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: Row(
                          children: [
                          Obx(
                            () => Checkbox(
                              value: controller.rememberMe.value,
                              onChanged: (_) => controller.toggleRememberMe(),
                              activeColor: appColor.appColor.primary,
                              shape: const CircleBorder(),
                            ),
                          ),
                          Text(
                            "تذكرني",
                            style: TextStyle(color: primaryTextColor),
                          ),
                        ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  AuthButton(onPressed: controller.login, text: '1'.tr),

                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('7'.tr, style: TextStyle(color: secondaryTextColor)),
                      TextButton(
                        onPressed: controller.goToRegister,
                        child: Text(
                          '8'.tr,
                          style: TextStyle(
                            color: primaryTextColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Column(
              children: [
                Text(
                  'under'.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: secondaryTextColor),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(" | ", style: TextStyle(color: secondaryTextColor)),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'terms'.tr,
                        style: TextStyle(
                          fontSize: 12,
                          color: secondaryTextColor,
                        ),
                      ),
                    ),
                    Text(" | ", style: TextStyle(color: secondaryTextColor)),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "technical".tr,
                        style: TextStyle(
                          fontSize: 12,
                          color: secondaryTextColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
