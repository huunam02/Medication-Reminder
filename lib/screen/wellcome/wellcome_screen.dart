import '/config/global_color.dart';
import '/screen/daily_goal/daily_goal_screen.dart';
import '/config/global_text_style.dart';
import '/lang/l.dart';
import '/util/ads_manager.dart';
import '/widget/body_background.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WellcomeScreen extends StatefulWidget {
  const WellcomeScreen({super.key});

  @override
  State<WellcomeScreen> createState() => _WellcomeScreenState();
}

class _WellcomeScreenState extends State<WellcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BodyCustom(
        isShowBgImages: false,
        child: Column(
          children: [
            const Spacer(),
            Image.asset(
              "assets/images/wellcome.png",
              height: 220,
              width: 220,
            ),
            Text(
              L.wellcome.tr,
              style: GlobalTextStyles.font32w700ColorWhite
                  .copyWith(color: GlobalColors.colorLastLinear),
            ),
            Text(
              "Thank you for choosing us",
              style: GlobalTextStyles.font14w400ColorNewtral,
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                // PreferencesUtil.setIsPermissionGranted(true);
                Get.offAll(const DailyGoalScreen());
              },
              child: Text(
                L.continuee.tr,
                style: GlobalTextStyles.font18w600ColorBlack,
              ),
            ),
            SizedBox(
              height: AdsManager.largeNativeAdHeight,
            ),
          ],
        ));
  }
}
