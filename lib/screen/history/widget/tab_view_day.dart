

import '/config/global_color.dart';
import '/config/global_sadow.dart';
import '/config/global_text_style.dart';
import '/lang/l.dart';
import '/model/history.dart';
import '/screen/history/controller/history_controller.dart';
import '/screen/history/widget/custom_chart_day.dart';
import '/screen/history/widget/custom_item_recent.dart';
import '/screen/water/controller/warter_controller.dart';
import '/util/preferences_util.dart';
import '/widget/dialog_delete_record.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TabBarViewDay extends StatefulWidget {
  const TabBarViewDay({super.key});

  @override
  State<TabBarViewDay> createState() => _TabBarViewDayState();
}

class _TabBarViewDayState extends State<TabBarViewDay> {
  final historyCtl = Get.find<HistoryController>();
  final waterCtl = Get.find<WarterController>();
  @override
  void initState() {
    super.initState();
    historyCtl.getListHistoryDay();
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
                            historyCtl.lastDay();
                          },
                          child:
                              SvgPicture.asset("assets/icons/last_data.svg")),
                      Obx(
                        () => Text(
                          historyCtl.daySelect.value.day == DateTime.now().day
                              ? L.today.tr
                              : DateFormat('yyyy-MM-dd')
                                  .format(historyCtl.daySelect.value),
                          style: GlobalTextStyles.font16w600ColorBlack,
                        ),
                      ),
                      GestureDetector(
                          onTap: () {
                            historyCtl.nextDay();
                          },
                          child: Obx(() => SvgPicture.asset(
                                "assets/icons/next_data.svg",
                                color: historyCtl.daySelect.value.day ==
                                        DateTime.now().day
                                    ? Colors.white.withOpacity(.2)
                                    : null,
                              ))),
                    ],
                  ),
                ),
                AspectRatio(
                  aspectRatio: 0.8,
                  child: Container(
                    padding: EdgeInsetsDirectional.all(16.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: GlobalShadow.primary,
                        borderRadius: BorderRadius.circular(16.0)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              L.total.tr,
                              style: GlobalTextStyles.font12w400ColorNewtral,
                            ),
                            Text(
                              L.goal.tr,
                              style: GlobalTextStyles.font12w400ColorNewtral,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Obx(
                              () => Text(
                                "${historyCtl.totalDay} ml",
                                style: GlobalTextStyles.font20w600ColorWhite,
                              ),
                            ),
                            Text(
                              "${PreferencesUtil.getDailyGoal()} ml",
                              style: GlobalTextStyles.font20w600ColorWhite,
                            ),
                          ],
                        ),
                        Text(
                          "${L.unit.tr} (ml)",
                          style: GlobalTextStyles.font10w400ColorWhite
                              .copyWith(color: GlobalColors.newtral),
                        ),
                        Spacer(),
                        ClipRect(child: CustomChartDay()),
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
                  () => historyCtl.listHistoryDay.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(
                            historyCtl.listHistoryDay.length,
                            (index) {
                              History history = historyCtl.listHistoryDay[
                                  historyCtl.listHistoryDay.length - index - 1];
                              return CustomItemRecent(
                                history: history,
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => Dialog(
                                      child: DialogDeleteRecord(
                                        ontap: () {
                                          historyCtl.deleteRecord(history, 0);
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
                ),
              ],
            ),
          ),
        ),
     
      ],
    );
  }
}
