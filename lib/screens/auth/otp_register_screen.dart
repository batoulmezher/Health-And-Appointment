import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_appointment_app/constant/colors.dart' as appColor;
import 'package:health_appointment_app/controller/auth_controllers/otp_regiter_controller.dart';
import 'package:health_appointment_app/widgets/auth/auth_button.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpRegisterScreen extends StatelessWidget {
  const OtpRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OtpRegiterController());
    final isDarkMode = Get.isDarkMode;

    final screenWidth = Get.width;
    final screenHeight = Get.height;

    final isSmallScreen = screenWidth < 380;
    final isMediumScreen = screenWidth >= 380 && screenWidth < 600;
    final isLargeScreen = screenWidth >= 600;

    final double fieldSize = isSmallScreen ? 48 : (isMediumScreen ? 55 : 62);
    final double fontSize = isSmallScreen ? 22 : (isMediumScreen ? 26 : 28);
    final double containerPadding = isSmallScreen ? 16 : (isMediumScreen ? 20 : 24);
    final double titleSize = isSmallScreen ? 22 : (isMediumScreen ? 24 : 26);
    final double verticalSpacing = isSmallScreen ? 16 : (isMediumScreen ? 20 : 24);
    final double horizontalPadding = isSmallScreen ? 16 : (isMediumScreen ? 20 : 24);

    final primaryTextColor = isDarkMode ? Colors.white : appColor.appColor.primary;
    final secondaryTextColor = isDarkMode
        ? Colors.white70
        : appColor.appColor.primary.withOpacity(0.8);
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
        title: Text(
          "Health & Appointment",
          textAlign: TextAlign.end,
          style: TextStyle(
            fontSize: isSmallScreen ? 22 : 28,
            fontWeight: FontWeight.bold,
            color: primaryTextColor,
            letterSpacing: 1.2,
          ),
        ),
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: primaryTextColor),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: 16,
          ),
          child: Column(
            children: [
              SizedBox(height: verticalSpacing),

              Container(
                padding: EdgeInsets.all(containerPadding),
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
                      "تحقق من الهوية",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: titleSize,
                        fontWeight: FontWeight.bold,
                        color: primaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 12),

                    Text(
                      "أدخل الرمز المكون من 6 أرقام المرسل إلى هاتفك\nالمحمول لضمان خصوصية بياناتك الطبية.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isSmallScreen ? 12 : 14,
                        color: secondaryTextColor,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 24 : 32),

                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isSmallScreen ? 4 : 8,
                      ),
                      child: Directionality(
                        textDirection: TextDirection.ltr,
                        child: PinCodeTextField(
                          appContext: context,
                          length: 6,
                          controller: controller.otpController,
                          focusNode: controller.otpFocusNode,
                          keyboardType: TextInputType.number,
                          textStyle: TextStyle(
                            fontSize: fontSize,
                            fontWeight: FontWeight.bold,
                            color: primaryTextColor,
                          ),
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            borderRadius: BorderRadius.circular(14),
                            fieldHeight: fieldSize * 1.2,
                            fieldWidth: fieldSize,
                            activeFillColor: fillColor,
                            inactiveFillColor: fillColor,
                            selectedFillColor: fillColor,
                            activeColor: appColor.appColor.primary,
                            inactiveColor: isDarkMode
                                ? Colors.white24
                                : appColor.appColor.primary.withOpacity(0.3),
                            selectedColor: appColor.appColor.primary,
                          ),
                          backgroundColor: Colors.transparent,
                          enableActiveFill: true,
                          onCompleted: (value) {
                            controller.verifyOtp();
                          },
                          onChanged: (_) {},
                          beforeTextPaste: (_) => true,
                        ),
                      ),
                    ),

                    SizedBox(height: isSmallScreen ? 20 : 24),

                    Obx(
                      () => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _formatTime(controller.remainingSeconds.value),
                            style: TextStyle(
                              fontSize: isSmallScreen ? 18 : 22,
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
                                fontSize: isSmallScreen ? 14 : 16,
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

                    SizedBox(height: isSmallScreen ? 24 : 32),

                    AuthButton(
                      onPressed: () {
                        controller.verifyOtp();
                      },
                      text: "تأكيد",
                    ),
                  ],
                ),
              ),

              SizedBox(height: verticalSpacing + 8),

              Column(
                children: [
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          "سياسة الخصوصية",
                          style: TextStyle(
                            fontSize: isSmallScreen ? 11 : 13,
                            color: secondaryTextColor,
                          ),
                        ),
                      ),
                      Text(
                        "|",
                        style: TextStyle(color: secondaryTextColor),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          "شروط الخدمة",
                          style: TextStyle(
                            fontSize: isSmallScreen ? 11 : 13,
                            color: secondaryTextColor,
                          ),
                        ),
                      ),
                      Text(
                        "|",
                        style: TextStyle(color: secondaryTextColor),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          "الدعم الفني",
                          style: TextStyle(
                            fontSize: isSmallScreen ? 11 : 13,
                            color: secondaryTextColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Elite Clinical Excellence 2024 ©",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 10 : 12,
                      color: secondaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}