import '/lang/l.dart';
import '/screen/interval_reminder/controller/interval_reminder_controller.dart';
import '/screen/navbar/navbar.dart';
import '/screen/standard_reminder/controller/standard_reminder_controller.dart';
import '/screen/water/controller/warter_controller.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/material.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> onDidReceiveNotification(
      NotificationResponse notificationResponse) async {
    final waterCtl = Get.find<WarterController>();
    waterCtl.checkNextReminder();
    if (waterCtl.reminderMode.value == "interval") {
      final intervalCtl = Get.find<IntervalReminderController>();
      intervalCtl.checkNextReminder();
    } else {
      final standardCtl = Get.find<StandardReminderController>();
      standardCtl.checkNextReminder();
    }
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
  }

  static Future<void> scheduleDailyNotification(int id, TimeOfDay time) async {
    final now = DateTime.now();
    final scheduledDate =
        DateTime(now.year, now.month, now.day, time.hour, time.minute);

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

  static Future<void> cancelNotification(int id) async {
    debugPrint("Destroy notification succes id: $id");
    await flutterLocalNotificationsPlugin.cancel(id);
    await flutterLocalNotificationsPlugin.pendingNotificationRequests();
  }

  static Future<void> cancelAllNotification() async {
    debugPrint("Destroy all notification succes ");
    await flutterLocalNotificationsPlugin.cancelAll();
    await flutterLocalNotificationsPlugin.pendingNotificationRequests();
  }
}
