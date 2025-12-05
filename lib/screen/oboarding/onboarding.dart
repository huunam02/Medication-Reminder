//import 'package:amazic_ads_flutter/admob_ads_flutter.dart';
import 'dart:io';
import '/screen/daily_goal/daily_goal_screen.dart';
import '/screen/navbar/navbar.dart';
import '/screen/permission/permission.dart';
import '/widget/body_background.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '/config/global_color.dart';
import '/config/global_text_style.dart';
import '/lang/l.dart';
import '/screen/oboarding/controller/onboarding_controller.dart';
import '/util/preferences_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final onboardCtr = Get.find<OnboardingController>();
  int sdk = 0;

  void getSdk() async {
    var androidInfo = await DeviceInfoPlugin().androidInfo;
    setState(() {
      sdk = androidInfo.version.sdkInt;
    });
  }

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      getSdk();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BodyCustom(
      isShowBgImages: false,
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Obx(
                () => PageView(
                  onPageChanged: (value) {
                    if (_currentPage == 0) {
                      //  EventLog.logEvent("onboarding1_view");
                    } else if (_currentPage == 1) {
                      //      EventLog.logEvent("onboarding2_view");
                    } else if (_currentPage ==
                        onboardCtr.listWiget.length - 1) {
                      //    EventLog.logEvent("onboarding3_view");
                    }
                    setState(() {
                      _currentPage = value;
                    });
                  },
                  controller: _pageController,
                  children: List.generate(
                    onboardCtr.listWiget.length,
                    (index) {
                      return onboardCtr.listWiget[index];
                    },
                  ),
                ),
              ),
            ),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  16.verticalSpace,
                  Text(onboardCtr.listWiget[_currentPage].title.tr,
                      style: GlobalTextStyles.font20w700ColorBlack),
                  12.verticalSpace,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      textAlign: TextAlign.center,
                      onboardCtr.listWiget[_currentPage].description.tr,
                      style: GlobalTextStyles.font14w400ColorBlack,
                    ),
                  ),
                  16.verticalSpace,
                  SmoothPageIndicator(
                    controller: _pageController, // PageController
                    count: onboardCtr.listWiget.length,
                    effect: ExpandingDotsEffect(
                      activeDotColor: GlobalColors.colorLastLinear, // fix sot
                      dotColor: Colors.grey,
                      dotHeight: 8,
                      dotWidth: 8,
                    ),
                  ),
                  16.verticalSpace,
                  InkWell(
                    onTap: () {
                      if (_currentPage < onboardCtr.listWiget.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                        );
                      } else {
                        navigate();
                      }
                    },
                    child: Text(L.next.tr,
                        style: GlobalTextStyles.font16w600ColorBlack),
                  ),
                  12.verticalSpace,

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void navigate() {
    if (Platform.isIOS && PreferencesUtil.getFirstTime()) {
      Get.offAll(() => const DailyGoalScreen());
      return;
    }
    if (PreferencesUtil.getFirstTime()) {
      if (sdk >= 33) {
        Get.off(() => const PermissionScreen());
      } else {
        Get.offAll(() => const DailyGoalScreen());
      }
    } else {
      Get.offAll(() => const NavbarScreen());
    }
  }
}
