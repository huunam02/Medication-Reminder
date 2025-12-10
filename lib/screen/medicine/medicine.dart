import 'package:medication_reminder/screen/medicine/controller/medicine_controller.dart';
import '/config/global_color.dart';
import '/config/global_text_style.dart';
import '/lang/l.dart';
import '/screen/reminder/take_medicine_screen.dart';
import '/screen/reminder/controller/reminder_controller.dart';
import 'widget/medicine_animation.dart';
import '/widget/appbar_base.dart';
import '/widget/body_background.dart';
import '/widget/fomart_time.dart';
import '/widget/gradient_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MedicineScreen extends StatefulWidget {
  const MedicineScreen({super.key});
  @override
  State<MedicineScreen> createState() => _MedicineScreenState();
}

class _MedicineScreenState extends State<MedicineScreen> {
  final medicineCtr = Get.find<MedicineController>();
  final reminder = Get.find<ReminderController>();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    medicineCtr.initData();
    await reminder.loadData();
    reminder.checkOnReminder();
    medicineCtr.checkNextReminder();
  }

  @override
  Widget build(BuildContext context) {
    return BodyCustom(
      edgeInsetsPadding: EdgeInsets.symmetric(horizontal: 16.0),
      isShowBgImages: false,
      appbar: AppbarBase(
        title: GradientText(
          "Trang chủ",
          gradient: GlobalColors.linearPrimary2,
          style: GlobalTextStyles.font20w600ColorWhite,
        ),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            SizedBox.expand(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Spacer(),
                  MedicinceAnimation(),
                  SizedBox(
                    height: 43.h,
                  ),
                  Obx(
                    () {
                      bool isTime = false;
                      if (reminder.nextReminderObj.value != null &&
                          !reminder.takenReminderIds
                              .contains(reminder.nextReminderObj.value!.id)) {
                        DateTime now = DateTime.now();
                        DateTime time = DateTime.parse(
                            reminder.nextReminderObj.value!.dateTime);
                        DateTime reminderTime = DateTime(now.year, now.month,
                            now.day, time.hour, time.minute);
                        int diff = reminderTime.difference(now).inMinutes;
                        if (diff <= 0 && diff >= -15) {
                          isTime = true;
                        }
                      }
                      if (isTime) {
                        return Text(
                          L.notiTitle.tr,
                          style: GlobalTextStyles.font18w600ColorBlack
                              .copyWith(color: GlobalColors.colorLastLinear),
                        );
                      }
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${L.nextReminder.tr}: ",
                            style: GlobalTextStyles.font18w600ColorBlack,
                          ),
                          CustomNextTime(
                              time: medicineCtr.nextReminder.value,
                              mode: "standard"),
                        ],
                      );
                    },
                  ),
                  Obx(() {
                    if (reminder.nextReminderObj.value != null) {
                      return Padding(
                        padding: EdgeInsets.only(top: 16.h),
                        child: GestureDetector(
                          onTap: () async {
                            await Get.to(() => TakeMedicineScreen(
                                reminder: reminder.nextReminderObj.value!));
                            medicineCtr.checkNextReminder();
                            reminder.checkNextReminder();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 24.w, vertical: 12.h),
                            decoration: BoxDecoration(
                              gradient: GlobalColors.linearPrimary2,
                              borderRadius: BorderRadius.circular(24.r),
                              boxShadow: [
                                BoxShadow(
                                  color: GlobalColors.linearPrimary.colors.first
                                      .withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.medication, color: Colors.white),
                                8.horizontalSpace,
                                Text(
                                  "Take ${reminder.nextReminderObj.value!.title}",
                                  style: GlobalTextStyles.font16w600ColorWhite,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                    return SizedBox();
                  }),
                  Spacer(),
                  30.verticalSpace
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
