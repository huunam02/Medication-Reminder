import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart';

class PermissionController extends GetxController {
  RxBool isToggled = false.obs;
  bool _isRequesting = false;

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

  Future<void> requestAllPermission() async {
    if (_isRequesting) return;
    _isRequesting = true;
    try {
      var status = await Permission.notification.request();
      if (status.isPermanentlyDenied) {
        await openAppSettings();
      }
      if (status.isGranted) {
        isToggled.value = true;
      }
    } catch (e) {
      debugPrint("Error requesting permission: $e");
    } finally {
      _isRequesting = false;
    }
  }

  Future<void> requestNotification() async {
    await requestAllPermission();
  }
}
