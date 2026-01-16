import 'package:flutter_screenutil/flutter_screenutil.dart';
import '/config/global_color.dart';
import '/config/global_sadow.dart';
import '/config/global_text_style.dart';
import '/lang/l.dart';
import '/model/history.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class CustomItemRecent extends StatelessWidget {
  const CustomItemRecent(
      {super.key, required this.history, required this.onTap});
  final History history;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 16.0),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: GlobalColors.container1,
            boxShadow: GlobalShadow.primary,
            borderRadius: BorderRadius.circular(16.0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  history.title ?? L.unknown.tr,
                  style: GlobalTextStyles.font16w600ColorBlack,
                ),
                SizedBox(height: 4.0),
                Text(
                  convertAmountWithUnit(history.amount ?? 0, history.unit),
                  style: GlobalTextStyles.font14w400ColorBlack,
                ),
                SizedBox(
                  height: 4.0,
                ),
                Text(
                  "${DateTime.parse(history.dateTime!).hour}:${DateTime.parse(history.dateTime!).minute > 9 ? DateTime.parse(history.dateTime!).minute : DateTime.parse(history.dateTime!).minute.toString().padLeft(2, "0")}",
                  style: GlobalTextStyles.font12w400ColorNewtral,
                )
              ],
            ),
            GestureDetector(
                child: Icon(Icons.delete_forever_outlined,
                    color: Colors.redAccent, size: 30.w)),
          ],
        ),
      ),
    );
  }

  String convertAmountWithUnit(int amount, String? unit) {
    if (unit == null || unit.isEmpty) {
      return amount.toString();
    }
    if (unit == L.pillUnit || unit == L.pillUnit.tr || unit == "pill") {
      final bool isSingular = amount == 1;
      final String localizedUnit = isSingular ? L.pillUnit.tr : L.pillUnits.tr;
      return "$amount $localizedUnit";
    }
    return "$amount ${unit.tr}";
  }
}
