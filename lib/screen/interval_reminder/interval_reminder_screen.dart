import '/config/global_color.dart';
import '/config/global_sadow.dart';
import '/config/global_text_style.dart';
import '/lang/l.dart';
import '/model/reminder.dart';
import '/screen/interval_reminder/controller/interval_reminder_controller.dart';
import '/screen/interval_reminder/widget/bottomsheet_time_edit.dart';
import '/screen/interval_reminder/widget/formart_hour.dart';
import '/screen/water/controller/warter_controller.dart';
import '/widget/appbar_base.dart';
import '/widget/body_background.dart';
import '/widget/bottomsheet_time_edit.dart';
import '/widget/fomart_time.dart';
import '/widget/gradient_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class IntervalReminderScreen extends StatefulWidget {
  const IntervalReminderScreen({super.key});

  @override
  State<IntervalReminderScreen> createState() => _IntervalReminderScreenState();
}

class _IntervalReminderScreenState extends State<IntervalReminderScreen> {
  final intervalReminderCtl = Get.find<IntervalReminderController>();

  @override
  Widget build(BuildContext context) {
    return BodyCustom(
      edgeInsetsPadding: EdgeInsets.symmetric(vertical: 16.0),
      isShowBgImages: false,
      appbar: AppbarBase(
        leading: _buildLeading(),
        title: _buildTitle(),
        actions: _buildAction,
      ),
      child: SafeArea(
        child: Column(
          children: [
            _buildDivider(),
            20.verticalSpace,
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              margin: EdgeInsets.symmetric(horizontal: 16.0),
              height: 180.h,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  color: GlobalColors.container1,
                  boxShadow: GlobalShadow.primary),
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          L.interval.tr,
                          style: GlobalTextStyles.font14w400ColorBlack,
                        ),
                        Spacer(),
                        Obx(
                          () => FomartHour(
                              minute: intervalReminderCtl.intervalTime.value),
                        ),
                        10.horizontalSpace,
                        GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    int hour = intervalReminderCtl
                                            .intervalTime.value ~/
                                        60;
                                    int minute =
                                        intervalReminderCtl.intervalTime.value %
                                            60;
                                    return BottomsheetIntervalTimeEdit(
                                        title: L.interval.tr,
                                        onClickSave: () {
                                          intervalReminderCtl
                                              .changeTimeInterval(hour, minute);
                                        },
                                        onChangeHour: (value) {
                                          hour = value;
                                        },
                                        onChangeMinute: (value) {
                                          minute = value;
                                        },
                                        defaultHour: hour,
                                        defaultMinute: minute);
                                  });
                            },
                            child: SvgPicture.asset("assets/icons/pen.svg"))
                      ],
                    ),
                  ),
                  Container(
                    height: 0.5,
                    width: double.infinity,
                    color: GlobalColors.container2,
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          L.bedTime.tr,
                          style: GlobalTextStyles.font14w400ColorBlack,
                        ),
                        Spacer(),
                        Obx(
                          () => FomartHourInterval(
                              time: intervalReminderCtl.timeSleep.value),
                        ),
                        4.horizontalSpace,
                        GestureDetector(
                          onTap: () {
                            DateTime dateTime = DateTime.parse(
                                intervalReminderCtl.timeSleep.value);
                            showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  int hour = dateTime.hour;
                                  int minute = dateTime.minute;
                                  return BottomsheetTimeEdit(
                                      title: L.sleepStart.tr,
                                      onClickSave: () {
                                        if (hour != dateTime.hour ||
                                            minute != dateTime.minute) {
                                          intervalReminderCtl.changeSleepTime(
                                              TimeOfDay(
                                                  hour: hour, minute: minute));
                                        }
                                      },
                                      onChangeHour: (value) {
                                        hour = value;
                                      },
                                      onChangeMinute: (value) {
                                        minute = value;
                                      },
                                      defaultHour: dateTime.hour,
                                      defaultMinute: dateTime.minute);
                                });
                          },
                          child: SvgPicture.asset("assets/icons/pen.svg",
                              height: 18.0, width: 18.0),
                        ),
                        Text(
                          " ${L.to.tr} ",
                          style: GlobalTextStyles.font14w400ColorBlack,
                        ),
                        Obx(
                          () => FomartHourInterval(
                              time: intervalReminderCtl.timeWakeUp.value),
                        ),
                        4.horizontalSpace,
                        GestureDetector(
                          onTap: () {
                            DateTime dateTime = DateTime.parse(
                                intervalReminderCtl.timeWakeUp.value);
                            showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  int hour = dateTime.hour;
                                  int minute = dateTime.minute;
                                  return BottomsheetTimeEdit(
                                      title: L.sleepEnTime.tr,
                                      onClickSave: () {
                                        if (hour != dateTime.hour ||
                                            minute != dateTime.minute) {
                                          intervalReminderCtl.changeWakeUpTime(
                                              TimeOfDay(
                                                  hour: hour, minute: minute));
                                        }
                                      },
                                      onChangeHour: (value) {
                                        hour = value;
                                      },
                                      onChangeMinute: (value) {
                                        minute = value;
                                      },
                                      defaultHour: dateTime.hour,
                                      defaultMinute: dateTime.minute);
                                });
                          },
                          child: SvgPicture.asset("assets/icons/pen.svg",
                              height: 18.0, width: 18.0),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            20.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                L.intervalDes.tr,
                style: GlobalTextStyles.font14w600ColorBlack,
              ),
            ),
            20.verticalSpace,
            Expanded(
                child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Obx(
                () => Wrap(
                  runSpacing: 16.0,
                  children: List.generate(
                    intervalReminderCtl.listReminder.length,
                    (index) {
                      Reminder reminder =
                          intervalReminderCtl.listReminder[index];
                      return Text(
                        "${DateTime.parse(reminder.dateTime).hour}:${DateTime.parse(reminder.dateTime).minute > 9 ? DateTime.parse(reminder.dateTime).minute : DateTime.parse(reminder.dateTime).minute.toString().padLeft(2, "0")}   ",
                        style: GlobalTextStyles.font14w400ColorBlack,
                      );
                    },
                  ),
                ),
              ),
            )),
         
          ],
        ),
      ),
    );
  }

  List<Widget> get _buildAction {
    return [
      GestureDetector(
        onTap: () {
          checkPermission(() {
            intervalReminderCtl.setChangeOnReminder();
          });
        },
        child: Obx(
          () => intervalReminderCtl.isOnIntervalReminder.value
              ? Image.asset(
                  "assets/images/switch_on.png",
                  width: 40,
                  height: 24.0,
                )
              : Image.asset(
                  "assets/images/switch_off.png",
                  width: 40,
                  height: 24.0,
                ),
        ),
      ),
      16.horizontalSpace
    ];
  }

  Center _buildLeading() {
    return Center(
      child: GestureDetector(
        onTap: () {
          final waterCtl = Get.find<WarterController>();
          if (waterCtl.reminderMode.value == "interval") {
            waterCtl.checkNextReminder();
          }
          Get.back();
        },
        child: SvgPicture.asset("assets/icons/back.svg",
            color: Colors.black, width: 24.0, height: 24.0),
      ),
    );
  }

  Column _buildTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        GradientText(
          L.intervalReminder.tr,
          gradient: GlobalColors.linearPrimary2,
          style: GlobalTextStyles.font20w600ColorWhite,
        ),
        Obx(
          () => intervalReminderCtl.nextReminder.value.isNotEmpty
              ? CustomNextTimeReminder(
                  time: intervalReminderCtl.nextReminder.value)
              : SizedBox(),
        ),
      ],
    );
  }

  Container _buildDivider() {
    return Container(
      height: 0.5,
      width: double.infinity,
      color: Colors.grey,
    );
  }

  void checkPermission(Function onpress) async {
    final permissionStatus = await Permission.notification.status;
    if (permissionStatus.isGranted) {
      onpress();
    } else if (permissionStatus.isDenied) {
      await Permission.notification.request();
    } else if (permissionStatus.isPermanentlyDenied) {
      openAppSettings();
    }
  }
}
