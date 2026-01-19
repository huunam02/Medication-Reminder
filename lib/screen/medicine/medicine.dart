import 'package:medication_reminder/screen/medicine/controller/medicine_controller.dart';
import '/config/global_color.dart';
import '/config/global_text_style.dart';
import '/lang/l.dart';
import '/model/reminder.dart';
import '/screen/reminder/controller/reminder_controller.dart';
import '/screen/reminder/reminder_screen.dart';
import '/screen/reminder/take_medicine_screen.dart';
import 'widget/medicine_animation.dart';
import '/widget/appbar_base.dart';
import '/widget/body_background.dart';
import '/widget/fomart_time.dart';
import '/widget/gradient_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MedicineScreen extends StatefulWidget {
  const MedicineScreen({super.key});
  @override
  State<MedicineScreen> createState() => _MedicineScreenState();
}

class _MedicineScreenState extends State<MedicineScreen> {
  final medicineCtr = Get.find<MedicineController>();
  final reminder = Get.find<ReminderController>();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    medicineCtr.initData();
    await reminder.loadData();
    reminder.checkOnReminder();
    medicineCtr.checkNextReminder();
  }

  @override
  Widget build(BuildContext context) {
    return BodyCustom(
      edgeInsetsPadding: EdgeInsets.zero,
      isShowBgImages: false,
      appbar: AppbarBase(
        title: GradientText(
          L.home.tr,
          gradient: GlobalColors.linearPrimary2,
          style: GlobalTextStyles.font20w600ColorWhite,
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeroSection(),
              24.verticalSpace,
              _buildReminderCard(),
              24.verticalSpace,
              _buildStatsRow(),
              24.verticalSpace,

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 28.h),
      decoration: BoxDecoration(
        gradient: GlobalColors.linearPrimary2,
        borderRadius: BorderRadius.circular(32.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.16),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Text(
                    L.takeMedicine.tr,
                    style: GlobalTextStyles.font12w600ColorWhite,
                  ),
                ),
                16.verticalSpace,
                Text(
                  L.notiTitle.tr,
                  style: GlobalTextStyles.font24w700ColorWhite,
                ),
                8.verticalSpace,
                Text(
                  L.appName.tr,
                  style: GlobalTextStyles.font14w400ColorWhite
                      .copyWith(color: Colors.white.withOpacity(0.8)),
                ),
                20.verticalSpace,
                TextButton.icon(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => Get.to(() => const ReminderScreen()),
                  icon: const Icon(Icons.alarm_add_rounded, size: 18),
                  label: Text(L.reminder.tr),
                ),
              ],
            ),
          ),
          SizedBox(width: 24.w),
          SizedBox(
            height: 120.w,
            width: 120.w,
            child: MedicinceAnimation(),
          ),
        ],
      ),
    );
  }

  Widget _buildReminderCard() {
    return Obx(() {
      final nextReminderObj = reminder.nextReminderObj.value;
      final nextReminderTime = medicineCtr.nextReminder.value;

      if (nextReminderObj == null || nextReminderTime == L.off) {
        return _EmptyStateCard(
          title: L.reminder.tr,
          description: L.notiDes.tr,
          actionLabel: L.addReminder.tr,
          onAction: () => Get.to(() => const ReminderScreen()),
        );
      }

      final reminderData = nextReminderObj;
        final bool isActiveWindow = _isWithinReminderWindow(reminderData);
        final String title = reminderData.title ?? L.medicineFallback.tr;
        final String quantityLabel = reminderData.quantity != null
          ? "${reminderData.quantity} ${L.pillUnit.tr}"
          : L.quantity.tr;

      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28.r),
          border: Border.all(
            color: GlobalColors.linearPrimary2.colors.last.withOpacity(0.15),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 32,
              offset: const Offset(0, 18),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                    isActiveWindow
                      ? Icons.notifications_active
                      : Icons.schedule_rounded,
                  color: GlobalColors.colorLastLinear,
                ),
                8.horizontalSpace,
                Text(
                  isActiveWindow ? L.notiTitle.tr : L.nextReminder.tr,
                  style: GlobalTextStyles.font16w600ColorBlack,
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: GlobalColors.bg1,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    quantityLabel,
                    style: GlobalTextStyles.font12w400ColorBlack,
                  ),
                ),
              ],
            ),
            16.verticalSpace,
            Text(
              title,
              style: GlobalTextStyles.font18w600ColorBlack,
            ),
            12.verticalSpace,
            Row(
              children: [
                Text(
                  L.nextDoseIn.tr,
                  style: GlobalTextStyles.font14w400ColorNewtral,
                ),
                12.horizontalSpace,
                CustomNextTime(time: nextReminderTime, mode: "standard"),
              ],
            ),
            20.verticalSpace,
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
                  backgroundColor: GlobalColors.linearPrimary2.colors.last,
                  elevation: isActiveWindow ? 6 : 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                onPressed: () async {
                    await Get.to(() => TakeMedicineScreen(reminder: reminderData));
                  medicineCtr.checkNextReminder();
                  reminder.checkNextReminder();
                },
                icon: const Icon(Icons.medication, color: Colors.white),
                label: Text(
                  isActiveWindow
                      ? L.confirmTaken.tr
                      : "${L.take.tr} $title",
                  style: GlobalTextStyles.font16w600ColorWhite,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildStatsRow() {
    return Obx(() {
      final takenToday = medicineCtr.listHistory.length;
      final totalReminder = reminder.listReminder.length;
      final activeReminder =
          reminder.listReminder.where((element) => element.isOn).length;

      final highlight = GlobalColors.linearPrimary2.colors.last;

      return Row(
        children: [
          Expanded(
            child: _StatCard(
              title: L.history.tr,
              value: takenToday.toString(),
              accent: highlight,
            ),
          ),
          12.horizontalSpace,
          Expanded(
            child: _StatCard(
              title: L.reminder.tr,
              value: "$activeReminder/$totalReminder",
              accent: GlobalColors.colorLastLinear,
            ),
          ),
        ],
      );
    });
  }

 
  bool _isWithinReminderWindow(Reminder? nextReminderObj) {
    if (nextReminderObj == null) return false;
    if (reminder.takenReminderIds.contains(nextReminderObj.id)) {
      return false;
    }
    DateTime now = DateTime.now();
    DateTime time = DateTime.parse(nextReminderObj.dateTime);
    DateTime reminderTime =
        DateTime(now.year, now.month, now.day, time.hour, time.minute);
    int diff = reminderTime.difference(now).inMinutes;
    return diff <= 0 && diff >= -15;
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color accent;

  const _StatCard({
    required this.title,
    required this.value,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [
            accent.withOpacity(0.12),
            Colors.white,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: accent.withOpacity(0.14)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GlobalTextStyles.font12w400ColorNewtral,
          ),
          8.verticalSpace,
          Text(
            value,
            style: GlobalTextStyles.font24w700ColorWhite
                .copyWith(color: accent),
          ),
        ],
      ),
    );
  }
}

class _EmptyStateCard extends StatelessWidget {
  final String title;
  final String description;
  final String actionLabel;
  final VoidCallback onAction;

  const _EmptyStateCard({
    required this.title,
    required this.description,
    required this.actionLabel,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.white,
        border: Border.all(color: GlobalColors.bg1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GlobalTextStyles.font16w600ColorBlack,
          ),
          8.verticalSpace,
          Text(
            description,
            style: GlobalTextStyles.font12w400ColorNewtral,
          ),
          16.verticalSpace,
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: GlobalColors.linearPrimary2.colors.last,
            ),
            onPressed: onAction,
            child: Text(actionLabel),
          ),
        ],
      ),
    );
  }
}

