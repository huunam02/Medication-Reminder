//import 'package:amazic_ads_flutter/admob_ads_flutter.dart';
import '/lang/l.dart';
import '/screen/oboarding/widget/item_pageview_onboarding.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController {
  RxBool isNativeFullShow = false.obs;
  var listWiget = [
    const ItemPageviewOnboarding(
      imagePath: "assets/images/onboard1.png",
      title: L.titleBoarding1,
      description: L.contentBoarding1,
    ),
    const ItemPageviewOnboarding(
      imagePath: "assets/images/onboard2.png",
      title: L.titleBoarding2,
      description: L.contentBoarding2,
    ),
    const ItemPageviewOnboarding(
      imagePath: "assets/images/onboard3.png",
      title: L.titleBoarding3,
      description: L.contentBoarding3,
    ),
    const ItemPageviewOnboarding(
      imagePath: "assets/images/onboard4.png",
      title: L.titleBoarding4,
      description: L.contentBoarding4,
    ),
    // Container(
    //   height: double.infinity,
    //   width: double.infinity,
    //   decoration: BoxDecoration(gradient: GlobalColors.linearContainer2),
    //   child: NativeAdsItem(
    //     nativeAds: NativeAds(
    //       reloadResume: true,
    //       factoryId: "native_intro_fullscreen",
    //       listId: NetworkRequest.instance
    //           .getListIDByName("native_intro_fullscreen"),
    //       height: double.infinity,
    //       config: true,
    //       visibilityDetectorKey: "native_intro_fullscreen",
    //     ),
    //   ),
    // ),
  ].obs;

  void delete(int index) {
    listWiget.remove(index);
  }
}
