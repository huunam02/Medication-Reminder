// //import 'package:amazic_ads_flutter/admob_ads_flutter.dart';
// import 'package:amazic_ads_flutter/admob_ads_flutter.dart';
// import '/screen/oboarding/controller/onboarding_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:lottie/lottie.dart';

// class NativeAdsItem extends StatelessWidget {
//   final NativeAds nativeAds;
//   const NativeAdsItem({super.key, required this.nativeAds});
//   @override
//   Widget build(BuildContext context) {
//     final onboardingCtl = Get.find<OnboardingController>();Ư
//     return Obx(
//       () => Stack(
//         children: [
//           nativeAds,
//           onboardingCtl.isNativeFullShow.value
//               ? Align(
//                   alignment: Alignment.center,
//                   child: Lottie.asset("assets/lotties/animationtay.json"))
//               : const SizedBox.shrink()
//         ],
//       ),
//     );
//   }
// }
