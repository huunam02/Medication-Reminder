import '/base/lifecycle_state.dart';
import '/config/global_sadow.dart';
import '/lang/l.dart';
import '/widget/appbar_base.dart';
import '/widget/gradient_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '/config/global_color.dart';
import '/config/global_text_style.dart';
import '/screen/daily_goal/daily_goal_screen.dart';
import '/widget/body_background.dart';
import '/screen/permission/permission_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_switch/flutter_switch.dart';

class PermissionScreen extends StatefulWidget {
  const PermissionScreen({super.key});

  @override
  State<PermissionScreen> createState() => PermissionScreenState();
}

class PermissionScreenState extends LifecycleState<PermissionScreen> {
  @override
  void initState() {
    super.initState();
    permissionCtl.checkPermission(false);
  }

  final permissionCtl = Get.find<PermissionController>();

  @override
  Widget build(BuildContext context) {
    return BodyCustom(
      isShowBgImages: false,
      appbar: AppbarBase(
        title: GradientText(L.permission.tr,
            textAlign: TextAlign.center,
            gradient: GlobalColors.linearPrimary2,
            style: GlobalTextStyles.font20w600ColorWhite),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(height: 30),
                Image.asset(
                  "assets/images/permission.png",
                  width: 121.7,
                  height: 160,
                ),
                SizedBox(height: 7),
                Text(L.permissionDesc.tr,
                    textAlign: TextAlign.center,
                    style: GlobalTextStyles.font14w400ColorBlack),
                16.verticalSpace,
                Container(
                  height: 60.h,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: GlobalColors.container1,
                      boxShadow: GlobalShadow.primary),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(L.allowAccess.tr,
                            style: GlobalTextStyles.font14w600ColorBlack),
                        Obx(
                          () => FlutterSwitch(
                            activeColor: GlobalColors.colorLastLinear,
                            inactiveColor: const Color(0xFF8E8E93),
                            width: 48.0,
                            height: 24.0,
                            valueFontSize: 20.0,
                            toggleSize: 20.0,
                            value: permissionCtl.isToggled.value,
                            borderRadius: 30.0,
                            padding: 4,
                            onToggle: (val) {
                              permissionCtl.requestAllPermission();
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GestureDetector(
              onTap: () {
                Get.offAll(const DailyGoalScreen());
              },
              child: Center(
                child: Text(L.continuee.tr,
                    style: GlobalTextStyles.font18w600ColorBlack),
              ),
            ),
          ),
          Spacer()
        ],
      ),
    );
  }

  @override
  void onDetached() {}

  @override
  void onInactive() {}

  @override
  void onKeyboardHint() {}

  @override
  void onKeyboardShow() {}

  @override
  void onPaused() {}

  @override
  void onResumed() {
    permissionCtl.checkPermission(true);
  }
}
