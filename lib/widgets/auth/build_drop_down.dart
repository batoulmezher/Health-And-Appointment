import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:health_appointment_app/constant/colors.dart';

class BuildDropDown extends StatelessWidget {
   BuildDropDown({super.key,
   required this.value,
   required this.items,
   required this.label,
   required this.onChanged,
   required this.primaryTextColor,
   required this.fillColor});
  RxString value;
  List<String> items; 
  String label;
  Function(String) onChanged;
  Color primaryTextColor;
  Color fillColor;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          textAlign: TextAlign.right,
          style: TextStyle(
            color: primaryTextColor,
            fontWeight: FontWeight.w600,
          ),
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
                  color: appColor.primary,
                ),
                items: items.map((item) {
                  return DropdownMenuItem(
                    value: item,
                    child: Text(
                      item,
                      style: TextStyle(color: primaryTextColor),
                    ),
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
}
