import '/config/global_color.dart';
import '/config/global_text_style.dart';
import 'package:flutter/material.dart';

class PercentIndicatorCustom extends StatelessWidget {
  const PercentIndicatorCustom(
      {super.key, required this.isSelected, required this.val});
  final bool isSelected;
  final String val;

  @override
  Widget build(BuildContext context) {
    return isSelected
        ? Container(
            width: 46.55,
            height: 18.0,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/water_indicator.png"))),
            child: Text(
              "$val%",
              style: GlobalTextStyles.font12w600ColorWhite.copyWith(
                color: GlobalColors.colorLastLinear,
              ),
            ),
          )
        : Text(
            "- $val% -",
            style: GlobalTextStyles.font10w400ColorNewtral,
          );
  }
}
