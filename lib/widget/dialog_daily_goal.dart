import '/config/global_color.dart';
import '/config/global_text_style.dart';
import '/lang/l.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class DialogDailyGoal extends StatefulWidget {
  const DialogDailyGoal(
      {super.key,
      required this.ontap,
      required this.controller,
      required this.unit});
  final GestureTapCallback ontap;
  final TextEditingController controller;
  final String unit;
  @override
  State<DialogDailyGoal> createState() => _DialogDailyGoalState();
}

class _DialogDailyGoalState extends State<DialogDailyGoal> {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 328 / 220,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
        decoration: BoxDecoration(
            color: GlobalColors.container1,
            borderRadius: BorderRadius.circular(16)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              L.dailyGoal.tr,
              textAlign: TextAlign.center,
              style: GlobalTextStyles.font16w600ColorBlack,
            ),
            Container(
              height: 60.h,
              width: double.infinity, // Hoặc đặt giá trị cố định
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(24.0),
              ),
              child: Stack(
                children: [
                  TextField(
                    keyboardType: TextInputType.number,
                    textAlignVertical: TextAlignVertical.center,
                    controller: widget.controller,
                    style: GlobalTextStyles.font14w600ColorBlack,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 16.h),
                      hintText: L.dailyGoalHint.tr,
                      hintStyle: GlobalTextStyles.font14w600ColorBlack
                          .copyWith(color: Color(0xFF4B5563)),
                      border: InputBorder.none,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Text(
                        widget.unit,
                        style: GlobalTextStyles.font14w600ColorBlack
                            .copyWith(color: GlobalColors.newtral),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                    child: GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    height: 40.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(19),
                        color: GlobalColors.container2),
                    child: Center(
                      child: Text(
                        L.cancel.tr,
                        style: GlobalTextStyles.font14w400ColorWhite,
                      ),
                    ),
                  ),
                )),
                SizedBox(
                  width: 16.0,
                ),
                Expanded(
                    child: GestureDetector(
                  onTap: () => widget.ontap(),
                  child: Container(
                    height: 40.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(19),
                        gradient: GlobalColors.linearPrimary2),
                    child: Center(
                      child: Text(
                        L.save.tr,
                        style: GlobalTextStyles.font14w600ColorWhite,
                      ),
                    ),
                  ),
                ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
