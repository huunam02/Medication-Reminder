import 'package:intl/intl.dart';
import 'package:medication_reminder/model/history.dart';
import 'package:medication_reminder/screen/history/controller/history_controller.dart';
import 'package:medication_reminder/screen/history/widget/custom_item_recent.dart';
import 'package:medication_reminder/widget/dialog_delete_record.dart';
import '/config/global_color.dart';
import '/config/global_sadow.dart';
import '/config/global_text_style.dart';
import '/lang/l.dart';
import '/widget/appbar_base.dart';
import '/widget/body_background.dart';
import '/widget/gradient_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final textCtr = TextEditingController();
  final historyCtl = Get.find<HistoryController>();
  @override
  void initState() {
    super.initState();
    historyCtl.getListHistoryDay();
  }

  @override
  Widget build(BuildContext context) {
    return BodyCustom(
      appbar: AppbarBase(
        title: GradientText(
          L.history.tr,
          gradient: GlobalColors.linearPrimary2,
          style: GlobalTextStyles.font20w600ColorWhite,
        ),
      ),
      edgeInsetsPadding: EdgeInsets.symmetric(horizontal: 16.0),
      isShowBgImages: false,
      child: Obx(
        () {
          final List<History> histories =
              historyCtl.listHistoryDay.reversed.toList();
          final DateTime selectedDay = historyCtl.daySelect.value;
          final int totalAmount = historyCtl.totalDay.value;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),
              _HistoryOverviewCard(
                selectedDay: selectedDay,
                recordCount: histories.length,
                totalAmount: totalAmount,
                onPreviousDay: historyCtl.lastDay,
                onNextDay: historyCtl.nextDay,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: RefreshIndicator(
                  color: GlobalColors.colorLastLinear,
                  onRefresh: () async {
                    await historyCtl.getListHistoryDay();
                  },
                  child: histories.isNotEmpty
                      ? ListView.separated(
                          physics: const BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics()),
                          padding: const EdgeInsets.only(bottom: 24.0),
                          itemBuilder: (context, index) {
                            final History history = histories[index];
                            return CustomItemRecent(
                              history: history,
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => Dialog(
                                    child: DialogDeleteRecord(
                                      ontap: () {
                                        historyCtl.deleteRecord(history, 0);
                                      },
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemCount: histories.length,
                        )
                      : ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: const [
                            SizedBox(height: 120),
                            _EmptyHistoryView(),
                          ],
                        ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _HistoryOverviewCard extends StatelessWidget {
  const _HistoryOverviewCard({
    required this.selectedDay,
    required this.recordCount,
    required this.totalAmount,
    required this.onPreviousDay,
    required this.onNextDay,
  });

  final DateTime selectedDay;
  final int recordCount;
  final int totalAmount;
  final VoidCallback onPreviousDay;
  final VoidCallback onNextDay;

  @override
  Widget build(BuildContext context) {
    final Locale? locale = Get.locale;
    final String? localeName = locale == null
        ? null
        : locale.countryCode == null
            ? locale.languageCode
            : '${locale.languageCode}_${locale.countryCode}';
    final String weekdayLabel =
        DateFormat('EEEE', localeName).format(selectedDay);
    final String dateLabel = DateFormat.yMMMMd(localeName).format(selectedDay);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: GlobalColors.linearPrimary2,
        borderRadius: BorderRadius.circular(24),
        boxShadow: GlobalShadow.primary,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _HistoryNavigationButton(
                icon: Icons.chevron_left,
                onTap: onPreviousDay,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      weekdayLabel,
                      style: GlobalTextStyles.font16w600ColorWhite,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dateLabel,
                      style: GlobalTextStyles.font12w400ColorWhiteOp60,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              _HistoryNavigationButton(
                icon: Icons.chevron_right,
                onTap: onNextDay,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.16),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                const Icon(Icons.medication_outlined, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${L.total.tr}: $totalAmount',
                        style: GlobalTextStyles.font14w600ColorWhite,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${recordCount.toString()} ${L.history.tr}',
                        style: GlobalTextStyles.font12w400ColorWhiteOp60,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryNavigationButton extends StatelessWidget {
  const _HistoryNavigationButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withOpacity(0.2),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          height: 40,
          width: 40,
          child: Center(
            child: Icon(icon, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class _EmptyHistoryView extends StatelessWidget {
  const _EmptyHistoryView();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          Icons.event_busy_outlined,
          color: GlobalColors.newtral.withOpacity(0.5),
          size: 64,
        ),
        const SizedBox(height: 16),
        Text(
          L.noRecent.tr,
          textAlign: TextAlign.center,
          style: GlobalTextStyles.font14w600ColorWhite.copyWith(
            color: const Color(0xFF4B5563),
          ),
        ),
      ],
    );
  }
}
