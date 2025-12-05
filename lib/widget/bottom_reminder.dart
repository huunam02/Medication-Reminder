import '/lang/l.dart';
import '/screen/interval_reminder/interval_reminder_screen.dart';
import '/screen/standard_reminder/standard_reminder_screen.dart';
import '/screen/water/controller/warter_controller.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '/config/global_color.dart';
import '/config/global_text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomSheetReminder extends StatelessWidget {
  const BottomSheetReminder({super.key, required Null Function() onTap});

  @override
  Widget build(BuildContext context) {
    final waterCtr = Get.find<WarterController>();
    double h = MediaQuery.of(context).size.height;
    return Container(
      height: h * 0.4,
      padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
      decoration: BoxDecoration(
          color: GlobalColors.container1,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                L.reminderMode.tr,
                style: GlobalTextStyles.font16w600ColorWhite,
              ),
              Text(
                L.reminderModeDes.tr,
                style: GlobalTextStyles.font12w400ColorNewtral,
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              Get.back();
              Get.to(StandardReminderScreen());
            },
            child: Obx(
              () => Container(
                height: 80.0,
                width: double.infinity,
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    color: waterCtr.reminderMode.value == "standard"
                        ? null
                        : GlobalColors.container2,
                    gradient: waterCtr.reminderMode.value == "standard"
                        ? GlobalColors.linearPrimary
                        : null),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            L.standard.tr,
                            style: GlobalTextStyles.font16w600ColorWhite,
                          ),
                          Text(
                            L.standardDes.tr,
                            style: waterCtr.reminderMode.value == "standard"
                                ? GlobalTextStyles.font12w400ColorWhite
                                : GlobalTextStyles.font12w400ColorNewtral,
                          ),
                        ],
                      ),
                    ),
                    SvgPicture.asset("assets/icons/next.svg")
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Get.back();
              Get.to(IntervalReminderScreen());
            },
            child: Obx(
              () => Container(
                height: 80.0,
                width: double.infinity,
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    color: waterCtr.reminderMode.value == "interval"
                        ? null
                        : GlobalColors.container2,
                    gradient: waterCtr.reminderMode.value == "interval"
                        ? GlobalColors.linearPrimary
                        : null),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            L.interval.tr,
                            style: GlobalTextStyles.font16w600ColorWhite,
                          ),
                          Text(
                            L.intervalDes.tr,
                            style: waterCtr.reminderMode.value == "interval"
                                ? GlobalTextStyles.font12w400ColorWhite
                                : GlobalTextStyles.font12w400ColorNewtral,
                          ),
                        ],
                      ),
                    ),
                    SvgPicture.asset("assets/icons/next.svg")
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
