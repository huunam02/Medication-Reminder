import 'package:get/get.dart';
import '/model/history.dart';
import '/service/database_hepler.dart';
import '../../reminder/controller/reminder_controller.dart';

class MedicineController extends GetxController {
  RxBool isLoad = true.obs;
  RxString nextReminder = "OFF".obs;
  RxList<History> listHistory = <History>[].obs;

  void checkNextReminder() async {
    if (Get.isRegistered<ReminderController>()) {
      final reminderCtl = Get.find<ReminderController>();
      if (reminderCtl.nextReminderObj.value != null) {
        nextReminder.value = reminderCtl.nextReminderObj.value!.dateTime;
      } else {
        nextReminder.value = "OFF";
      }
    }
  }

  void initData() async {
    loadData();
    await Future.delayed(const Duration(milliseconds: 1500));
    isLoad.value = false;
  }

  void loadData() async {
    await DatabaseHelper().queryAllToDay().then(
      (value) {
        listHistory.value = value.reversed
            .map(
              (e) => History.fromMap(e),
            )
            .toList();
      },
    );
  }
}
