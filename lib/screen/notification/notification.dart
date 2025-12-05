import '/config/global_color.dart';
import '/config/global_sadow.dart';
import '/config/global_text_style.dart';
import '/lang/l.dart';
import '/screen/interval_reminder/interval_reminder_screen.dart';
import '/screen/standard_reminder/standard_reminder_screen.dart';
import '/screen/water/controller/warter_controller.dart';
import '/widget/appbar_base.dart';
import '/widget/body_background.dart';
import '/widget/gradient_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final waterCtr = Get.find<WarterController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BodyCustom(
        appbar: AppbarBase(
          title: GradientText(
            L.reminderMode.tr,
            gradient: GlobalColors.linearPrimary2,
            style: GlobalTextStyles.font20w600ColorWhite,
          ),
          actions: [],
        ),
        edgeInsetsPadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        isShowBgImages: false,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildButtonStandard(waterCtr),
              20.verticalSpace,
              _buildButtonInterval(waterCtr)
            ],
          ),
        ),
      ),
    );
  }

  GestureDetector _buildButtonInterval(WarterController waterCtr) {
    return GestureDetector(
      onTap: () {
        Get.to(IntervalReminderScreen());
      },
      child: Obx(
        () => Container(
          height: 120.h,
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 16.0),
          decoration: BoxDecoration(
              boxShadow: GlobalShadow.primary,
              borderRadius: BorderRadius.circular(16.0),
              color: waterCtr.reminderMode.value == "interval"
                  ? null
                  : Colors.white,
              gradient: waterCtr.reminderMode.value == "interval"
                  ? GlobalColors.linearPrimary2
                  : null),
          child: Row(
            children: [
              _buildIconInterval(waterCtr),
              10.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      L.interval.tr,
                      style: waterCtr.reminderMode.value == "interval"
                          ? GlobalTextStyles.font16w600ColorWhite
                          : GlobalTextStyles.font16w600ColorBlack,
                    ),
                    4.verticalSpace,
                    Text(
                      L.intervalDes.tr,
                      style: waterCtr.reminderMode.value == "interval"
                          ? GlobalTextStyles.font12w400ColorWhite
                          : GlobalTextStyles.font12w400ColorNewtral,
                    ),
                  ],
                ),
              ),
              SvgPicture.asset("assets/icons/ic_next2.svg",
                  color: waterCtr.reminderMode.value == "interval"
                      ? Colors.white
                      : null)
            ],
          ),
        ),
      ),
    );
  }

  Container _buildIconInterval(WarterController waterCtr) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: waterCtr.reminderMode.value == "interval"
            ? Colors.white.withOpacity(.4)
            : Color(0xFFE3F1FF),
        borderRadius: BorderRadius.circular(8.w),
      ),
      child: SvgPicture.asset("assets/icons/ic_time_interval.svg",
          width: 24.w,
          height: 24.w,
          color:
              waterCtr.reminderMode.value == "interval" ? Colors.white : null),
    );
  }

  GestureDetector _buildButtonStandard(WarterController waterCtr) {
    return GestureDetector(
      onTap: () {
        Get.to(StandardReminderScreen());
      },
      child: Obx(
        () => Container(
          height: 120.h,
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 16.0),
          decoration: BoxDecoration(
              boxShadow: GlobalShadow.primary,
              borderRadius: BorderRadius.circular(16.0),
              color: waterCtr.reminderMode.value == "standard"
                  ? null
                  : Colors.white,
              gradient: waterCtr.reminderMode.value == "standard"
                  ? GlobalColors.linearPrimary2
                  : null),
          child: Row(
            children: [
              _buildIconStandard(waterCtr),
              10.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      L.standard.tr,
                      style: waterCtr.reminderMode.value == "standard"
                          ? GlobalTextStyles.font16w600ColorWhite
                          : GlobalTextStyles.font16w600ColorBlack,
                    ),
                    4.verticalSpace,
                    Text(
                      L.standardDes.tr,
                      style: waterCtr.reminderMode.value == "standard"
                          ? GlobalTextStyles.font12w400ColorWhite
                          : GlobalTextStyles.font12w400ColorNewtral,
                    ),
                  ],
                ),
              ),
              SvgPicture.asset("assets/icons/ic_next2.svg",
                  color: waterCtr.reminderMode.value == "standard"
                      ? Colors.white
                      : null)
            ],
          ),
        ),
      ),
    );
  }

  Container _buildIconStandard(WarterController waterCtr) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: waterCtr.reminderMode.value == "standard"
            ? Colors.white.withOpacity(.2)
            : Color(0xFFE3F1FF),
        borderRadius: BorderRadius.circular(8.w),
      ),
      child: SvgPicture.asset(
        "assets/icons/ic_time_standard.svg",
        width: 24.w,
        height: 24.w,
        color: waterCtr.reminderMode.value == "standard" ? Colors.white : null,
      ),
    );
  }
}
