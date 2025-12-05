import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionController extends GetxController {
  RxBool isToggled = false.obs;

  Future<void> checkPermission(bool isResume) async {
    var status = await Permission.notification.status;

    if (status.isGranted) {
      isToggled.value = true;
    } else if (status.isPermanentlyDenied && !isResume) {
      requestAllPermission();
    } else {
      isToggled.value = false;
    }
  }

  void requestAllPermission() async {
    var status = await Permission.notification.request();
    if (status.isPermanentlyDenied) {
      await openAppSettings();
    }
  }

  Future<void> requestNotification() async {
    var status = await Permission.notification.request();
    if (status.isPermanentlyDenied) {
      await openAppSettings();
    }
  }
}
