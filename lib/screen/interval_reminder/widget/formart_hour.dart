import '/config/global_text_style.dart';
import '/lang/l.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FomartHour extends StatelessWidget {
  const FomartHour({super.key, required this.minute});
  final int minute;
  @override
  Widget build(BuildContext context) {
    return Text(
      fomart(minute),
      style: GlobalTextStyles.font16w600ColorBlack,
    );
  }

  String fomart(int minute) {
    if (minute < 60) {
      return "$minute mins";
    }
    if (minute == 60) {
      return "1 hour";
    }
    int hour = minute ~/ 60;
    int remainingMinutes = minute % 60;

    return "$hour hour : ${remainingMinutes > 9 ? remainingMinutes : remainingMinutes.toString().padLeft(2, "0")} mins";
  }
}

class FomartHourInterval extends StatelessWidget {
  const FomartHourInterval({super.key, required this.time});
  final String time;
  @override
  Widget build(BuildContext context) {
    return Text(
      "${DateTime.parse(time).hour}:${DateTime.parse(time).minute > 9 ? DateTime.parse(time).minute : DateTime.parse(time).minute.toString().padLeft(2, "0")}",
      style: GlobalTextStyles.font16w600ColorBlack,
    );
  }
}

class FomartHourFont12W400Newtral extends StatelessWidget {
  const FomartHourFont12W400Newtral({super.key, required this.minute});
  final int minute;
  @override
  Widget build(BuildContext context) {
    return Text(
      fomart(minute),
      style: GlobalTextStyles.font12w400ColorNewtral,
    );
  }

  String fomart(int minute) {
    if (minute < 60) {
      return "($minute${L.mins.tr} ${L.left.tr})";
    }
    if (minute == 60) {
      return "(1 ${L.hour.tr} ${L.left.tr})";
    }

    int hour = minute ~/ 60;
    int remainingMinutes = minute % 60;

    return "(${hour}h ${remainingMinutes > 9 ? remainingMinutes : remainingMinutes.toString().padLeft(2, "0")}${L.mins.tr} ${L.left.tr})";
  }
}
