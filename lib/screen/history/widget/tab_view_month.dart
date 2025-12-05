
import '/config/global_color.dart';
import '/config/global_text_style.dart';
import '/lang/l.dart';
import '/model/history.dart';
import '/screen/history/controller/history_controller.dart';
import '/screen/history/widget/custom_chart_month.dart';
import '/screen/water/controller/warter_controller.dart';
import '/util/preferences_util.dart';
import '/widget/dialog_delete_record.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'custom_item_recent.dart';

class TabViewMonth extends StatefulWidget {
  const TabViewMonth({super.key});

  @override
  State<TabViewMonth> createState() => _TabViewMonthState();
}

class _TabViewMonthState extends State<TabViewMonth> {
  final historyCtl = Get.find<HistoryController>();
  final waterCtl = Get.find<WarterController>();
  @override
  void initState() {
    super.initState();
    historyCtl.getListHistoryMonth();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                          onTap: () {
                            historyCtl.lastMonth();
                          },
                          child:
                              SvgPicture.asset("assets/icons/last_data.svg")),
                      Obx(
                        () => Text(
                          DateFormat("MMM yyyy", PreferencesUtil.getLanguage())
                              .format(historyCtl.monthSelect.value),
                          style: GlobalTextStyles.font16w600ColorBlack,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          historyCtl.nextMonth();
                        },
                        child: Obx(
                          () => SvgPicture.asset("assets/icons/next_data.svg",
                              color: historyCtl.monthSelect.value.month >=
                                      DateTime.now().month
                                  ? Colors.white.withOpacity(.2)
                                  : null),
                        ),
                      )
                    ],
                  ),
                ),
                AspectRatio(
                  aspectRatio: 0.8,
                  child: Container(
                    padding: EdgeInsetsDirectional.all(16.0),
                    decoration: BoxDecoration(
                        color: GlobalColors.container1,
                        borderRadius: BorderRadius.circular(16.0)),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              L.total.tr,
                              style: GlobalTextStyles.font12w400ColorNewtral,
                            ),
                            Text(
                              L.average.tr,
                              style: GlobalTextStyles.font12w400ColorNewtral,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Obx(
                              () => Text(
                                "${(historyCtl.totalMonth / 1000).toStringAsFixed(1)} L",
                                style: GlobalTextStyles.font20w600ColorWhite,
                              ),
                            ),
                            Obx(
                              () => Text(
                                "${((historyCtl.totalMonth / 1000) / getDaysInMonthFromDate(historyCtl.monthSelect.value)).toStringAsFixed(1)} L",
                                style: GlobalTextStyles.font20w600ColorWhite,
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        ClipRect(child: CustomChartMonth()),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    L.recentDrinkingHistory.tr,
                    style: GlobalTextStyles.font16w600ColorBlack,
                  ),
                ),
                Obx(
                  () => historyCtl.listHistoryMonth.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(
                            historyCtl.listHistoryMonth.length,
                            (index) {
                              History history = historyCtl.listHistoryMonth[
                                  historyCtl.listHistoryMonth.length -
                                      index -
                                      1];
                              return CustomItemRecent(
                                history: history,
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => Dialog(
                                      child: DialogDeleteRecord(
                                        ontap: () {
                                          historyCtl.deleteRecord(history, 2);
                                        },
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        )
                      : Center(
                          child: Column(
                            children: [
                              SvgPicture.asset("assets/icons/no_recent.svg"),
                              SizedBox(
                                height: 16.0,
                              ),
                              Text(
                                L.noRecent.tr,
                                style: GlobalTextStyles.font14w600ColorWhite
                                    .copyWith(color: Color(0xFF4B5563)),
                              )
                            ],
                          ),
                        ),
                )
              ],
            ),
          ),
        ),
   
      ],
    );
  }

  int getDaysInMonthFromDate(DateTime date) {
    int year = date.year;
    int month = date.month;

    // Chuyển sang tháng tiếp theo, nếu tháng là 12, chuyển sang năm sau
    var firstDayNextMonth =
        (month == 12) ? DateTime(year + 1, 1, 1) : DateTime(year, month + 1, 1);

    // Trừ đi một ngày để tìm ngày cuối cùng của tháng hiện tại
    var lastDayThisMonth = firstDayNextMonth.subtract(const Duration(days: 1));

    return lastDayThisMonth.day; // Trả về số ngày
  }
}
