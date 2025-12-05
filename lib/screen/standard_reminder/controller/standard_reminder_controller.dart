import 'dart:developer';

import '/lang/l.dart';
import '/util/preferences_util.dart';

import '/model/reminder.dart';
import '/screen/interval_reminder/controller/interval_reminder_controller.dart';
import '/screen/water/controller/warter_controller.dart';
import '/service/database_hepler.dart';
import '/service/notification.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StandardReminderController extends GetxController {
  RxList<Reminder> listReminder = <Reminder>[].obs;
  RxBool isLoad = true.obs;
  RxBool onAll = false.obs;
  RxBool isOnReminder = false.obs;
  RxString nextReminder = "".obs;
  Future<void> loadData() async {
    await DatabaseHelper().queryAllReminders().then(
      (value) {
        listReminder.value = value
            .map(
              (e) => Reminder.fromMap(e),
            )
            .toList();
      },
    );
    isLoad.value = false;
    checkNextReminder();
  }

  void checkNextReminder() {
    if (isOnReminder.value) {
      DateTime currentDate = DateTime.now();
      TimeOfDay now =
          TimeOfDay(hour: currentDate.hour, minute: currentDate.minute);
      List<Reminder> listReminderBigger = [];
      List<Reminder> listReminderSmaller = [];
      for (var element in listReminder) {
        TimeOfDay temp = TimeOfDay(
            hour: DateTime.parse(element.dateTime).hour,
            minute: DateTime.parse(element.dateTime).minute);
        if (temp.isAfter(now) && element.isOn) {
          listReminderBigger.add(element);
        } else if (now.isAfter(temp) && element.isOn) {
          listReminderSmaller.add(element);
        }
      }
      if (listReminderBigger.isEmpty) {
        if (listReminderSmaller.isNotEmpty) {
          TimeOfDay min = TimeOfDay(
              hour: DateTime.parse(listReminderSmaller[0].dateTime).hour,
              minute: DateTime.parse(listReminderSmaller[0].dateTime).minute);
          for (int i = 1; i < listReminderSmaller.length; i++) {
            TimeOfDay temp = TimeOfDay(
                hour: DateTime.parse(listReminderSmaller[i].dateTime).hour,
                minute: DateTime.parse(listReminderSmaller[i].dateTime).minute);
            if (min.isAfter(temp)) {
              min = temp;
            }
          }
          nextReminder.value =
              DateTime.utc(2024, 1, 1, min.hour, min.minute).toString();
        }
      } else {
        TimeOfDay min = TimeOfDay(
            hour: DateTime.parse(listReminderBigger[0].dateTime).hour,
            minute: DateTime.parse(listReminderBigger[0].dateTime).minute);
        for (int i = 1; i < listReminderBigger.length; i++) {
          TimeOfDay temp = TimeOfDay(
              hour: DateTime.parse(listReminderBigger[i].dateTime).hour,
              minute: DateTime.parse(listReminderBigger[i].dateTime).minute);
          if (min.isAfter(temp)) {
            min = temp;
          }
        }
        nextReminder.value =
            DateTime.utc(2024, 1, 1, min.hour, min.minute).toString();
      }
    } else {
      nextReminder.value = "";
    }
  }

  void updateOnReminder(Reminder reminder) async {
    final waterCtl = Get.find<WarterController>();
    if (waterCtl.reminderMode.value == "interval") {
      await Get.find<IntervalReminderController>().setOffAllReminder();
    }
    DateTime dateTime = DateTime.parse(reminder.dateTime);
    if (reminder.isOn == false) {
      waterCtl.setReminderMode("standard");
      NotificationService.scheduleDailyNotification(reminder.id!,
          TimeOfDay(hour: dateTime.hour, minute: dateTime.minute));
    } else {
      NotificationService.cancelNotification(
        reminder.id!,
      );
    }
    await DatabaseHelper()
        .updateReminder(reminder.copyWith(isOn: !reminder.isOn).toMap());

    int index = listReminder.indexWhere(
      (element) => element.id == reminder.id,
    );
    listReminder[index].isOn = !reminder.isOn;
    listReminder.refresh();
    checkOnAll();
    checkOnReminder();
    checkNextReminder();
  }

  void updateTimeReminder(Reminder reminder) async {
    DateTime dateTime = DateTime.parse(reminder.dateTime);
    int indexWhere = listReminder.indexWhere(
      (element) =>
          DateTime.parse(element.dateTime).hour == dateTime.hour &&
          DateTime.parse(element.dateTime).minute == dateTime.minute,
    );
    if (indexWhere == -1) {
      await DatabaseHelper().updateReminder(reminder.toMap());

      int index = listReminder.indexWhere(
        (element) => element.id == reminder.id,
      );
      listReminder[index].dateTime = reminder.dateTime;
      listReminder.refresh();

      if (reminder.isOn == true) {
        NotificationService.cancelNotification(
          reminder.id!,
        );
        NotificationService.scheduleDailyNotification(reminder.id!,
            TimeOfDay(hour: dateTime.hour, minute: dateTime.minute));
        Get.find<WarterController>().setReminderMode("standard");
      }
      debugPrint("Update succes time");
      checkNextReminder();
    } else {
      if (listReminder[indexWhere].title != reminder.title) {
        await DatabaseHelper().updateReminder(reminder.toMap());
        listReminder[indexWhere].title = reminder.title;
        listReminder.refresh();
      }
      debugPrint("Update title succes");
    }
    Get.back();
  }

  void clickOnAll() async {
    await Get.find<IntervalReminderController>().setOffAllReminder();
    for (int i = 0; i < listReminder.length; i++) {
      listReminder[i].isOn = true;
      DatabaseHelper().updateReminder(listReminder[i].toMap());
      DateTime dateTime = DateTime.parse(listReminder[i].dateTime);
      NotificationService.scheduleDailyNotification(listReminder[i].id!,
          TimeOfDay(hour: dateTime.hour, minute: dateTime.minute));
    }
    isOnReminder.value = true;
    Get.find<WarterController>().setReminderMode("standard");

    listReminder.refresh();
    checkNextReminder();
  }

  void clickOffAll() {
    for (int i = 0; i < listReminder.length; i++) {
      listReminder[i].isOn = false;
      DatabaseHelper().updateReminder(listReminder[i].toMap());
      print(listReminder[i].toMap());
      NotificationService.cancelNotification(
        listReminder[i].id!,
      );
    }
    Get.find<WarterController>().setReminderMode("");
    isOnReminder.value = false;
    onAll.value = false;
    listReminder.refresh();
    checkNextReminder();
  }

  void checkOnReminder() {
    isOnReminder.value = false;
    for (var element in listReminder) {
      if (element.isOn) {
        isOnReminder.value = true;
        break;
      }
    }
    // debugPrint("checkOnReminder $isOnReminder");
  }

  void checkOnAll() {
    onAll.value = true;
    for (var element in listReminder) {
      if (!element.isOn) {
        onAll.value = false;
        break;
      }
    }
  }

  void initDataDefault() async {
    DateTime now = DateTime.now();
    final reminder1 = Reminder(
        title: "After Wake-up",
        dateTime: DateTime.utc(now.year, now.month, now.day, 7, 30).toString(),
        isOn: false);
    final reminder2 = Reminder(
        title: "Before breakfast",
        dateTime: DateTime.utc(now.year, now.month, now.day, 8, 0).toString(),
        isOn: false);

    final reminder3 = Reminder(
        title: "After breakfast",
        dateTime: DateTime.utc(now.year, now.month, now.day, 8, 30).toString(),
        isOn: false);

    final reminder4 = Reminder(
        title: "Before lunch",
        dateTime: DateTime.utc(now.year, now.month, now.day, 11, 30).toString(),
        isOn: false);

    final reminder5 = Reminder(
        title: "After lunch",
        dateTime: DateTime.utc(now.year, now.month, now.day, 12, 30).toString(),
        isOn: false);

    final reminder6 = Reminder(
        title: "After Afternoon",
        dateTime: DateTime.utc(now.year, now.month, now.day, 14, 30).toString(),
        isOn: false);

    await DatabaseHelper().insertReminder(reminder1.toMap());
    await DatabaseHelper().insertReminder(reminder2.toMap());
    await DatabaseHelper().insertReminder(reminder3.toMap());
    await DatabaseHelper().insertReminder(reminder4.toMap());
    await DatabaseHelper().insertReminder(reminder5.toMap());
    await DatabaseHelper().insertReminder(reminder6.toMap());
  }

  void addReminder(Reminder reminder) async {
    int length = listReminder.length;
    int indexWhere = listReminder.indexWhere(
      (element) =>
          DateTime.parse(element.dateTime).hour ==
              DateTime.parse(reminder.dateTime).hour &&
          DateTime.parse(element.dateTime).minute ==
              DateTime.parse(reminder.dateTime).minute,
    );

    if (length > 10 && !PreferencesUtil.getStandardReminderUnlocked15()) {
      Get.snackbar(L.error.tr, L.youCanOnlyHaveUpTo10Reminders.tr);
      return;
    }
    if (length > 15 && PreferencesUtil.getStandardReminderUnlocked15()) {
      Get.snackbar(L.error.tr, L.youCanOnlyHaveUpTo15Reminders.tr);
      return;
    }
    if (indexWhere != -1) {
      Get.snackbar(L.error.tr, L.thisReminderAlreadyExists.tr);
      return;
    }

    await DatabaseHelper().insertReminder(reminder.toMap());
    listReminder.add(reminder);
    Get.back();
  }
}
