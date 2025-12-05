import '/util/ads_helper.dart';
import 'package:lottie/lottie.dart';
import '/config/global_color.dart';
import '/config/global_sadow.dart';
import '/config/global_text_style.dart';
import '/lang/l.dart';
import '/screen/navbar/navbar.dart';
import '/screen/setting/controller/setting_controller.dart';
import '/screen/standard_reminder/controller/standard_reminder_controller.dart';
import '/screen/water/controller/warter_controller.dart';
import '/util/preferences_util.dart';
import '/widget/appbar_base.dart';
import '/widget/body_background.dart';
import '/widget/gradient_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class DailyGoalScreen extends StatefulWidget {
  const DailyGoalScreen({super.key});

  @override
  State<DailyGoalScreen> createState() => _DailyGoalScreenState();
}

class _DailyGoalScreenState extends State<DailyGoalScreen> {
  final settingCtl = Get.find<SettingController>();
  final textCtr = TextEditingController();
  String unitSelected = "ml";
  bool checkValid = false;

  @override
  Widget build(BuildContext context) {
    return BodyCustom(
      resizeToAvoidBottomInset: true,
      appbar: AppbarBase(
        title: GradientText(
          L.dailyGoal.tr,
          style: GlobalTextStyles.font20w600ColorWhite,
          gradient: GlobalColors.linearPrimary2,
        ),
      ),
      edgeInsetsPadding: EdgeInsets.symmetric(horizontal: 16.0),
      isShowBgImages: false,
      child: Column(
        children: [
          Spacer(),
          Lottie.asset(
            "assets/lotties/daily_goal.json",
            width: 300.w,
            height: 300.w,
          ),
          30.verticalSpace,
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            height: 60.h,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: GlobalShadow.primary,
                borderRadius: BorderRadius.circular(24.0)),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    onChanged: (value) {
                      try {
                        if (textCtr.text.isNotEmpty &&
                            double.tryParse(textCtr.text) != null &&
                            double.tryParse(textCtr.text)! > 0) {
                          setState(() {
                            checkValid = true;
                          });
                        } else {
                          setState(() {
                            checkValid = false;
                          });
                        }
                      } catch (e) {
                        setState(() {
                          checkValid = false;
                        });
                      }
                    },
                    controller: textCtr,
                    keyboardType: TextInputType.number,
                    style: GlobalTextStyles.font14w600ColorBlack,
                    decoration: InputDecoration(
                      hintStyle: GlobalTextStyles.font14w600ColorBlackOp60,
                      border: InputBorder.none,
                      hintText: L.dailyGoalHint.tr,
                    ),
                  ),
                ),
                Container(
                  color: Colors.grey.shade200,
                  height: 56,
                  width: 0.6,
                ),
                Expanded(
                    flex: 1,
                    child: PopupMenuButton<String>(
                      color: GlobalColors.container1,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(24), // Border radius 24
                      ),
                      onSelected: (value) {
                        print('Selected: $value'); // Xử lý khi chọn item
                        setState(() {
                          unitSelected = value;
                        });
                      },
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<String>>[
                        _buildPopupMenuItem('ml'),
                        _buildPopupMenuItem('L'),
                        _buildPopupMenuItem('fl oz'),
                      ],
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            unitSelected,
                            style: GlobalTextStyles.font16w600ColorBlack,
                          ),
                          SizedBox(
                            width: 12.0,
                          ),
                          SvgPicture.asset(
                            "assets/icons/unit_selec.svg",
                            color: GlobalColors.colorLastLinear,
                          )
                        ],
                      ),
                    ))
              ],
            ),
          ),
          SizedBox(
            height: 16.0,
          ),
          Text(
            textAlign: TextAlign.center,
            L.dailyGoalDes.tr,
            style: GlobalTextStyles.font14w400ColorBlack,
          ),
          SizedBox(
            height: 32.0,
          ),
          GestureDetector(
            onTap: () async {
              if (checkValid) {
                PreferencesUtil.putFirstTime(false);
                int result = 0;
                if (unitSelected == "L") {
                  result = (double.parse(textCtr.text) * 1000).toInt();
                } else if (unitSelected == 'fl oz') {
                  result = (double.parse(textCtr.text) * 29.00).toInt();
                } else {
                  result = int.parse(textCtr.text);
                }

                await PreferencesUtil.setDailyGoal(result);
                await PreferencesUtil.putFirstTime(false);
                Get.find<StandardReminderController>().initDataDefault();
                Get.find<WarterController>().dailyGoal.value = result;
                settingCtl.changeUnit(unitSelected);
                Get.offAll(NavbarScreen());
              }
            },
            child: Container(
              height: 56.0,
              width: 192.0,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  gradient: checkValid
                      ? GlobalColors.linearPrimary2
                      : GlobalColors.linearPrimary2.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(28.0)),
              child: Text(
                L.save.tr,
                style: GlobalTextStyles.font16w600ColorWhite.copyWith(
                    color: checkValid ? null : Colors.white.withOpacity(.4)),
              ),
            ),
          ),
          Spacer()
        ],
      ),
    );
  }

  PopupMenuItem<String> _buildPopupMenuItem(String value) {
    return PopupMenuItem<String>(
      value: value,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.0),
        padding: EdgeInsets.only(bottom: 16.0, top: 16),
        decoration: BoxDecoration(
            border: value == "fl oz"
                ? null
                : Border(bottom: BorderSide(color: GlobalColors.newtral))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(value, style: GlobalTextStyles.font16w600ColorBlack),
            value == settingCtl.unit.value
                ? SvgPicture.asset(
                    "assets/icons/done.svg",
                    width: 24,
                    height: 24,
                  )
                : SizedBox()
          ],
        ),
      ),
    );
  }
}
