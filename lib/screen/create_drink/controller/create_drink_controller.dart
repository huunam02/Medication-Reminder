import 'package:get/get.dart';

class CreateDrinkController {
  RxDouble waterLevel = 0.12.obs;
  RxBool isLoading = true.obs;
  void setWaterLevel(double val) {
    waterLevel.value = val;
  }

  void hideLoading() {
    if (!isLoading.value) return;
    Future.delayed(const Duration(seconds: 1), () {
      isLoading.value = false;
    });
  }
}
