import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '/config/global_color.dart';
import '/config/global_text_style.dart';
import '/model/reminder.dart';
import '/screen/reminder/controller/reminder_controller.dart';
import '/widget/appbar_base.dart';
import '/widget/body_background.dart';

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
            child: SvgPicture.asset("assets/icons/back.svg",
                color: Colors.black, width: 24.0, height: 24.0),
          ),
        ),
        title: Text(
          "Uống thuốc", // Localize this later
          style: GlobalTextStyles.font18w600ColorBlack,
        ),
        centerTitle: true,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon or Image
            Container(
              padding: EdgeInsets.all(30.w),
              decoration: BoxDecoration(
                color: GlobalColors.bg1,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.medication,
                size: 80.w,
                color: GlobalColors.linearPrimary.colors.first,
              ),
            ),
            40.verticalSpace,
            
            // Medicine Name
            Text(
              reminder.title ?? "Medicine",
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
                "Số lượng: ${reminder.quantity} viên", // Localize
                style: GlobalTextStyles.font16w600ColorBlack.copyWith(
                  color: GlobalColors.newtral,
                  fontWeight: FontWeight.w400
                ),
              ),
            
            60.verticalSpace,

            // Mark as Taken Button
            GestureDetector(
              onTap: () async {
                await reminderCtl.markAsTaken(reminder);
                Get.back();
                Get.snackbar(
                  "Thành công", 
                  "Đã uống",
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
                      color: GlobalColors.linearPrimary.colors.first.withOpacity(0.3),
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
                      "Xác nhận đã uống", // Localize
                      style: GlobalTextStyles.font16w600ColorWhite,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
