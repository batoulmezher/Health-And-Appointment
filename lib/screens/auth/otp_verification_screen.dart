import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_appointment_app/constant/colors.dart' as appColor;
import 'package:health_appointment_app/controller/auth_controllers/otp_verification_controller.dart';
import 'package:health_appointment_app/widgets/auth/auth_button.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpVerificationScreen extends StatelessWidget {
  const OtpVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OtpVerificationController());
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDarkMode ? Colors.white : appColor.appColor.primary;
    final secondaryTextColor = isDarkMode ? Colors.white70 : appColor.appColor.primary.withOpacity(0.8);
    final backgroundColor = isDarkMode ? Colors.grey.shade900 : appColor.appColor.grownd;
    final cardColor = isDarkMode ? Colors.black : Colors.white;
    final fillColor = isDarkMode ? Colors.grey.shade800 : appColor.appColor.grownd;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
      title: Text(
            "Health & Appointment",
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: primaryTextColor,
              letterSpacing: 1.2,
            ),
          ),
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryTextColor),
          onPressed: () => Get.back(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(40),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "تحقق من الهوية",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: primaryTextColor,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "أدخل الرمز المكون من 6 أرقام المرسل إلى هاتفك\nالمحمول لضمان خصوصية بياناتك الطبية.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: secondaryTextColor,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: PinCodeTextField(
                    appContext: context,
                    length: 6,
                    controller: controller.otpController,
                    focusNode: controller.otpFocusNode,
                    keyboardType: TextInputType.number,
                    textStyle: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: primaryTextColor,
                    ),
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(16),
                      fieldHeight: 70,
                      fieldWidth: 55,
                      activeFillColor: fillColor,
                      inactiveFillColor: fillColor,
                      selectedFillColor: fillColor,
                      activeColor: appColor.appColor.primary,
                      inactiveColor: isDarkMode ? Colors.white24 : appColor.appColor.primary.withOpacity(0.3),
                      selectedColor: appColor.appColor.primary,
                    ),
                    backgroundColor: Colors.transparent,
                    enableActiveFill: true,
                    onCompleted: (value) {
                      controller.verifyOtp();
                    },
                    onChanged: (value) {},
                    beforeTextPaste: (text) => true,
                  ),
                ),
                const SizedBox(height: 20),
                Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _formatTime(controller.remainingSeconds.value),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: primaryTextColor,
                        ),
                      ),
                      const SizedBox(width: 24),
                      GestureDetector(
                        onTap: controller.remainingSeconds.value == 0
                            ? controller.resendCode
                            : null,
                        child: Text(
                          "إعادة إرسال الرمز",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: controller.remainingSeconds.value == 0
                                ? appColor.appColor.primary
                                : Colors.grey,
                            decoration: controller.remainingSeconds.value == 0
                                ? TextDecoration.underline
                                : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                AuthButton(onPressed: controller.verifyOtp, text: "تأكيد"),
                
              ],
            ),
          ),
          const SizedBox(height: 30),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "سياسة الخصوصية",
                      style: TextStyle(fontSize: 13, color: secondaryTextColor),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text("|", style: TextStyle(color: secondaryTextColor)),
                  const SizedBox(width: 12),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "شروط الخدمة",
                      style: TextStyle(fontSize: 13, color: secondaryTextColor),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text("|", style: TextStyle(color: secondaryTextColor)),
                  const SizedBox(width: 12),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "الدعم الفني",
                      style: TextStyle(fontSize: 13, color: secondaryTextColor),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                "Elite Clinical Excellence 2024 ©",
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

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}