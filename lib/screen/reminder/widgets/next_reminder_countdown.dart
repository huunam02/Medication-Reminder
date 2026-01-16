import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '/lang/l.dart';
import '/config/global_text_style.dart';
import '/config/global_color.dart';
import '../controller/reminder_controller.dart';

class NextReminderCountdown extends StatefulWidget {
  const NextReminderCountdown({super.key});

  @override
  State<NextReminderCountdown> createState() => _NextReminderCountdownState();
}

class _NextReminderCountdownState extends State<NextReminderCountdown> {
  final reminderCtl = Get.find<ReminderController>();
  Timer? _timer;
  String _timeLeft = "";

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _calculateTimeLeft();
    });
    _calculateTimeLeft(); // Initial call
  }

  void _calculateTimeLeft() {
    final reminder = reminderCtl.nextReminderObj.value;
    if (reminder == null) {
      if (_timeLeft.isNotEmpty) {
        setState(() {
          _timeLeft = "";
        });
      }
      return;
    }

    DateTime now = DateTime.now();
    DateTime time = DateTime.parse(reminder.dateTime);
    DateTime nextTime =
        DateTime(now.year, now.month, now.day, time.hour, time.minute);

    if (nextTime.isBefore(now)) {
      nextTime = nextTime.add(const Duration(days: 1));
    }

    Duration diff = nextTime.difference(now);

    if (diff.isNegative) {
      reminderCtl.checkNextReminder(); // Force check
      setState(() {
        _timeLeft = "00:00:00";
      });
    } else {
      String twoDigits(int n) => n.toString().padLeft(2, "0");
      String hours = twoDigits(diff.inHours);
      String minutes = twoDigits(diff.inMinutes.remainder(60));
      String seconds = twoDigits(diff.inSeconds.remainder(60));
      setState(() {
        _timeLeft = "$hours:$minutes:$seconds";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (reminderCtl.nextReminderObj.value == null) {
        return const SizedBox.shrink();
      }
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          gradient: GlobalColors.linearPrimary2,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              L.nextDoseIn.tr,
              style: GlobalTextStyles.font14w400ColorWhite.copyWith(
                color: Colors.white.withOpacity(0.9),
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              _timeLeft,
              style: GlobalTextStyles.font16w500ColorWhite.copyWith(
                fontSize: 32.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    });
  }
}
