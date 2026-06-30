import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:health_appointment_app/constant/colors.dart';
import 'package:health_appointment_app/controller/auth_controllers/register_controller.dart';

class BuildImagePicker extends StatelessWidget {
   BuildImagePicker({super.key,this.controller,this.fillColor
   ,this.textColor});
  RegisterController? controller;
  Color? textColor;
  Color? fillColor;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "تحميل الصورة الشخصية",
          style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: controller?.pickImage,
          child: Center(
            child: Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                color: fillColor,
                borderRadius: BorderRadius.circular(100),
                border: Border.all(
                  color: appColor.primary,
                  width: 1.5,
                ),
              ),
              child: Obx(
                () => controller?.imageFile.value != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.file(
                          controller!.imageFile.value!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_photo_alternate,
                            size: 40,
                            color: appColor.primary,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "اضغط لاختيار صورة",
                            style: TextStyle(color: appColor.primary),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
