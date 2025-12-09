import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/model/reminder.dart';
import '/service/database_hepler.dart';
import '/service/notification.dart';
import '../../medicine/controller/medicine_controller.dart';

class ReminderController extends GetxController {
  RxList<Reminder> listReminder = <Reminder>[].obs;
  RxBool isLoad = true.obs;
  RxBool isOnReminder = false.obs;
  Rx<Reminder?> nextReminderObj = Rx<Reminder?>(null);
  RxString nextReminder = "OFF".obs;
  RxBool onAll = false.obs;
  RxList<int> takenReminderIds = <int>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    isLoad.value = true;
    List<Map<String, dynamic>> data = await DatabaseHelper().queryAllReminders();
    listReminder.value = data.map((e) => Reminder.fromMap(e)).toList();
    
    var history = await DatabaseHelper().queryAllToDay();
    takenReminderIds.value = history.map((e) => e['reminderId'] as int).toList();

    checkOnReminder();
    checkNextReminder();
    isLoad.value = false;
  }

  void addReminder(Reminder reminder) async {
    int id = await DatabaseHelper().insertReminder(reminder.toMap());
    reminder.id = id;
    await loadData();
    if (reminder.isOn) {
      _scheduleNotification(reminder);
    }
    Get.back();
  }

  void updateTimeReminder(Reminder reminder) async {
    await DatabaseHelper().updateReminder(reminder.toMap());
    int index = listReminder.indexWhere((element) => element.id == reminder.id);
    if (index != -1) {
      listReminder[index] = reminder;
      listReminder.refresh();
    }
    if (reminder.isOn) {
      NotificationService.cancelNotification(reminder.id!);
      _scheduleNotification(reminder);
    } else {
      NotificationService.cancelNotification(reminder.id!);
    }
    checkNextReminder();
    Get.back();
  }

  void deleteReminder(Reminder reminder) async {
    await DatabaseHelper().deleteReminder(reminder.id!);
    listReminder.remove(reminder);
    NotificationService.cancelNotification(reminder.id!);
    checkNextReminder();
  }

  void checkOnReminder() {
    isOnReminder.value = listReminder.any((element) => element.isOn);
  }

  void clickOnAll() async {
    for (var reminder in listReminder) {
      reminder.isOn = true;
      await DatabaseHelper().updateReminder(reminder.toMap());
      _scheduleNotification(reminder);
    }
    isOnReminder.value = true;
    onAll.value = true;
    listReminder.refresh();
    checkNextReminder();
  }

  void clickOffAll() async {
    for (var reminder in listReminder) {
      reminder.isOn = false;
      await DatabaseHelper().updateReminder(reminder.toMap());
      NotificationService.cancelNotification(reminder.id!);
    }
    isOnReminder.value = false;
    onAll.value = false;
    listReminder.refresh();
    checkNextReminder();
  }

  void _scheduleNotification(Reminder reminder) {
    DateTime time = DateTime.parse(reminder.dateTime);
    TimeOfDay timeOfDay = TimeOfDay(hour: time.hour, minute: time.minute);
    
    if (reminder.repeatDays != null && reminder.repeatDays!.isNotEmpty) {
      List<int> days = reminder.repeatDays!.split(",").map((e) => int.parse(e)).toList();
      NotificationService.scheduleWeeklyNotification(reminder.id!, timeOfDay, days);
    } else {
      NotificationService.scheduleDailyNotification(reminder.id!, timeOfDay);
    }
  }

  void checkNextReminder() {
    DateTime now = DateTime.now();
    Reminder? next;
    Duration? minDiff;

    for (var reminder in listReminder) {
      if (!reminder.isOn) continue;
      DateTime time = DateTime.parse(reminder.dateTime);
      DateTime reminderTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);
      
      if (takenReminderIds.contains(reminder.id)) {
        reminderTime = reminderTime.add(const Duration(days: 1));
      } else if (reminderTime.isBefore(now.subtract(const Duration(minutes: 15)))) {
        reminderTime = reminderTime.add(const Duration(days: 1));
      }
      
      Duration diff = reminderTime.difference(now);
      if (minDiff == null || diff < minDiff) {
        minDiff = diff;
        next = reminder;
      }
    }
    nextReminderObj.value = next;
    if (next != null) {
      nextReminder.value = next.dateTime;
    } else {
      nextReminder.value = "OFF";
    }
  }

  void updateOnReminder(Reminder reminder) async {
    reminder.isOn = !reminder.isOn;
    await DatabaseHelper().updateReminder(reminder.toMap());
    int index = listReminder.indexWhere((element) => element.id == reminder.id);
    if (index != -1) {
      listReminder[index] = reminder;
      listReminder.refresh();
    }
    if (reminder.isOn) {
      _scheduleNotification(reminder);
    } else {
      NotificationService.cancelNotification(reminder.id!);
    }
    checkOnReminder();
    checkNextReminder();
  }

  Future<void> markAsTaken(Reminder reminder) async {
    Map<String, dynamic> row = {
      "reminderId": reminder.id,
      "title": reminder.title,
      "amount": reminder.quantity ?? 1,
      "datetime": DateTime.now().toString(),
      "unit": "pill"
    };
    await DatabaseHelper().insertHistory(row);
    debugPrint("Marked as taken: ${reminder.title}");
    takenReminderIds.add(reminder.id!);
    
    // If it's a one-time reminder (no repeat days), turn it off after taking
    if (reminder.repeatDays == null || reminder.repeatDays!.isEmpty) {
      reminder.isOn = false;
      await DatabaseHelper().updateReminder(reminder.toMap());
      int index = listReminder.indexWhere((element) => element.id == reminder.id);
      if (index != -1) {
        listReminder[index] = reminder;
        listReminder.refresh();
      }
      NotificationService.cancelNotification(reminder.id!);
    }
    
    checkNextReminder();
    if (Get.isRegistered<MedicineController>()) {
      Get.find<MedicineController>().loadData();
    }
  }
}
