import '/config/global_color.dart';
import '/config/global_sadow.dart';
import '/config/global_text_style.dart';
import '/lang/l.dart';
import '/model/reminder.dart';
import 'controller/reminder_controller.dart';
import '/widget/appbar_base.dart';
import '/widget/body_background.dart';
import '/widget/fomart_time.dart';
import '/widget/gradient_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import 'widgets/bottomsheet_time_edit_standard.dart';
import 'widgets/bottomsheet_time_add_standard.dart';
import 'widgets/next_reminder_countdown.dart';
import '/widget/dialog_delete_record.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  final reminderCtl = Get.find<ReminderController>();
  @override
  void initState() {
    super.initState();
    reminderCtl.loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => BodyCustom(
        floatingActionButton: reminderCtl.listReminder.isNotEmpty
            ? FloatingActionButton(
                shape: const CircleBorder(),
                onPressed: () {
                  _showAddReminderBottomSheet(context);
                },
                backgroundColor: GlobalColors.colorLastLinear,
                child: const Icon(Icons.add, color: Colors.white),
              )
            : null,
        isShowBgImages: false,
        appbar: AppbarBase(
          title: _buildTitle(),
          centerTitle: true,
        ),
        child: Column(
          children: [
            const NextReminderCountdown(),
            Expanded(
                child: reminderCtl.isLoad.value == false
                    ? reminderCtl.listReminder.isEmpty
                        ? Center(
                            child: GestureDetector(
                              onTap: () {
                                _showAddReminderBottomSheet(context);
                              },
                              child: Container(
                                height: 56.h,
                                width: 240.w,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    gradient: GlobalColors.linearPrimary2,
                                    borderRadius: BorderRadius.circular(28.0)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      "assets/icons/add.svg",
                                      height: 24.0,
                                      width: 24.0,
                                    ),
                                    SizedBox(
                                      width: 12.0,
                                    ),
                                    Text(
                                      L.addReminder.tr,
                                      style:
                                          GlobalTextStyles.font16w600ColorWhite,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : ListView.separated(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 16.0),
                            separatorBuilder: (context, index) => SizedBox(
                              height: 16.0,
                            ),
                            itemCount: reminderCtl.listReminder.length,
                            itemBuilder: (context, index) {
                              final reminder = reminderCtl.listReminder[index];
                              DateTime dateTime =
                                  DateTime.parse(reminder.dateTime);
                              return _buildItem(dateTime, context, reminder);
                            },
                          )
                    : Center(
                        child: CircularProgressIndicator(),
                      )),
          ],
        ),
      ),
    );
  }

  void _showAddReminderBottomSheet(BuildContext context) {
    int hour = 12;
    int minute = 30;
    String title = "";
    String quantity = "";
    String repeatDays = "1,2,3,4,5,6,7";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return BottomsheetTimeAddStandard(
          onChangeHour: (value) {
            hour = value;
          },
          onChangeMinute: (value) {
            minute = value;
          },
          defaultHour: 12,
          defaultMinute: 30,
          onClickSave: () {
            final Reminder newReminder = Reminder(
              title: title,
              dateTime: DateTime.utc(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day,
                hour,
                minute,
              ).toString(),
              isOn: true,
              quantity: int.tryParse(quantity),
              repeatDays: repeatDays,
            );

            reminderCtl.addReminder(newReminder);
          },
          onChangeTitle: (value) {
            title = value;
          },
          onChangeQuantity: (value) {
            quantity = value;
          },
          onChangeRepeatDays: (value) {
            repeatDays = value;
          },
        );
      },
    );
  }

  Container _buildItem(
      DateTime dateTime, BuildContext context, Reminder reminder) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
      decoration: BoxDecoration(
        boxShadow: GlobalShadow.primary,
        borderRadius: BorderRadius.circular(16.0),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            reminder.title ?? "",
                            style: GlobalTextStyles.font16w600ColorBlack,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            reminder.quantity != null
                                ? "${reminder.quantity} ${reminder.quantity == 1 ? L.pillUnit.tr : L.pillUnits.tr}"
                                : "",
                            style: GlobalTextStyles.font14w400ColorNewtral,
                          ),
                        ],
                      ),
                    ),
                    10.horizontalSpace,
                    Text(
                      "${dateTime.hour}:${dateTime.minute > 9 ? dateTime.minute : dateTime.minute.toString().padLeft(2, "0")}  ",
                      style: GlobalTextStyles.font16w600ColorBlack,
                    ),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              int hour = dateTime.hour;
                              int minute = dateTime.minute;
                              return BottomsheetTimeEditStandard(
                                reminder: reminder,
                                onClickDelete: () {
                                  Get.back(); // Close bottom sheet
                                  _showDeleteConfirmDialog(context, reminder);
                                },
                                onClickSave: (title, quantity, repeatDays) {
                                  DateTime dateTimeUpdate = DateTime.utc(
                                    dateTime.year,
                                    dateTime.month,
                                    dateTime.day,
                                    hour,
                                    minute,
                                    0,
                                  );
                                  final reminderNew = reminder.copyWith(
                                    dateTime: dateTimeUpdate.toString(),
                                    title: title,
                                    quantity: int.tryParse(quantity),
                                    repeatDays: repeatDays,
                                  );
                                  reminderCtl.updateTimeReminder(reminderNew);
                                },
                                onChangeHour: (value) {
                                  hour = value;
                                },
                                onChangeMinute: (value) {
                                  minute = value;
                                },
                                defaultHour: dateTime.hour,
                                defaultMinute: dateTime.minute,
                              );
                            });
                      },
                      child: SvgPicture.asset("assets/icons/pen.svg",
                          width: 18.0, height: 18.0),
                    ),
                  ],
                ),
              ],
            ),
          ),
          10.horizontalSpace,
          GestureDetector(
            onTap: () {
              checkPermission(() {
                reminderCtl.updateOnReminder(reminder);
              });
            },
            child: Image.asset(
              reminder.isOn
                  ? "assets/images/switch_on.png"
                  : "assets/images/switch_off.png",
              width: 40,
              height: 24.0,
            ),
          )
        ],
      ),
    );
  }

  Column _buildTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        GradientText(
          L.reminder.tr,
          gradient: GlobalColors.linearPrimary2,
          style: GlobalTextStyles.font20w600ColorWhite,
        ),
        Obx(
          () => reminderCtl.nextReminder.value.isNotEmpty
              ? CustomNextTimeReminder(time: reminderCtl.nextReminder.value)
              : SizedBox(),
        )
      ],
    );
  }

  void _showDeleteConfirmDialog(BuildContext context, Reminder reminder) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: 16),
          child: DialogDeleteRecord(
            ontap: () {
              Get.back(); // Close dialog
              reminderCtl.deleteReminder(reminder);
            },
          ),
        );
      },
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
