import '/config/global_color.dart';
import '/config/global_text_style.dart';
import '/lang/l.dart';
import '/model/history.dart';
import '/screen/history/controller/history_controller.dart';
import '/screen/history/widget/custom_chart_week.dart';
import '/util/preferences_util.dart';
import '/widget/dialog_delete_record.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'custom_item_recent.dart';

class TabViewWeek extends StatefulWidget {
  const TabViewWeek({super.key});

  @override
  State<TabViewWeek> createState() => _TabViewWeekState();
}

class _TabViewWeekState extends State<TabViewWeek> {
  final historyCtl = Get.find<HistoryController>();
  @override
  void initState() {
    super.initState();
    historyCtl.getListHistoryWeek();
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
                            historyCtl.lastWeek();
                          },
                          child:
                              SvgPicture.asset("assets/icons/last_data.svg")),
                      Obx(
                        () => Text(
                          "${DateFormat("MMM dd", PreferencesUtil.getLanguage()).format(historyCtl.startOfWeekSelect.value)} - ${DateFormat("MMM dd, yyyy", PreferencesUtil.getLanguage()).format(historyCtl.endOfWeekSelect.value)}",
                          style: GlobalTextStyles.font16w600ColorBlack,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          historyCtl.nextWeek();
                        },
                        child: Obx(
                          () => SvgPicture.asset("assets/icons/next_data.svg",
                              color: historyCtl.endOfWeekSelect.value
                                      .isAfter(DateTime.now())
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
                                "${(historyCtl.totalWeek / 1000).toStringAsFixed(1)} L",
                                style: GlobalTextStyles.font20w600ColorWhite,
                              ),
                            ),
                            Obx(
                              () => Text(
                                "${((historyCtl.totalWeek / 1000) / 7).toStringAsFixed(1)} L",
                                style: GlobalTextStyles.font20w600ColorWhite,
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        ClipRect(child: CustomChartWeek()),
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
                  () => historyCtl.listHistoryWeek.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(
                            historyCtl.listHistoryWeek.length,
                            (index) {
                              History history = historyCtl.listHistoryWeek[
                                  historyCtl.listHistoryWeek.length -
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
                                          historyCtl.deleteRecord(history, 1);
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
