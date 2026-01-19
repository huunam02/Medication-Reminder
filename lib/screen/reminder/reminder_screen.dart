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
        edgeInsetsPadding: EdgeInsets.symmetric(horizontal: 20.w),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: reminderCtl.isLoad.value
              ? const Center(
                  key: ValueKey("loading"),
                  child: CircularProgressIndicator(),
                )
              : _buildScrollableLayout(context),
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

  Widget _buildScrollableLayout(BuildContext context) {
    final hasReminders = reminderCtl.listReminder.isNotEmpty;
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(child: 24.verticalSpace),
        SliverToBoxAdapter(child: _buildOverviewCard()),
        SliverToBoxAdapter(child: 16.verticalSpace),
        SliverToBoxAdapter(
          child: NextReminderCountdown(
            margin: EdgeInsets.zero,
          ),
        ),
        SliverToBoxAdapter(child: 24.verticalSpace),
        SliverToBoxAdapter(
          child: _buildSectionHeader(context, hasReminders),
        ),
        if (hasReminders)
          SliverPadding(
            padding: EdgeInsets.only(top: 12.h, bottom: 32.h),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final reminder = reminderCtl.listReminder[index];
                  return Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: _buildReminderCard(context, reminder),
                  );
                },
                childCount: reminderCtl.listReminder.length,
              ),
            ),
          )
        else
          SliverFillRemaining(
            hasScrollBody: false,
            child: _buildEmptyState(context),
          ),
      ],
    );
  }

  Widget _buildReminderCard(BuildContext context, Reminder reminder) {
    final dateTime = DateTime.parse(reminder.dateTime);
    final isActive = reminder.isOn;
    final primaryTextColor = isActive ? Colors.white : Colors.black87;
    final secondaryTextColor = isActive
        ? Colors.white.withOpacity(0.9)
        : Colors.black.withOpacity(0.65);
    final repeatLabel = _formatRepeatDays(reminder.repeatDays);
    final quantityLabel = reminder.quantity != null
        ? "${reminder.quantity} ${reminder.quantity == 1 ? L.pillUnit.tr : L.pillUnits.tr}"
        : L.medicineFallback.tr;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
      decoration: BoxDecoration(
        gradient: isActive ? GlobalColors.linearPrimary2 : null,
        color: isActive ? null : Colors.white,
        borderRadius: BorderRadius.circular(28.r),
        border: Border.all(
          color: isActive ? Colors.transparent : Colors.black.withOpacity(0.05),
        ),
        boxShadow: [
          BoxShadow(
            color: (isActive
                    ? GlobalColors.linearPrimary2.colors.last
                    : Colors.black)
                .withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTimeBadge(context, dateTime, isActive),
              16.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reminder.title?.isNotEmpty == true
                          ? reminder.title!
                          : L.medicineFallback.tr,
                      style: GlobalTextStyles.font16w600ColorBlack.copyWith(
                        color: primaryTextColor,
                      ),
                    ),
                    4.verticalSpace,
                    Text(
                      quantityLabel,
                      style: GlobalTextStyles.font14w400ColorNewtral.copyWith(
                        color: secondaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  IconButton(
                    onPressed: () =>
                        _showEditReminderBottomSheet(context, reminder),
                    icon: Icon(
                      Icons.edit_outlined,
                      color: primaryTextColor,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ],
          ),
          18.verticalSpace,
          Row(
            children: [
              _buildInfoChip(
                icon: Icons.repeat,
                label: repeatLabel,
                isActive: isActive,
              ),
              10.horizontalSpace,
              _buildInfoChip(
                icon: Icons.medication_liquid,
                label: quantityLabel,
                isActive: isActive,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, bool hasReminders) {
    final totalReminders = reminderCtl.listReminder.length;
    final activeReminders =
        reminderCtl.listReminder.where((element) => element.isOn).length;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                L.allReminder.tr,
                style: GlobalTextStyles.font18w700ColorBlack,
              ),
              4.verticalSpace,
              Text(
                hasReminders
                    ? "${activeReminders}/$totalReminders ${L.reminderActiveLabel.tr}"
                    : L.reminderEmptySubtitle.tr,
                style: GlobalTextStyles.font12w400ColorNewtral,
              ),
            ],
          ),
        ),
        TextButton.icon(
          onPressed: () => _showAddReminderBottomSheet(context),
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            backgroundColor:
                GlobalColors.linearPrimary2.colors.first.withOpacity(0.12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.r),
            ),
          ),
          icon: Icon(
            Icons.add,
            color: GlobalColors.linearPrimary2.colors.last,
            size: 18,
          ),
          label: Text(
            L.addReminder.tr,
            style: GlobalTextStyles.font12w400ColorBlack.copyWith(
              color: GlobalColors.linearPrimary2.colors.last,
            ),
          ),
        ),
      ],
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

  Widget _buildOverviewCard() {
    final totalReminders = reminderCtl.listReminder.length;
    final activeReminders =
        reminderCtl.listReminder.where((element) => element.isOn).length;
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: GlobalColors.linearPrimary1,
        borderRadius: BorderRadius.circular(32.r),
        boxShadow: [
          BoxShadow(
            color: GlobalColors.colorLastLinear.withOpacity(0.25),
            blurRadius: 24,
            offset: const Offset(0, 16),
          )
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  L.reminderOverviewTitle.tr,
                  style: GlobalTextStyles.font18w600ColorWhite,
                ),
                6.verticalSpace,
                Text(
                  L.reminderOverviewSubtitle.tr,
                  style: GlobalTextStyles.font12w400ColorWhiteOp60,
                ),
                18.verticalSpace,
                Row(
                  children: [
                    _buildOverviewStat(
                      label: L.allReminder.tr,
                      value: totalReminders.toString(),
                    ),
                    16.horizontalSpace,
                    _buildOverviewStat(
                      label: L.reminderActiveLabel.tr,
                      value: activeReminders.toString(),
                    ),
                  ],
                ),
              ],
            ),
          ),
          16.horizontalSpace,
          Container(
            width: 64.w,
            height: 64.w,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Icon(
              Icons.medication_outlined,
              color: Colors.white,
              size: 28.w,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewStat({required String label, required String value}) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.18),
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: GlobalTextStyles.font20w700ColorWhite,
            ),
            4.verticalSpace,
            Text(
              label,
              style: GlobalTextStyles.font12w400ColorWhiteOp60,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 100.w,
            height: 100.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32.r),
              boxShadow: GlobalShadow.primary,
            ),
            child: Icon(
              Icons.alarm_add,
              color: GlobalColors.colorLastLinear,
              size: 40.w,
            ),
          ),
          20.verticalSpace,
          Text(
            L.reminderEmptyTitle.tr,
            style: GlobalTextStyles.font18w600ColorBlack,
          ),
          8.verticalSpace,
          Text(
            L.reminderEmptySubtitle.tr,
            style: GlobalTextStyles.font12w400ColorNewtral,
            textAlign: TextAlign.center,
          ),
          24.verticalSpace,
          _buildAddReminderButton(context),
        ],
      ),
    );
  }

  Widget _buildAddReminderButton(BuildContext context) {
    return GestureDetector(
      onTap: () => _showAddReminderBottomSheet(context),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 14.h),
        decoration: BoxDecoration(
          gradient: GlobalColors.linearPrimary2,
          borderRadius: BorderRadius.circular(32.r),
          boxShadow: GlobalShadow.primary,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "assets/icons/add.svg",
              height: 20.w,
              width: 20.w,
            ),
            10.horizontalSpace,
            Text(
              L.addReminder.tr,
              style: GlobalTextStyles.font16w600ColorWhite,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(
      {required IconData icon, required String label, required bool isActive}) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isActive
              ? Colors.white.withOpacity(0.15)
              : Colors.black.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: isActive ? Colors.white : Colors.black87,
            ),
            6.horizontalSpace,
            Expanded(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: GlobalTextStyles.font12w400ColorBlack.copyWith(
                  color: isActive ? Colors.white : Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeBadge(
      BuildContext context, DateTime dateTime, bool isActive) {
    final timeText = _formatTime(context, dateTime);
    return Container(
      width: 74.w,
      padding: EdgeInsets.symmetric(vertical: 14.h),
      decoration: BoxDecoration(
        color: isActive
            ? Colors.white.withOpacity(0.2)
            : Colors.black.withOpacity(0.08),
        borderRadius: BorderRadius.circular(22.r),
      ),
      child: Column(
        children: [
          Text(
            timeText.split(" ").first,
            style: GlobalTextStyles.font16w600ColorBlack.copyWith(
              color: isActive ? Colors.white : Colors.black87,
            ),
          ),
          if (timeText.contains(" "))
            Text(
              timeText.split(" ").last,
              style: GlobalTextStyles.font12w400ColorNewtral.copyWith(
                color:
                    isActive ? Colors.white70 : Colors.black.withOpacity(0.55),
              ),
            ),
        ],
      ),
    );
  }

  String _formatRepeatDays(String? repeatDays) {
    if (repeatDays == null || repeatDays.isEmpty) {
      return L.oneTime.tr;
    }
    final dayLabels = [
      L.mondayShort.tr,
      L.tuesdayShort.tr,
      L.wednesdayShort.tr,
      L.thursdayShort.tr,
      L.fridayShort.tr,
      L.saturdayShort.tr,
      L.sundayShort.tr,
    ];
    final days = repeatDays
        .split(',')
        .map((e) => int.tryParse(e))
        .whereType<int>()
        .toList();
    if (days.length == 7) {
      return L.daily.tr;
    }
    return days
        .map((day) => dayLabels[(day - 1).clamp(0, dayLabels.length - 1)])
        .join(', ');
  }

  String _formatTime(BuildContext context, DateTime dateTime) {
    final use24HourFormat = MediaQuery.of(context).alwaysUse24HourFormat;
    final minutes = dateTime.minute.toString().padLeft(2, '0');
    if (use24HourFormat) {
      final hours = dateTime.hour.toString().padLeft(2, '0');
      return "$hours:$minutes";
    }
    final hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
    final period = dateTime.hour >= 12 ? "PM" : "AM";
    return "$hour:$minutes $period";
  }

  void _showEditReminderBottomSheet(BuildContext context, Reminder reminder) {
    final dateTime = DateTime.parse(reminder.dateTime);
    int hour = dateTime.hour;
    int minute = dateTime.minute;
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return BottomsheetTimeEditStandard(
          reminder: reminder,
          onClickDelete: () {
            Get.back();
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
      },
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
