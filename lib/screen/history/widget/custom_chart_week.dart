import '/config/global_color.dart';
import '/config/global_text_style.dart';
import '/screen/history/controller/history_controller.dart';
import '/screen/water/controller/warter_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomChartWeek extends StatefulWidget {
  const CustomChartWeek({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => CustomChartWeekState();
}

class CustomChartWeekState extends State<CustomChartWeek> {
  final historyCtl = Get.find<HistoryController>();
  final waterCtl = Get.find<WarterController>();
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Obx(
        () => BarChart(
          BarChartData(
              groupsSpace: 4.0,
              barTouchData: barTouchData,
              titlesData: titlesData,
              borderData: borderData,
              barGroups: barGroups,
              gridData: gridData,
              alignment: BarChartAlignment.spaceAround,
              maxY: (waterCtl.dailyGoal.value / 1000) +
                  ((waterCtl.dailyGoal.value / 1000) / 6),
              minY: 0),
        ),
      ),
    );
  }

  FlGridData get gridData => FlGridData(
        show: true,
        drawHorizontalLine: true,
        horizontalInterval:
            waterCtl.dailyGoal.value / 6, // Khoảng cách giữa các đường ngang
        getDrawingHorizontalLine: (value) {
          if (value == 2300) {
            return FlLine(
              color: Colors.white,
              strokeWidth: 1,
              dashArray: [5, 5], // Tạo đường nét đứt
            );
          }
          return FlLine(
            color: Colors.grey.withOpacity(0.5),
            strokeWidth: 1,
            dashArray: [5, 5], // Tạo đường nét đứt
          );
        },
        drawVerticalLine: false,
      );

  BarTouchData get barTouchData => BarTouchData(
        enabled: false,
        touchTooltipData: BarTouchTooltipData(
          getTooltipColor: (group) => Colors.transparent,
          tooltipPadding: EdgeInsets.zero,
          tooltipMargin: 8,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              rod.toY.toStringAsFixed(1),
              GlobalTextStyles.font10w400ColorWhite,
            );
          },
        ),
      );

  Widget getTitles(double value, TitleMeta meta) {
    final style = GlobalTextStyles.font10w400ColorNewtral;
    String text;
    switch (value.toInt()) {
      case 0:
        text = 'S';
        break;
      case 1:
        text = 'M';
        break;
      case 2:
        text = 'T';
        break;
      case 3:
        text = 'W';
        break;
      case 4:
        text = 'T';
        break;
      case 5:
        text = 'F';
        break;
      case 6:
        text = 'S';
        break;
      default:
        text = '';
        break;
    }
    return SideTitleWidget(
      meta: meta,
      space: 4,
      child: Text(text, style: style),
    );
  }

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: getTitles,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            interval: (waterCtl.dailyGoal.value / 1000) / 6,
            reservedSize: 38,
            getTitlesWidget: (value, meta) {
              final style = GlobalTextStyles.font10w400ColorNewtral;
              return SideTitleWidget(
                meta: meta,
                child: value <= waterCtl.dailyGoal.value / 1000
                    ? Text(
                        value.toStringAsFixed(1), textAlign: TextAlign.start,
                        style: style,
                        overflow: TextOverflow.visible, // Ngăn chữ bị cắt
                      )
                    : SizedBox.shrink(),
              );
            },
            showTitles: true,
          ),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  FlBorderData get borderData => FlBorderData(
        show: false,
      );

  List<BarChartGroupData> get barGroups => [
        BarChartGroupData(
          x: 0,
          barRods: [
            BarChartRodData(
                width: 12.0,
                toY: getTotalDay(
                    historyCtl.startOfWeekSelect.value.add(6.days).day),
                gradient: GlobalColors.linearPrimary2,
                borderRadius: BorderRadius.circular(2.0))
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 1,
          barRods: [
            BarChartRodData(
                width: 12.0,
                toY: getTotalDay(historyCtl.startOfWeekSelect.value.day),
                gradient: GlobalColors.linearPrimary2,
                borderRadius: BorderRadius.circular(2.0))
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 2,
          barRods: [
            BarChartRodData(
                width: 12.0,
                toY: getTotalDay(
                    historyCtl.startOfWeekSelect.value.add(1.days).day),
                gradient: GlobalColors.linearPrimary2,
                borderRadius: BorderRadius.circular(2.0))
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 3,
          barRods: [
            BarChartRodData(
                width: 12.0,
                toY: getTotalDay(
                    historyCtl.startOfWeekSelect.value.add(2.days).day),
                gradient: GlobalColors.linearPrimary2,
                borderRadius: BorderRadius.circular(2.0))
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 4,
          barRods: [
            BarChartRodData(
                width: 12.0,
                toY: getTotalDay(
                    historyCtl.startOfWeekSelect.value.add(3.days).day),
                gradient: GlobalColors.linearPrimary2,
                borderRadius: BorderRadius.circular(2.0))
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 5,
          barRods: [
            BarChartRodData(
                width: 12.0,
                toY: getTotalDay(
                    historyCtl.startOfWeekSelect.value.add(4.days).day),
                gradient: GlobalColors.linearPrimary2,
                borderRadius: BorderRadius.circular(2.0))
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 6,
          barRods: [
            BarChartRodData(
                width: 12.0,
                toY: getTotalDay(
                    historyCtl.startOfWeekSelect.value.add(5.days).day),
                gradient: GlobalColors.linearPrimary2,
                borderRadius: BorderRadius.circular(2.0))
          ],
          showingTooltipIndicators: [0],
        ),
      ];

  double getTotalDay(int day) {
    double total = 0;
    for (var element in historyCtl.listHistoryWeek) {
      if (DateTime.parse(element.dateTime!).day == day) total += element.ml!;
    }
    print("total $total");
    return total / 1000;
  }
}
