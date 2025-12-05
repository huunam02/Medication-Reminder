
import '/config/global_color.dart';
import '/config/global_sadow.dart';
import '/config/global_text_style.dart';
import '/lang/l.dart';
import '/model/reminder.dart';
import '/screen/standard_reminder/controller/standard_reminder_controller.dart';
import '/screen/water/controller/warter_controller.dart';
import '/widget/appbar_base.dart';
import '/widget/body_background.dart';
import '/widget/fomart_time.dart';
import '/widget/gradient_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'widgets/bottomsheet_time_add_standard.dart';
import 'widgets/bottomsheet_time_edit_standard.dart';

class StandardReminderScreen extends StatefulWidget {
  const StandardReminderScreen({super.key});

  @override
  State<StandardReminderScreen> createState() => _StandardReminderScreenState();
}

class _StandardReminderScreenState extends State<StandardReminderScreen> {
  final standardReminderCtl = Get.find<StandardReminderController>();
  @override
  void initState() {
    super.initState();
    standardReminderCtl.loadData();
  }

  @override
  Widget build(BuildContext context) {
    return BodyCustom(
      isShowBgImages: false,
      appbar: AppbarBase(
        leading: _buildLeading(),
        actions: _buildAction,
        title: _buildTitle(),
        centerTitle: true,
      ),
      child: Column(
        children: [
          20.verticalSpace,
          _buildDivider(),
          Expanded(
              child: Obx(
            () => standardReminderCtl.isLoad.value == false
                ? ListView.separated(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                    separatorBuilder: (context, index) => SizedBox(
                      height: 16.0,
                    ),
                    itemCount: standardReminderCtl.listReminder.length,
                    itemBuilder: (context, index) {
                      final reminder = standardReminderCtl.listReminder[index];
                      DateTime dateTime = DateTime.parse(reminder.dateTime);
                      return _buildItem(dateTime, context, reminder);
                    },
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  ),
          )),
      
        ],
      ),
    );
  }

  Container _buildDivider() {
    return Container(
      height: 0.5,
      width: double.infinity,
      color: Colors.grey,
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
                            L.dailyReminderAt.tr,
                            style: GlobalTextStyles.font16w600ColorBlack,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            reminder.title ?? "",
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
                                onClickSave: (title) {
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
                                  );
                                  standardReminderCtl
                                      .updateTimeReminder(reminderNew);
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
                standardReminderCtl.updateOnReminder(reminder);
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
          L.standardReminder.tr,
          gradient: GlobalColors.linearPrimary2,
          style: GlobalTextStyles.font20w600ColorWhite,
        ),
        Obx(
          () => standardReminderCtl.nextReminder.value.isNotEmpty
              ? CustomNextTimeReminder(
                  time: standardReminderCtl.nextReminder.value)
              : SizedBox(),
        )
      ],
    );
  }

  List<Widget> get _buildAction {
    return [
      //  Obx(
      //         () => GestureDetector(
      //           onTap: () {
      //             checkPermission(() {
      //               standardReminderCtl.onAll.value =
      //                   !standardReminderCtl.onAll.value;
      //               if (standardReminderCtl.onAll.value) {
      //                 standardReminderCtl.clickOnAll();
      //               } else {
      //                 standardReminderCtl.clickOffAll();
      //               }
      //             });
      //           },
      //           child: Image.asset(
      //             standardReminderCtl.onAll.value
      //                 ? "assets/images/switch_on.png"
      //                 : "assets/images/switch_off.png",
      //             width: 40,
      //             height: 24.0,
      //           ),
      //         ),
      //       )
      PopupMenuButton(
          menuPadding: EdgeInsets.all(8.0),
          borderRadius: BorderRadius.circular(16.0),
          color: Colors.white,
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(L.addReminder.tr,
                        style: GlobalTextStyles.font16w600ColorBlack),
                    16.horizontalSpace,
                    Icon(Icons.add, size: 32.w)
                  ],
                ),
                onTap: () {
                  int hour = 12;
                  int minute = 30;
                  String title = "";

                  showModalBottomSheet(
                    context: context,
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
                          );

                          standardReminderCtl.addReminder(newReminder);
                        },
                        onChangeTitle: (value) {
                          title = value;
                        },
                      );
                    },
                  );
                },
              ),
              PopupMenuItem(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(L.allReminder.tr,
                        style: GlobalTextStyles.font16w600ColorBlack),
                    16.horizontalSpace,
                    Obx(
                      () => Image.asset(
                        standardReminderCtl.onAll.value
                            ? "assets/images/switch_on.png"
                            : "assets/images/switch_off.png",
                        width: 40,
                        height: 24.0,
                      ),
                    )
                  ],
                ),
                onTap: () {
                  checkPermission(() {
                    standardReminderCtl.onAll.value =
                        !standardReminderCtl.onAll.value;
                    if (standardReminderCtl.onAll.value) {
                      standardReminderCtl.clickOnAll();
                    } else {
                      standardReminderCtl.clickOffAll();
                    }
                  });
                },
              ),
            ];
          }),
      16.horizontalSpace
    ];
  }

  Center _buildLeading() {
    return Center(
      child: GestureDetector(
        onTap: () {
          final waterCtl = Get.find<WarterController>();
          if (waterCtl.reminderMode.value == "standard") {
            waterCtl.checkNextReminder();
          }
          Get.back();
        },
        child: SvgPicture.asset("assets/icons/back.svg",
            color: Colors.black, width: 24.0, height: 24.0),
      ),
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
