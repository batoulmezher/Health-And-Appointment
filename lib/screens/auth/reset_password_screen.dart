import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_appointment_app/constant/colors.dart' as appColor;
import 'package:health_appointment_app/controller/auth_controllers/reset_password_controller.dart';
import 'package:health_appointment_app/widgets/auth/text_field.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ResetPasswordController());
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // الألوان حسب الوضع
    final primaryTextColor = isDarkMode
        ? Colors.white
        : appColor.appColor.primary;
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
    final hintColor = isDarkMode
        ? Colors.white60
        : appColor.appColor.primary.withOpacity(0.6);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
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
                  "إعادة تعيين كلمة المرور",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: primaryTextColor,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "يرجى إدخال كلمة المرور الجديدة الخاصة بك أدناه لضمان أمان حسابك في النخبة للتميز السريري.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: secondaryTextColor,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 30),
               
                const SizedBox(height: 6),
                Obx(
                  () => 
                  AuthTextField(controller: controller.newPasswordController,onChanged:(value) {
                      controller.passwordStrength.value = controller
                          .calculatePasswordStrength(value);
                    }
                   , hintText: "••••••••", obscureText: controller.obscureNewPassword.value, text: "كلمة المرور الجديدة",suffixIcon: IconButton(
                        icon: Icon(
                          controller.obscureNewPassword.value
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: appColor.appColor.primary,
                        ),
                        onPressed: controller.toggleNewPasswordVisibility,
                      ),icon:  Icons.lock_outline,),
                  
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.grey.shade300,
                        ),
                        child: Obx(
                          () => Row(
                            children: [
                              Container(
                                width:
                                    controller.passwordStrength.value == 'ضعيفة'
                                    ? 50
                                    : controller.passwordStrength.value ==
                                          'متوسطة'
                                    ? 150
                                    : controller.passwordStrength.value ==
                                          'قوية'
                                    ? 231
                                    : 0,
                                height: 4,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color:
                                      controller.passwordStrength.value ==
                                          'ضعيفة'
                                      ? Colors.red
                                      : controller.passwordStrength.value ==
                                            'متوسطة'
                                      ? Colors.orange
                                      : controller.passwordStrength.value ==
                                            'قوية'
                                      ? Colors.green
                                      : Colors.transparent,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Obx(
                      () => Text(
                        controller.passwordStrength.value,
                        style: TextStyle(
                          fontSize: 13,
                          color: controller.passwordStrength.value == 'ضعيفة'
                              ? Colors.red
                              : controller.passwordStrength.value == 'متوسطة'
                              ? Colors.orange
                              : controller.passwordStrength.value == 'قوية'
                              ? Colors.green
                              : secondaryTextColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
               
                const SizedBox(height: 6),
                Obx(
                  () => 
                  AuthTextField(controller: controller.confirmPasswordController, text: "تأكيد كلمة المرور",hintText:  "••••••••", obscureText: controller.obscureConfirmPassword.value,icon: Icons.lock_outline,suffixIcon: IconButton(
                        icon: Icon(
                          controller.obscureConfirmPassword.value
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: appColor.appColor.primary,
                        ),
                        onPressed: controller.toggleConfirmPasswordVisibility,
                      ),),
               
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: fillColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: appColor.appColor.primary.withOpacity(0.2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.shield_outlined,
                            color: appColor.appColor.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "حماية بياناتك هي أولويتنا",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: primaryTextColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "نحن نستخدم تشغيل أمتزاداً من طرف إلى طرف لضمان بقاء معلوماتك الشخصية وسجلك الطبي أمين تاماً. لن يتمت مشاركة كلمة المرور الخاصة بك مع أي شخص.",
                        style: TextStyle(
                          fontSize: 13,
                          color: secondaryTextColor,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Obx(
                  () => ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : controller.resetPassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: appColor.appColor.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      elevation: 3,
                    ),
                    child: controller.isLoading.value
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Text(
                            "حفظ كلمة المرور",
                            style: TextStyle(fontSize: 18),
                          ),
                  ),
                ),
                const SizedBox(height: 20),
              
                const SizedBox(height: 16),
                Text(
                  "Health & Appointment",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: primaryTextColor,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          // التذييل
          Column(
            children: [
              Text(
                "Health And Appointment © 2026 جميع الحقوق محفوظة.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: secondaryTextColor),
              ),
              const SizedBox(height: 8),
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
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ],
      ),
    );
  }
}
