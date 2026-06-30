import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_appointment_app/constant/colors.dart' as appColor;
import 'package:health_appointment_app/controller/auth_controllers/register_controller.dart';
import 'package:health_appointment_app/widgets/auth/auth_button.dart';
import 'package:health_appointment_app/widgets/auth/build_drop_down.dart';
import 'package:health_appointment_app/widgets/auth/build_image_picker.dart';
import 'package:health_appointment_app/widgets/auth/build_yes_no_question.dart';
import 'package:health_appointment_app/widgets/auth/text_field.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RegisterController());
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
    //final fillColor = isDarkMode ? Colors.grey[200] : appColor.appColor.grownd;

    final fillColor = isDarkMode ? Colors.grey : appColor.appColor.grownd;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryTextColor),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "إنشاء حساب",
          style: TextStyle(
            color: primaryTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
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
          const SizedBox(height: 8),
          Text(
            "انضم إلى نخبة مقدمي الرعاية الطبية المتميزة",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: secondaryTextColor),
          ),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(20),
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
                _buildSectionTitle("المعلومات الشخصية", primaryTextColor),
                const SizedBox(height: 8),
                _buildSubtitle(
                  "يرجى إدخال تفاصيلك بدقة لضمان عملية توثيق سريعة",
                  secondaryTextColor,
                ),
                const SizedBox(height: 20),
                BuildImagePicker(controller: controller,fillColor: fillColor,textColor: primaryTextColor,),
             //   _buildImagePicker(controller, primaryTextColor, fillColor),
                const SizedBox(height: 20),
                AuthTextField(
                  controller: controller.fullNameController,
                  hintText: "محمد العبدالله",
                  icon: Icons.person,
                  obscureText: false,
                  text: "الاسم الكامل",
                ),
                const SizedBox(height: 16),
                // رقم الهاتف
                AuthTextField(
                  controller: controller.phoneController,
                  hintText: "+963 935 000 000",
                  icon: Icons.phone,
                  keyboardType: TextInputType.number,
                  obscureText: false,
                  text: "رقم الهاتف",
                ),

                const SizedBox(height: 16),
                AuthTextField(
                  controller: controller.emailController,
                  hintText: "name@gmail.com",
                  icon: Icons.email,
                  obscureText: false,
                  text: "البريد الإلكتروني",
                  keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(height: 16),
                Obx(
                  () => AuthTextField(
                    controller: controller.passwordController,
                    hintText: "********",
                    icon: Icons.password,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: controller.obscurePassword.value,
                    text: "كلمة المرور",
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.obscurePassword.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: appColor.appColor.primary,
                      ),
                      onPressed: controller.togglePasswordVisibility,
                    ),
                  ),
               
                ),
                const SizedBox(height: 24),
                _buildSectionTitle("المؤشرات الجسدية", primaryTextColor),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child:
                      AuthTextField(controller: controller.heightController, hintText: "170",  obscureText: false, text: "الطول (سم)"),
                   
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child:
                      AuthTextField(controller: controller.weightController, hintText: "70", obscureText: false, text: "الوزن (كغم)"),
                     
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                AuthTextField(controller: controller.ageController, hintText: "30", obscureText: false, text: "العمر"),
               
                const SizedBox(height: 24),
                _buildSectionTitle("معلومات إضافية", primaryTextColor),
                const SizedBox(height: 16),
                BuildDropDown(value:controller.selectedGender , items: ["M", "F"], label: "الجنس", onChanged: controller.selectedGender, primaryTextColor: primaryTextColor, fillColor: fillColor),
              
                const SizedBox(height: 16),
                // فصيلة الدم
                BuildDropDown(value: controller.selectedBloodType, items: ["A+", "A-", "B+", "B-", "O+", "O-", "AB+", "AB-"], label: "فصيلة الدم", onChanged:  controller.setBloodType, primaryTextColor: primaryTextColor, fillColor: fillColor,),
               
                const SizedBox(height: 24),
                // قسم: الملف الطبي
                _buildSectionTitle("الملف الطبي", primaryTextColor),
                const SizedBox(height: 16),
                // هل تعاني من مرض مزمن؟
                BuildYesNoQuestion(question: "هل تعاني من مرض مزمن؟", value: controller.hasChronicDisease, onChanged: controller.setHasChronicDisease, primaryTextColor: primaryTextColor),
               
                const SizedBox(height: 12),
                // إذا نعم، ما هو؟
                Obx(
                  () => controller.hasChronicDisease.value
                      ? 
                      _buildTextField(
                          controller: controller.chronicDiseaseController,
                          label: "إذا كانت الإجابة نعم، ما هو؟",
                          hint: "السكري، الضغط...",
                          primaryTextColor: primaryTextColor,
                          hintColor: hintColor,
                          fillColor: fillColor,
                        )
                      : const SizedBox.shrink(),
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: controller.familyHistoryController,
                  label: "أذكر تفاصيل العائلة المرضية هنا...",
                  hint: "مثال: والدتي تعاني من السكري",
                  primaryTextColor: primaryTextColor,
                  hintColor: hintColor,
                  fillColor: fillColor,
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: controller.medicationsController,
                  label: "الأدوية الحالية",
                  hint: "أذكر أسماء الأدوية وجرعاتها...",
                  primaryTextColor: primaryTextColor,
                  hintColor: hintColor,
                  fillColor: fillColor,
                  maxLines: 2,
                ),
                const SizedBox(height: 30),
                AuthButton(onPressed: controller.register, text: "إنشاء الحساب "),
              
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

///////////////////////////////
Widget _buildSectionTitle(String title, Color color) {
  return Text(
    title,
    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
    textAlign: TextAlign.right,
  );
}

Widget _buildSubtitle(String text, Color color) {
  return Text(
    text,
    style: TextStyle(fontSize: 13, color: color),
    textAlign: TextAlign.right,
  );
}



Widget _buildTextField({
  required TextEditingController controller,
  required String label,
  required String hint,
  required Color primaryTextColor,
  required Color hintColor,
  required Color fillColor,
  bool obscureText = false,
  Widget? suffixIcon,
  TextInputType keyboardType = TextInputType.text,
  int maxLines = 1,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(
        label,
        textAlign: TextAlign.right,
        style: TextStyle(color: primaryTextColor, fontWeight: FontWeight.w600),
      ),
      const SizedBox(height: 6),
      TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: TextStyle(color: primaryTextColor),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: hintColor),
          filled: true,
          fillColor: fillColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 16,
          ),
          suffixIcon: suffixIcon,
        ),
      ),
    ],
  );
}

Widget _buildDropdown({
  required RxString value,
  required List<String> items,
  required String label,
  required Function(String) onChanged,
  required Color primaryTextColor,
  required Color fillColor,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(
        label,
        textAlign: TextAlign.right,
        style: TextStyle(color: primaryTextColor, fontWeight: FontWeight.w600),
      ),
      const SizedBox(height: 6),
      Obx(
        () => Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: fillColor,
            borderRadius: BorderRadius.circular(30),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value.value.isEmpty ? null : value.value,
              hint: Text("اختر $label", style: TextStyle(color: Colors.grey)),
              isExpanded: true,
              icon: Icon(
                Icons.arrow_drop_down,
                color: appColor.appColor.primary,
              ),
              items: items.map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: Text(item, style: TextStyle(color: primaryTextColor)),
                );
              }).toList(),
              onChanged: (val) => onChanged(val!),
            ),
          ),
        ),
      ),
    ],
  );
}

