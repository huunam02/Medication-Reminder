import '/model/history.dart';
import '/model/reminder.dart';
import '/screen/interval_reminder/controller/interval_reminder_controller.dart';
import '/screen/setting/controller/setting_controller.dart';
import '/screen/standard_reminder/controller/standard_reminder_controller.dart';
import '/service/database_hepler.dart';
import '/util/preferences_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WarterController extends GetxController {
  RxInt dailyGoal = PreferencesUtil.getDailyGoal().obs;
  RxInt drankWater = 0.obs;
  RxDouble waterLevel = 0.0.obs;
  RxBool isLoad = true.obs;
  RxString nextReminder = "OFF".obs;
  RxList<History> listHistory = <History>[].obs;
  RxString reminderMode = PreferencesUtil.getReminderMode().obs;
  double maxWaterLevel = 1;
  RxBool isShowHello = true.obs;
  void setDailyGoal(int ml) {
    dailyGoal.value = ml;
    PreferencesUtil.setDailyGoal(ml);
    loadData();
  }

  void setIsHideHello() {
    Future.delayed(Duration(seconds: 5), () {
      isShowHello.value = false;
    });
  }

  void checkNextReminder() async {
    DateTime currentDate = DateTime.now();
    TimeOfDay now =
        TimeOfDay(hour: currentDate.hour, minute: currentDate.minute);
    if (reminderMode.value == "standard") {
      final standardCtl = Get.find<StandardReminderController>();
      await standardCtl.loadData();
      standardCtl.checkOnAll();

      List<Reminder> listReminderTemp = [];
      List<Reminder> listReminderBigger = [];
      List<Reminder> listReminderSmaller = [];
      for (var element in standardCtl.listReminder) {
        if (element.isOn) {
          listReminderTemp.add(element);
        }
      }
      for (var element in listReminderTemp) {
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
        try {
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
        } catch (e) {
          debugPrint("checkNextReminder $e");
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
    } else if (reminderMode.value == "interval") {
      final intervalCtl = Get.find<IntervalReminderController>();
      intervalCtl.loadIntervalReminder();

      List<Reminder> listReminderBigger = [];
      List<Reminder> listReminderSmaller = [];

      for (var element in intervalCtl.listReminder) {
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
      nextReminder.value = "OFF";
    }
  }

  void setReminderMode(String val) {
    PreferencesUtil.setReminderMode(val);
    reminderMode.value = val;
  }

  void addDrank(int val, bool isCreate, History? history) async {
    int result = 0;
    final settingCtr = Get.find<SettingController>();

    result = drankWater.value + val;

    drankWater.value = result;

    History historyNew;
    if (isCreate) {
      historyNew = History(
          dateTime: DateTime.now().toString(),
          ml: val,
          unit: settingCtr.unit.value);
    } else {
      historyNew = History(
          dateTime: DateTime.now().toString(), ml: val, unit: history!.unit);
    }
    await DatabaseHelper().insertHistory(historyNew.toMap());
    loadData();
  }

  void initData() async {
    loadData();
    await Future.delayed(1500.milliseconds);
    isLoad.value = false;
  }

  void deleteWater(History history) async {
    await DatabaseHelper().deleteHistory(history.id!);
    loadData();
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
    if (listHistory.isEmpty) {
      waterLevel.value = 0.0;
      drankWater.value = 0;
    } else {
      int sum = 0;
      for (var item in listHistory) {
        sum += item.ml!;
      }
      drankWater.value = sum;
      double result =
          0.0 + (drankWater.value / dailyGoal.value) * (maxWaterLevel - 0.0);
      if (result >= 0.0 && result <= maxWaterLevel) {
        // waterLevel.value = result;
        double aFew = (result - waterLevel.value) / 50;
        for (int i = 0; i < 50; i++) {
          //animation
          waterLevel.value += aFew;
          await Future.delayed(20.milliseconds);
        }
      } else if (result >= maxWaterLevel) {
        waterLevel.value = maxWaterLevel;
      }
    }
  }
}
