import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:medication_reminder/widget/gradient_text.dart';
import '/config/global_color.dart';
import '/config/global_text_style.dart';
import '/model/reminder.dart';
import '/screen/reminder/controller/reminder_controller.dart';
import '/widget/appbar_base.dart';
import '/widget/body_background.dart';
import '/lang/l.dart';

class TakeMedicineScreen extends StatelessWidget {
  final Reminder reminder;

  const TakeMedicineScreen({super.key, required this.reminder});

  @override
  Widget build(BuildContext context) {
    final reminderCtl = Get.find<ReminderController>();
    DateTime dateTime = DateTime.parse(reminder.dateTime);

    return BodyCustom(
      isShowBgImages: false,
      appbar: AppbarBase(
        leading: Center(
          child: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: SvgPicture.asset(
              "assets/icons/back.svg",
              color: Colors.black,
              width: 24.0,
              height: 24.0,
            ),
          ),
        ),
        title: GradientText(
          L.takeMedicine.tr,
          gradient: GlobalColors.linearPrimary2,
          style: GlobalTextStyles.font20w600ColorWhite,
        ),
        centerTitle: true,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Icon or Image
              Lottie.asset(
                'assets/lotties/dadengiouongthuoc.json',
                fit: BoxFit.contain,
                width: 360.w,
                height: 360.w,
              ),
              40.verticalSpace,
              // Medicine Name
              Text(
                reminder.title ?? L.medicineFallback.tr,
                style: GlobalTextStyles.font20w700ColorBlack.copyWith(
                  fontSize: 28.sp,
                ),
                textAlign: TextAlign.center,
              ),
              16.verticalSpace,

              // Time
              Text(
                "${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}",
                style: GlobalTextStyles.font32w600ColorBlack.copyWith(
                  color: GlobalColors.linearPrimary.colors.first,
                  fontSize: 36.sp,
                ),
              ),
              16.verticalSpace,

              // Quantity
              if (reminder.quantity != null)
                Text(
                  "${L.quantity.tr}: ${reminder.quantity} ${reminder.quantity == 1 ? L.pillUnit.tr : L.pillUnits.tr}",
                  style: GlobalTextStyles.font16w600ColorBlack.copyWith(
                      color: GlobalColors.newtral, fontWeight: FontWeight.w400),
                ),

              60.verticalSpace,

              // Mark as Taken Button
              GestureDetector(
                onTap: () async {
                  await reminderCtl.markAsTaken(reminder);
                  Get.back();
                  Get.snackbar(
                    L.success.tr,
                    L.takenSuccessMessage.tr,
                    backgroundColor: Colors.green.withOpacity(0.8),
                    colorText: Colors.white,
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 56.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: GlobalColors.linearPrimary2,
                    borderRadius: BorderRadius.circular(28.r),
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check, color: Colors.white),
                      8.horizontalSpace,
                      Text(
                        L.confirmTaken.tr,
                        style: GlobalTextStyles.font16w600ColorWhite,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
