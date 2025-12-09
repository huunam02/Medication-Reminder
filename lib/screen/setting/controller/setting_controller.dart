
import 'package:package_info_plus/package_info_plus.dart';
import 'package:get/get.dart';

class SettingController extends GetxController {
  RxString version = "".obs;
  Future<void> setVersion() async {
    late PackageInfo packageInfo;
    packageInfo = await PackageInfo.fromPlatform();
    version.value = packageInfo.version;
  }
}
