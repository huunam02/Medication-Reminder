import 'package:intl/intl.dart';
import '/model/history.dart';
import '/service/database_hepler.dart';
import 'package:get/get.dart';

class HistoryController extends GetxController {
  RxList<History> listHistoryDay = <History>[].obs;
  RxList<History> listHistoryMonth = <History>[].obs;
  RxList<History> listHistoryWeek = <History>[].obs;
  Rx<DateTime> daySelect = DateTime.now().obs;
  Rx<DateTime> startOfWeekSelect =
      DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1)).obs;
  Rx<DateTime> endOfWeekSelect = DateTime.now()
      .subtract(Duration(days: DateTime.now().weekday - 1))
      .add(7.days)
      .obs;
  Rx<DateTime> monthSelect = DateTime.now().obs;
  RxInt totalDay = 0.obs;
  RxInt totalWeek = 0.obs;
  RxInt totalMonth = 0.obs;
  RxList<int> listHour = <int>[].obs;
  RxList<int> listDayOfMonth = <int>[].obs;

  void getListHistoryDay() async {
    final List data = await DatabaseHelper().queryByDay(daySelect.value);
    listHistoryDay.value = data
        .map(
          (e) => History.fromMap(e),
        )
        .toList();
    getListHour();
    caclTotalDay();
  }

  void getListHour() {
    Set<int> hours = {};
    for (var element in listHistoryDay) {
      if (element.dateTime != null) {
        hours.add(DateTime.parse(element.dateTime!).hour);
      }
    }
    listHour.value = hours
        .map(
          (e) => e,
        )
        .toList();
    print(hours);
  }

  void lastDay() {
    daySelect.value = daySelect.value.subtract(24.hours);
    getListHistoryDay();
  }

  void nextDay() {
    DateTime now = DateTime.now();
    if (now.isAfter(daySelect.value.add(24.hours))) {
      daySelect.value = daySelect.value.add(24.hours);
      getListHistoryDay();
    }
  }

  void lastWeek() {
    startOfWeekSelect.value = startOfWeekSelect.value.subtract(7.days);
    endOfWeekSelect.value = endOfWeekSelect.value.subtract(7.days);
    getListHistoryWeek();
  }

  void nextWeek() {
    if (endOfWeekSelect.value.isBefore(DateTime.now())) {
      startOfWeekSelect.value = startOfWeekSelect.value.add(7.days);
      endOfWeekSelect.value = endOfWeekSelect.value.add(7.days);
      getListHistoryWeek();
    }
  }

  void lastMonth() {
    monthSelect.value = monthSelect.value.subtract(30.days);
    getListHistoryMonth();
  }

  void nextMonth() {
    if (monthSelect.value.month < DateTime.now().month) {
      monthSelect.value = monthSelect.value.add(30.days);
      getListHistoryMonth();
    }
  }

  void caclTotalDay() {
    int total = 0;
    for (var element in listHistoryDay) {
      total += element.ml!;
    }
    totalDay.value = total;
  }

  void caclTotalWeek() {
    int total = 0;
    for (var element in listHistoryWeek) {
      total += element.ml!;
    }
    totalWeek.value = total;
  }

  void getListHistoryWeek() async {
    List<History> listTemp = [];
    for (int i = 0; i < 7; i++) {
      List data = await DatabaseHelper()
          .queryByDay(startOfWeekSelect.value.add((i + 1).days));
      listTemp.addAll(data.map(
        (e) {
          print(e);
          return History.fromMap(e);
        },
      ).toList());
    }
    listHistoryWeek.value = listTemp;
    caclTotalWeek();
  }

  void caclTotalMonth() {
    int total = 0;
    for (var element in listHistoryMonth) {
      total += element.ml!;
    }
    totalMonth.value = total;
  }

  void getListHistoryMonth() async {
    final List data = await DatabaseHelper().queryByMonth(monthSelect.value);
    listHistoryMonth.value = data
        .map(
          (e) => History.fromMap(e),
        )
        .toList();
    caclTotalMonth();
    getListDayOfMonth();
  }

  void deleteRecord(History history, int tabId) async {
    await DatabaseHelper().deleteHistory(history.id!);
    if (tabId == 0) {
      getListHistoryDay();
    } else if (tabId == 1) {
      getListHistoryWeek();
    } else {
      getListHistoryMonth();
    }
    Get.back();
  }

  void getListDayOfMonth() {
    Set<int> days = {};
    for (var element in listHistoryMonth) {
      if (element.dateTime != null) {
        days.add(DateTime.parse(element.dateTime!).day);
      }
    }
    listDayOfMonth.value = days
        .map(
          (e) => e,
        )
        .toList();
    print(days);
  }
}
