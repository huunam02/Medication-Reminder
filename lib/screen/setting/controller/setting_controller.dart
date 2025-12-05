import '/screen/water/controller/warter_controller.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '/util/preferences_util.dart';
import 'package:get/get.dart';

class SettingController extends GetxController {
  RxString unit = PreferencesUtil.getUnit().obs;
  RxString version = "".obs;
  Future<void> setVersion() async {
    late PackageInfo packageInfo;
    packageInfo = await PackageInfo.fromPlatform();
    version.value = packageInfo.version;
  }

  void changeUnit(String val) {
    unit.value = val;
    PreferencesUtil.setUnit(val);
  }

  void setDailyGoal(String val) {
    try {
      int ml = int.parse(val);

      if (unit.value == "L") {
        ml = ml * 1000;
      }
      if (unit.value == 'fl oz') {
        ml = ml * 29.00.round();
      }
      Get.find<WarterController>().setDailyGoal(ml);
    } catch (e) {
      debugPrint(e.toString());
    }
    Get.back();
  }
}
