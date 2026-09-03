import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:health_appointment_app/constant/colors.dart';

class BuildYesNoQuestion extends StatelessWidget {
   BuildYesNoQuestion({super.key,required this.question,required this.value,required this.onChanged,required this.primaryTextColor});
  String question;
  RxBool value;
  Function(bool) onChanged;
  Color primaryTextColor;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: TextStyle(
            color: primaryTextColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Obx(
              () => Row(
                children: [
                  Radio<bool>(
                    value: true,
                    groupValue: value.value,
                    onChanged: (val) => onChanged(val!),
                    activeColor: appColor.primary,
                  ),
                  Text("نعم", style: TextStyle(color: primaryTextColor)),
                ],
              ),
            ),
            const SizedBox(width: 20),
            Obx(
              () => Row(
                children: [
                  Radio<bool>(
                    value: false,
                    groupValue: value.value,
                    onChanged: (val) => onChanged(val!),
                    activeColor: appColor.primary,
                  ),
                  Text("لا", style: TextStyle(color: primaryTextColor)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
