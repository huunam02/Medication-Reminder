import '/config/global_color.dart';
import '/config/global_text_style.dart';
import '/lang/l.dart';
import '/screen/interval_reminder/widget/formart_hour.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomNextTime extends StatelessWidget {
  const CustomNextTime({super.key, required this.time, required this.mode});
  final String time;
  final String mode;
  @override
  Widget build(BuildContext context) {
    return Text(
      time == "OFF" || mode.isEmpty
          ? "OFF"
          : "${DateTime.parse(time).hour}:${DateTime.parse(time).minute > 9 ? DateTime.parse(time).minute : DateTime.parse(time).minute.toString().padLeft(2, "0")}   ",
      style: GlobalTextStyles.font18w600ColorWhite
          .copyWith(color: GlobalColors.colorLastLinear),
    );
  }
}

class CustomNextTimeReminder extends StatelessWidget {
  const CustomNextTimeReminder({super.key, required this.time});
  final String time;
  @override
  Widget build(BuildContext context) {
    DateTime temp = DateTime.utc(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        DateTime.parse(time).hour,
        DateTime.parse(time).minute);

    return Row(
      children: [
        Text(time.isEmpty ? "" : "${L.next.tr}: ",
            style: GlobalTextStyles.font12w400ColorNewtral),
        Text(
          time.isEmpty
              ? ""
              : "${DateTime.parse(time).hour}:${DateTime.parse(time).minute > 9 ? DateTime.parse(time).minute : DateTime.parse(time).minute.toString().padLeft(2, "0")}",
          style: GlobalTextStyles.font12w400ColorBlack
              .copyWith(color: GlobalColors.colorLastLinear),
        ),
        FomartHourFont12W400Newtral(
            minute: temp.isAfter(DateTime.now().toUtc().add(7.hours))
                ? temp.difference(DateTime.now().toUtc().add(7.hours)).inMinutes
                : 1440 -
                    temp
                        .difference(DateTime.now().toUtc().add(7.hours))
                        .inMinutes
                        .abs())
      ],
    );
  }
}
