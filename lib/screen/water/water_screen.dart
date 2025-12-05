import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:lottie/lottie.dart';

import '/config/global_color.dart';
import '/config/global_text_style.dart';
import '/lang/l.dart';
import '/screen/create_drink/create_drink_screen.dart';
import '/screen/interval_reminder/controller/interval_reminder_controller.dart';
import '/screen/setting/controller/setting_controller.dart';
import '/screen/standard_reminder/controller/standard_reminder_controller.dart';
import '/screen/water/controller/warter_controller.dart';
import '/screen/water/widget/cup.dart';
import '/screen/water/widget/water_history_item.dart';
import '/widget/appbar_base.dart';
import '/widget/body_background.dart';
import '/widget/fomart_time.dart';
import '/widget/gradient_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class WaterScreen extends StatefulWidget {
  const WaterScreen({super.key});

  @override
  State<WaterScreen> createState() => _WaterScreenState();
}

class _WaterScreenState extends State<WaterScreen> {
  final waterCtr = Get.find<WarterController>();
  final standardReminder = Get.find<StandardReminderController>();
  final intervalReminder = Get.find<IntervalReminderController>();
  final settingCtl = Get.find<SettingController>();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    waterCtr.initData();
    await standardReminder.loadData();
    standardReminder.checkOnReminder();
    intervalReminder.loadIntervalReminder();
    waterCtr.checkNextReminder();
    waterCtr.setIsHideHello();
  }

  @override
  Widget build(BuildContext context) {
    return BodyCustom(
      edgeInsetsPadding: EdgeInsets.symmetric(horizontal: 16.0),
      isShowBgImages: false,
      appbar: AppbarBase(
        title: GradientText(
          L.water.tr,
          gradient: GlobalColors.linearPrimary2,
          style: GlobalTextStyles.font20w600ColorWhite,
        ),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            Obx(
              () => waterCtr.isShowHello.value
                  ? _buildHello()
                  : SizedBox.shrink(),
            ),
            SizedBox.expand(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(
                    () {
                      if (waterCtr.drankWater.value >=
                              waterCtr.dailyGoal.value &&
                          waterCtr.isShowHello.value == false) {
                        return _buildCompleteGoalText();
                      }
                      return SizedBox.shrink();
                    },
                  ),
                  Spacer(),
                  CupRiverAnimation(),
                  SizedBox(
                    height: 43.h,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Obx(
                          () => Text(
                            convertUnitData(waterCtr.drankWater.value),
                            style: GlobalTextStyles.font32w600ColorBlack,
                          ),
                        ),
                        Obx(
                          () => Text(
                            settingCtl.unit.value,
                            style: GlobalTextStyles.font16w600ColorBlack,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${L.nextReminder.tr}: ",
                        style: GlobalTextStyles.font18w600ColorBlack,
                      ),
                      Obx(
                        () => CustomNextTime(
                            time: waterCtr.nextReminder.value,
                            mode: waterCtr.reminderMode.value),
                      ),
                    ],
                  ),
                  Spacer(),
                  Obx(() => waterCtr.listHistory.isEmpty
                      ? GestureDetector(
                          onTap: () {
                            Get.to(CreateDrinkScreen());
                          },
                          child: Container(
                            height: 56.h,
                            width: 192.w,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                gradient: GlobalColors.linearPrimary2,
                                borderRadius: BorderRadius.circular(28.0)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  "assets/icons/add.svg",
                                  height: 24.0,
                                  width: 24.0,
                                ),
                                SizedBox(
                                  width: 12.0,
                                ),
                                Text(
                                  L.drink.tr,
                                  style: GlobalTextStyles.font16w600ColorWhite,
                                ),
                              ],
                            ),
                          ),
                        )
                      : SizedBox(
                          height: 100.h,
                          width: double.infinity,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              GestureDetector(
                                onTap: () => Get.to(CreateDrinkScreen()),
                                child: Container(
                                  height: 100.h,
                                  width: 100.h,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      gradient: GlobalColors.linearPrimary2),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        "assets/icons/add2.svg",
                                        height: 24.w,
                                        width: 24.w,
                                      ),
                                      SizedBox(
                                        height: 8.0,
                                      ),
                                      Text(
                                        "+ ${L.drink.tr}",
                                        style: GlobalTextStyles
                                            .font12w600ColorWhite,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Row(
                                children: List.generate(
                                    waterCtr.listHistory.length, (index) {
                                  final history = waterCtr.listHistory[index];
                                  return WaterHistoryItem(
                                    history: history,
                                  );
                                }),
                              ),
                            ],
                          ),
                        )),
                  30.verticalSpace
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row _buildCompleteGoalText() {
    return Row(
      children: [
        Expanded(
            child: AnimatedTextKit(
          animatedTexts: [
            TyperAnimatedText(
              L.youHaveAchievedYourGoalToday.tr,
              textStyle: GlobalTextStyles.font20w700ColorPrimary,
              textAlign: TextAlign.center,
              speed: const Duration(milliseconds: 100),
              curve: Curves.easeOut,
            ),
          ],
          isRepeatingAnimation: true,
          totalRepeatCount: 2,
        )),
        Lottie.asset(
          "assets/lotties/goal_achieved.json",
          width: 80.w,
          height: 80.w,
        ),
      ],
    );
  }

  Positioned _buildHello() {
    return Positioned(
      top: 0.h,
      left: 0.w,
      child: Row(
        children: [
          Lottie.asset("assets/lotties/hello.json",
              width: 80.w, height: 80.w, fit: BoxFit.cover),
          10.horizontalSpace,
          AnimatedTextKit(
            animatedTexts: [
              TyperAnimatedText(L.welcomeBack.tr,
                  textStyle: GlobalTextStyles.font20w700ColorPrimary,
                  speed: const Duration(milliseconds: 100),
                  curve: Curves.easeOut,
                  textAlign: TextAlign.center),
            ],
            isRepeatingAnimation: true,
            totalRepeatCount: 2,
          )
        ],
      ),
    );
  }

  String convertUnitData(int ml) {
    if (settingCtl.unit.value == "ml") {
      return ml.toString();
    } else if (settingCtl.unit.value == "L") {
      return (ml.toDouble() / 1000).toStringAsFixed(1);
    } else {
      return (ml.toDouble() / 29.00).toStringAsFixed(1);
    }
  }
}
