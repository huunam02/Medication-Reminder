import '/model/reminder.dart';
import '/screen/standard_reminder/controller/standard_reminder_controller.dart';
import '/screen/water/controller/warter_controller.dart';
import '/service/notification.dart';
import '/util/preferences_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IntervalReminderController extends GetxController {
  RxList<Reminder> listReminder = <Reminder>[].obs;
  RxBool isLoad = true.obs;
  RxInt intervalTime = PreferencesUtil.getIntervalTime().obs;
  RxString timeSleep = PreferencesUtil.getIntervalTimeSleep().obs;
  RxString timeWakeUp = PreferencesUtil.getIntervalTimeWakeUp().obs;
  RxString nextReminder = "".obs;
  RxBool isOnIntervalReminder =
      (PreferencesUtil.getReminderMode() == "interval" ? true : false).obs;

  void loadIntervalReminder() {
    listReminder.clear();
    DateTime timeSleepConvert = DateTime.parse(timeSleep.value);
    DateTime timeWakeUpConvert = DateTime.parse(timeWakeUp.value);

    if (timeSleepConvert.hour > timeWakeUpConvert.hour) {
      while (timeWakeUpConvert.hour < timeSleepConvert.hour) {
        listReminder
            .add(Reminder(dateTime: timeWakeUpConvert.toString(), isOn: true));
        timeWakeUpConvert =
            timeWakeUpConvert.add(Duration(minutes: intervalTime.value));
      }
    } else {
      while (timeWakeUpConvert.hour > timeSleepConvert.hour) {
        listReminder
            .add(Reminder(dateTime: timeWakeUpConvert.toString(), isOn: true));
        timeWakeUpConvert =
            timeWakeUpConvert.add(Duration(minutes: intervalTime.value));
      }
    }
  }

  void checkNextReminder() {
    if (isOnIntervalReminder.value) {
      DateTime currentDate = DateTime.now();
      TimeOfDay now =
          TimeOfDay(hour: currentDate.hour, minute: currentDate.minute);
      List<Reminder> listReminderBigger = [];
      List<Reminder> listReminderSmaller = [];

      for (var element in listReminder) {
        TimeOfDay temp = TimeOfDay(
            hour: DateTime.parse(element.dateTime).hour,
            minute: DateTime.parse(element.dateTime).minute);
        if (temp.isAfter(now)) {
          listReminderBigger.add(element);
        } else {
          listReminderSmaller.add(element);
        }
      }
      if (listReminderBigger.isEmpty) {
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

  void changeTimeInterval(int hour, int minute) {
    intervalTime.value = (hour * 60) + minute;
    if (intervalTime.value > 0) {
      PreferencesUtil.setIntervalTime(intervalTime.value);
      loadIntervalReminder();
      checkNextReminder();
    }
    if (isOnIntervalReminder.value) {
      NotificationService.cancelAllNotification();
      for (int i = 1; i <= listReminder.length; i++) {
        DateTime dateTime = DateTime.parse(listReminder[i - 1].dateTime);
        NotificationService.scheduleDailyNotification(
            i, TimeOfDay(hour: dateTime.hour, minute: dateTime.minute));
      }
    }

    Get.back();
  }

  void changeSleepTime(TimeOfDay time) {
    timeSleep.value =
        DateTime.utc(2024, 1, 1, time.hour, time.minute).toString();
    PreferencesUtil.setIntervalTimeSleep(timeSleep.value);
    loadIntervalReminder();
    if (isOnIntervalReminder.value) {
      NotificationService.cancelAllNotification();
      for (int i = 1; i <= listReminder.length; i++) {
        DateTime dateTime = DateTime.parse(listReminder[i - 1].dateTime);
        NotificationService.scheduleDailyNotification(
            i, TimeOfDay(hour: dateTime.hour, minute: dateTime.minute));
      }
    }
    if (isOnIntervalReminder.value) {
      checkNextReminder();
    }
    Get.back();
  }

  void changeWakeUpTime(TimeOfDay time) {
    timeWakeUp.value =
        DateTime.utc(2024, 1, 1, time.hour, time.minute).toString();
    PreferencesUtil.setIntervalTimeWakeUp(timeWakeUp.value);
    loadIntervalReminder();
    if (isOnIntervalReminder.value) {
      NotificationService.cancelAllNotification();
      for (int i = 1; i <= listReminder.length; i++) {
        DateTime dateTime = DateTime.parse(listReminder[i - 1].dateTime);
        NotificationService.scheduleDailyNotification(
            i, TimeOfDay(hour: dateTime.hour, minute: dateTime.minute));
      }
    }
    if (isOnIntervalReminder.value) {
      checkNextReminder();
    }

    Get.back();
  }

  void setChangeOnReminder() {
    final standardReminder = Get.find<StandardReminderController>();
    if (standardReminder.isOnReminder.value) {
      standardReminder.clickOffAll();
    }

    isOnIntervalReminder.value = !isOnIntervalReminder.value;
    if (isOnIntervalReminder.value) {
      Get.find<WarterController>().setReminderMode("interval");
      NotificationService.cancelAllNotification();
      for (int i = 1; i <= listReminder.length; i++) {
        DateTime dateTime = DateTime.parse(listReminder[i - 1].dateTime);
        NotificationService.scheduleDailyNotification(
            i, TimeOfDay(hour: dateTime.hour, minute: dateTime.minute));
      }
    } else {
      Get.find<WarterController>().setReminderMode("");
      NotificationService.cancelAllNotification();
    }
    checkNextReminder();
  }

  Future<void> setOffAllReminder() async {
    isOnIntervalReminder.value = false;

    NotificationService.cancelAllNotification();
  }
}
