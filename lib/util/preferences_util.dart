import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesUtil {
  static SharedPreferences? _pref;

  static Future<void> init() async {
    _pref ??= await SharedPreferences.getInstance();
  }

  static Future<void> setLanguage(String code) async {
    await _pref?.setString("language", code);
  }

  static String getLanguage() {
    return _pref?.getString("language") ??
        (Get.deviceLocale?.languageCode ?? '');
  }

  static Future<void> setSound(bool val) async {
    await _pref?.setBool("is_sound", val);
  }

  static bool getSound() {
    return _pref?.getBool("is_sound") ?? true;
  }

  static Future<void> setStandardReminderUnlocked15(bool val) async {
    await _pref?.setBool("standard_reminder_unlocked_15", val);
  }

  static Future<void> setStandardReminderUnlocked(bool val) async {
    await _pref?.setBool("standard_reminder_unlocked", val);
  }

  static Future<void> setIntervalReminderUnlocked(bool val) async {
    await _pref?.setBool("interval_reminder_unlocked", val);
  }

  static bool getStandardReminderUnlocked15() {
    return _pref?.getBool("standard_reminder_unlocked_15") ?? false;
  }

  static bool getStandardReminderUnlocked() {
    return _pref?.getBool("standard_reminder_unlocked") ?? false;
  }

  static bool getIntervalReminderUnlocked() {
    return _pref?.getBool("interval_reminder_unlocked") ?? false;
  }

  static Future<void> setAlarmTriggle(int val) async {
    await _pref?.setInt("alarm_triggle", val);
  }

  static int getAlarmTriggle() {
    return _pref?.getInt("alarm_triggle") ?? 110;
  }

  static Future<void> setIsPermissionGranted(bool val) async {
    await _pref?.setBool("is_permission_granted", val);
  }

  static bool getIsPermissionGranted() {
    return _pref?.getBool("is_permission_granted") ?? false;
  }

  static Future<void> setRate() async {
    await _pref?.setBool("rated", true);
  }

  static bool isRated() {
    return _pref?.getBool("rated") ?? false;
  }

  static Future<void> setSelectFirstLanguage() async {
    await _pref?.setBool("select_first_language", true);
  }

  static bool isSelectFirstLanguage() {
    return _pref?.getBool("select_first_language") ?? false;
  }

  static Future<void> setCountCreateJournal(int count) async {
    await _pref?.setInt("count_create_journal", count);
  }

  static int getCountCreateJournal() {
    return _pref?.getInt("count_create_journal") ?? 0;
  }

  static void increaseCountOpenIntroScreen() {
    var count = getCountOpenIntroScreen();
    count++;
    _pref?.setInt("count_open_intro_screen", count);
  }

  static int getCountOpenIntroScreen() {
    return _pref?.getInt("count_open_intro_screen") ?? 0;
  }

  static Future<void> saveCanRate() async {
    await _pref?.setBool("can_rate", false);
  }

  static bool getCanRate() {
    return _pref?.getBool("can_rate") ?? true;
  }

  static Future<void> putFirstTime(bool firstTime) async {
    await _pref?.setBool("firstTime", firstTime);
  }

  static bool getFirstTime() {
    return _pref?.getBool("firstTime") ?? true;
  }

  static void countClickGetStartedAtSuccessScreen() {
    var count = getCountClickGetStartedAtSuccessScreen();
    count++;
    _pref?.setInt("count_click_get_started_at_success_screen", count);
  }

  static int getCountClickGetStartedAtSuccessScreen() {
    return _pref?.getInt("count_click_get_started_at_success_screen") ?? 0;
  }

  static bool isTrackingAuthorizationStatus() {
    return _pref?.getBool("is_tracking_permission_authorization") ?? false;
  }

  static Future<void> setTrackingAuthorizationStatus(bool isTracking) async {
    _pref?.setBool("is_tracking_permission_authorization", isTracking);
  }

  static int getCountTrackingAuthorizationStatus() {
    return _pref?.getInt("count_tracking_authorization_status") ?? 0;
  }

  static void increaseTrackingAuthorizationStatus() {
    var count = getCountTrackingAuthorizationStatus();
    count++;
    _pref?.setInt("count_tracking_authorization_status", count);
  }

  static Future<void> setcountClickOn3(int value) async {
    await _pref?.setInt("count_click_on3", value);
  }

  static int getcountClickOn3() {
    return _pref?.getInt("count_click_on3") ?? 0;
  }

  static Future<void> setDailyGoal(int value) async {
    await _pref?.setInt("daily_goal", value);
  }

  static int getDailyGoal() {
    return _pref?.getInt("daily_goal") ?? 0;
  }

  static Future<void> setUnit(String value) async {
    await _pref?.setString("unit", value);
  }

  static String getUnit() {
    return _pref?.getString("unit") ?? 'ml';
  }

  static Future<void> setDrankWater(int value) async {
    await _pref?.setInt("drank_water", value);
  }

  static int getDrankWater() {
    return _pref?.getInt("drank_water") ?? 0;
  }

  static Future<void> setReminderMode(String value) async {
    await _pref?.setString("reminder_mode", value);
  }

  static String getReminderMode() {
    return _pref?.getString("reminder_mode") ?? "";
  }

  static Future<void> setIntervalTime(int value) async {
    await _pref?.setInt("interval_time", value);
  }

  static int getIntervalTime() {
    return _pref?.getInt("interval_time") ?? 30;
  }

  static Future<void> setIntervalTimeSleep(String value) async {
    await _pref?.setString("interval_time_sleep", value);
  }

  static String getIntervalTimeSleep() {
    return _pref?.getString("interval_time_sleep") ??
        DateTime.utc(2024, 1, 1, 22, 30).toString();
  }

  static Future<void> setIntervalTimeWakeUp(String value) async {
    await _pref?.setString("interval_time_wake_up", value);
  }

  static String getIntervalTimeWakeUp() {
    return _pref?.getString("interval_time_wake_up") ??
        DateTime.utc(2024, 1, 1, 7, 30).toString();
  }
}
