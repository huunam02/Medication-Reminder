import '/screen/create_drink/controller/create_drink_controller.dart';
import '/screen/history/controller/history_controller.dart';
import '/screen/interval_reminder/controller/interval_reminder_controller.dart';
import '/screen/permission/permission_controller.dart';
import '/screen/setting/controller/setting_controller.dart';
import '/screen/standard_reminder/controller/standard_reminder_controller.dart';
import '/screen/water/controller/warter_controller.dart';
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

  final waterController = WarterController();
  Get.lazyPut(() => waterController, fenix: true);

  final standardReminderController = StandardReminderController();
  Get.lazyPut(() => standardReminderController, fenix: true);

  final intervalReminderController = IntervalReminderController();
  Get.lazyPut(() => intervalReminderController, fenix: true);

  final settingController = SettingController();
  Get.lazyPut(() => settingController, fenix: true);

  final historyController = HistoryController();
  Get.lazyPut(() => historyController, fenix: true);

  final createDrinkController = CreateDrinkController();
  Get.lazyPut(() => createDrinkController, fenix: true);
}
