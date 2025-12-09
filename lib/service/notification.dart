import '../screen/reminder/controller/reminder_controller.dart';

import '/lang/l.dart';
import '/screen/navbar/navbar.dart';
import '../screen/medicine/controller/medicine_controller.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/material.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> onDidReceiveNotification(
      NotificationResponse notificationResponse) async {
    final medicineCtl = Get.find<MedicineController>();
    medicineCtl.checkNextReminder();

    final standardCtl = Get.find<ReminderController>();
    standardCtl.checkNextReminder();

    Get.offAll(NavbarScreen());
  }

  static Future<void> init() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings("@mipmap/ic_launcher");
    const DarwinInitializationSettings iOSInitializationSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true, // Yêu cầu quyền thông báo
      requestBadgePermission: true, // Yêu cầu quyền thông báo biểu tượng
      requestSoundPermission: true, // Yêu cầu quyền âm thanh
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
      iOS: iOSInitializationSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotification,
        onDidReceiveBackgroundNotificationResponse: onDidReceiveNotification);

    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    await androidImplementation?.requestNotificationsPermission();
    await androidImplementation?.requestExactAlarmsPermission();
  }

  static Future<void> scheduleDailyNotification(int id, TimeOfDay time) async {
    final now = DateTime.now();
    var scheduledDate =
        DateTime(now.year, now.month, now.day, time.hour, time.minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      L.notiTitle.tr,
      L.notiDes.tr,
      tz.TZDateTime.from(scheduledDate, tz.local),
      const NotificationDetails(
        iOS: DarwinNotificationDetails(),
        android: AndroidNotificationDetails(
          "REMINDER",
          'Reminder Notifications',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
      ),
      matchDateTimeComponents: DateTimeComponents.time,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
    debugPrint("Set notification success at $time and id: $id");
  }

  static Future<void> scheduleWeeklyNotification(
      int id, TimeOfDay time, List<int> days) async {
    for (int day in days) {
      // 1 = Mon, 7 = Sun
      final now = DateTime.now();
      var scheduledDate =
          DateTime(now.year, now.month, now.day, time.hour, time.minute);

      // Find the next occurrence of this day
      while (scheduledDate.weekday != day || scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }

      await flutterLocalNotificationsPlugin.zonedSchedule(
        id * 10 + day,
        L.notiTitle.tr,
        L.notiDes.tr,
        tz.TZDateTime.from(scheduledDate, tz.local),
        const NotificationDetails(
          iOS: DarwinNotificationDetails(),
          android: AndroidNotificationDetails(
            "REMINDER",
            'Reminder Notifications',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
        ),
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
      debugPrint(
          "Set weekly notification success at $time, day $day, id: ${id * 10 + day}");
    }
  }

  static Future<void> cancelNotification(int id) async {
    debugPrint("Destroy notification succes id: $id");
    await flutterLocalNotificationsPlugin.cancel(id);
    // Cancel potential weekly notifications
    for (int i = 1; i <= 7; i++) {
      await flutterLocalNotificationsPlugin.cancel(id * 10 + i);
    }
    await flutterLocalNotificationsPlugin.pendingNotificationRequests();
  }

  static Future<void> cancelAllNotification() async {
    debugPrint("Destroy all notification succes ");
    await flutterLocalNotificationsPlugin.cancelAll();
    await flutterLocalNotificationsPlugin.pendingNotificationRequests();
  }
}
