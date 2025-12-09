import '/screen/history/controller/history_controller.dart';
import '/screen/permission/permission_controller.dart';
import '/screen/setting/controller/setting_controller.dart';
import 'screen/reminder/controller/reminder_controller.dart';
import 'screen/medicine/controller/medicine_controller.dart';
import '/screen/languege/controller/languege_controller.dart';
import '/screen/oboarding/controller/onboarding_controller.dart';
import '/util/preferences_util.dart';
import 'package:get/get.dart';

Future<void> init() async {
  await PreferencesUtil.init();

  final languageController = LanguageController();
  Get.lazyPut(() => languageController, fenix: true);

  final onboardingController = OnboardingController();
  Get.lazyPut(() => onboardingController, fenix: true);

  final permissionController = PermissionController();
  Get.lazyPut(() => permissionController, fenix: true);

  final medicineController = MedicineController();
  Get.lazyPut(() => medicineController, fenix: true);

  final reminderController = ReminderController();
  Get.lazyPut(() => reminderController, fenix: true);
  final settingController = SettingController();
  Get.lazyPut(() => settingController, fenix: true);

  final historyController = HistoryController();
  Get.lazyPut(() => historyController, fenix: true);
}
