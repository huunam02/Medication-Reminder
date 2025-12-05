import '/config/global_color.dart';
import '/config/global_text_style.dart';
import '/screen/history/controller/history_controller.dart';
import '/screen/water/controller/warter_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomChartMonth extends StatefulWidget {
  const CustomChartMonth({super.key});

  @override
  State<StatefulWidget> createState() => CustomChartMonthState();
}

class CustomChartMonthState extends State<CustomChartMonth> {
  final historyCtl = Get.find<HistoryController>();
  final waterCtl = Get.find<WarterController>();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AspectRatio(
        aspectRatio: 1,
        child: BarChart(
          BarChartData(
              barTouchData: barTouchData,
              titlesData: titlesData,
              borderData: borderData,
              barGroups: barGroups,
              gridData: gridData,
              alignment: BarChartAlignment.start,
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
        horizontalInterval: (waterCtl.dailyGoal.value / 1000) /
            6, // Khoảng cách giữa các đường ngang
        getDrawingHorizontalLine: (value) {
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

    return SideTitleWidget(
      meta: meta,
      space: 4,
      child: Text(value.toInt().toString(), style: style),
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
            reservedSize: 34,
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

  List<BarChartGroupData> get barGroups => List.generate(
        historyCtl.listDayOfMonth.length,
        (index) => BarChartGroupData(
          x: historyCtl.listDayOfMonth[index],
          barRods: [
            BarChartRodData(
                width: 4.0,
                toY: getTotalDay(historyCtl.listDayOfMonth[index]),
                gradient: GlobalColors.linearPrimary2,
                borderRadius: BorderRadius.circular(2.0))
          ],
          showingTooltipIndicators: [0],
        ),
      ).toList();

  double getTotalDay(int day) {
    double total = 0;
    for (var element in historyCtl.listHistoryMonth) {
      if (DateTime.parse(element.dateTime!).day == day) total += element.ml!;
    }

    return total / 1000;
  }
}
