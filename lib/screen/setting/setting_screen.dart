import 'package:flutter_screenutil/flutter_screenutil.dart';
import '/screen/water/controller/warter_controller.dart';
import '/widget/dialog_daily_goal.dart';
import '/widget/gradient_text.dart';
import '/config/global_color.dart';
import '/config/global_text_style.dart';
import '/lang/l.dart';
import '/screen/languege/controller/languege_controller.dart';
import '/screen/languege/language.dart';
import '/screen/privacy/privacy.dart';
import '/screen/setting/controller/setting_controller.dart';
import '/widget/body_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final langCtl = Get.find<LanguageController>();
  final settingCtl = Get.find<SettingController>();
  final waterCtl = Get.find<WarterController>();
  final textCtl = TextEditingController();
  bool isClicking = false;

  void checkSpam(ontap) async {
    if (!isClicking) {
      isClicking = true;
      ontap();
      await Future.delayed(const Duration(seconds: 2));
      isClicking = false;
    }
  }

  @override
  void initState() {
    super.initState();
    settingCtl.setVersion();
  }

  @override
  Widget build(BuildContext context) {
    return BodyCustom(
      edgeInsetsPadding: const EdgeInsets.only(top: 20),
      isShowBgImages: false,
      appbar: AppBar(
        backgroundColor: GlobalColors.bg1,
        title: GradientText(
          L.settings.tr,
          gradient: GlobalColors.linearPrimary2,
          style: GlobalTextStyles.font20w600ColorWhite,
        ),
        centerTitle: true,
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              margin: const EdgeInsets.only(top: 32.0, left: 16.0, right: 16.0),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: GlobalColors.container1,
                  borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  24.verticalSpace,
                  GestureDetector(
                    onTap: () => checkSpam(() {
                      showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: DialogDailyGoal(
                            ontap: () {
                              settingCtl.setDailyGoal(textCtl.text);
                              textCtl.clear();
                            },
                            controller: textCtl,
                            unit: settingCtl.unit.value,
                          ),
                        ),
                      );
                    }),
                    child: Row(
                      children: [
                        SvgPicture.asset("assets/icons/daily_setting.svg",
                            height: 24.0, width: 24.0),
                        16.horizontalSpace,
                        Text(
                          L.dailyGoal.tr,
                          style: GlobalTextStyles.font14w400ColorBlack
                              .copyWith(fontWeight: FontWeight.w500),
                        ),
                        const Spacer(),
                        Obx(
                          () => Text(
                            convertUnitData(waterCtl.dailyGoal.value),
                            style: GlobalTextStyles.font14w400ColorBlack
                                .copyWith(
                                    color: GlobalColors.colorLastLinear,
                                    fontWeight: FontWeight.w500),
                          ),
                        ),
                        Obx(
                          () => Text(
                            " ${settingCtl.unit.value}",
                            style: GlobalTextStyles.font14w400ColorBlack
                                .copyWith(
                                    color: GlobalColors.colorLastLinear,
                                    fontWeight: FontWeight.w500),
                          ),
                        ),
                        8.horizontalSpace,
                        SvgPicture.asset("assets/icons/ic_next_setting.svg",
                            height: 24.0, width: 24.0),
                      ],
                    ),
                  ),
                  24.verticalSpace,
                  Row(
                    children: [
                      SvgPicture.asset("assets/icons/unit_setting.svg",
                          height: 24.0, width: 24.0),
                      const SizedBox(
                        width: 16.0,
                      ),
                      Text(
                        L.units.tr,
                        style: GlobalTextStyles.font14w400ColorBlack
                            .copyWith(fontWeight: FontWeight.w500),
                      ),
                      const Spacer(),
                      PopupMenuButton<String>(
                        padding: EdgeInsets.all(16),
                        color: GlobalColors.container1,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0)),
                        onSelected: (String value) {
                          settingCtl.changeUnit(value);
                        },
                        itemBuilder: (BuildContext context) => [
                          _buildPopupMenuItem("ml"),
                          _buildPopupMenuItem("L"),
                          _buildPopupMenuItem("fl oz"),
                        ],
                        child: Row(
                          children: [
                            Obx(
                              () => Text(
                                settingCtl.unit.value,
                                style: GlobalTextStyles.font14w400ColorBlack
                                    .copyWith(
                                        color: GlobalColors.colorLastLinear),
                              ),
                            ),
                            const SizedBox(
                              width: 8.0,
                            ),
                            SvgPicture.asset(
                                "assets/icons/unit_setting_down.svg",
                                height: 24.0,
                                width: 24.0),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              margin: const EdgeInsets.only(top: 32.0, left: 16.0, right: 16.0),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: GlobalColors.container1,
                  borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  24.verticalSpace,
                  GestureDetector(
                    onTap: () => checkSpam(() {
                      Get.to(() => const LanguageScreen(isSetting: true));
                    }),
                    child: Row(
                      children: [
                        SvgPicture.asset("assets/icons/ic_language.svg",
                            height: 24.0, width: 24.0),
                        16.horizontalSpace,
                        Text(
                          L.language.tr,
                          style: GlobalTextStyles.font14w400ColorBlack
                              .copyWith(fontWeight: FontWeight.w500),
                        ),
                        const Spacer(),
                        8.horizontalSpace,
                        SvgPicture.asset("assets/icons/ic_next_setting.svg",
                            height: 24.0, width: 24.0),
                      ],
                    ),
                  ),
                  24.verticalSpace,
                  GestureDetector(
                    onTap: () {
                      checkSpam(() {
                        Share.shareUri(Uri.parse(
                            "https://play.google.com/store/apps/details?id=com.stallion.drinkwaterreminder"));
                      });
                    },
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          "assets/icons/ic_share.svg",
                          height: 24.0,
                          width: 24.0,
                        ),
                        16.horizontalSpace,
                        Text(
                          L.share.tr,
                          style: GlobalTextStyles.font14w400ColorBlack
                              .copyWith(fontWeight: FontWeight.w500),
                        ),
                        const Spacer(),
                        SvgPicture.asset(
                          "assets/icons/ic_next_setting.svg",
                          height: 24.0,
                          width: 24.0,
                        ),
                      ],
                    ),
                  ),
                  24.verticalSpace,
                  GestureDetector(
                    onTap: () => checkSpam(() {
                      Get.to(const PrivacyPolicyScreen());
                    }),
                    child: Row(
                      children: [
                        SvgPicture.asset("assets/icons/ic_lock.svg",
                            height: 24.0, width: 24.0),
                        16.horizontalSpace,
                        Text(
                          L.privacyPolicy.tr,
                          style: GlobalTextStyles.font14w400ColorBlack
                              .copyWith(fontWeight: FontWeight.w500),
                        ),
                        const Spacer(),
                        SvgPicture.asset(
                          "assets/icons/ic_next_setting.svg",
                          height: 24.0,
                          width: 24.0,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              "Drink Water Reminder",
              style: GlobalTextStyles.font16w600ColorBlack,
            ),
            SizedBox(
              height: 8,
            ),
            Obx(
              () => Text(
                "${L.version.tr} ${settingCtl.version.value}",
                style: GlobalTextStyles.font12w400ColorNewtral,
              ),
            ),
          ],
        ),
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

  PopupMenuItem<String> _buildPopupMenuItem(String value) {
    return PopupMenuItem<String>(
      value: value,
      child: Container(
        width: 80,
        decoration: BoxDecoration(
            border: Border(
                bottom: value != "fl oz"
                    ? BorderSide(color: GlobalColors.newtral)
                    : BorderSide.none)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(value, style: GlobalTextStyles.font16w600ColorBlack),
                SizedBox(
                  width: 8.0,
                ),
                Obx(
                  () => settingCtl.unit.value == value
                      ? SvgPicture.asset(
                          "assets/icons/done.svg",
                          width: 24,
                          height: 24,
                        )
                      : SizedBox(),
                ),
              ],
            ),
            SizedBox(
              height: 8.0,
            ),
            value != "fl oz"
                ? Container(
                    width: 80,
                    color: Colors.grey.withOpacity(.4),
                    height: 0.1,
                  )
                : SizedBox.shrink()
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    textCtl.dispose();
    super.dispose();
  }
}
