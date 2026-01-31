import '/config/global_color.dart';
import '/config/global_sadow.dart';
import '/config/global_text_style.dart';
import '/lang/l.dart';
import '/model/history.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class CustomItemRecent extends StatelessWidget {
  const CustomItemRecent(
      {super.key, required this.history, required this.onTap});
  final History history;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    final DateTime? recordedAt =
        history.dateTime == null ? null : DateTime.tryParse(history.dateTime!);
    final String timeLabel = recordedAt == null
        ? L.unknown.tr
        : TimeOfDay.fromDateTime(recordedAt).format(context);
    final String amountLabel =
        convertAmountWithUnit(history.amount ?? 0, history.unit);
    final String title = (history.title ?? '').trim().isEmpty
        ? L.unknown.tr
        : history.title!.trim();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          decoration: BoxDecoration(
            color: GlobalColors.container1,
            borderRadius: BorderRadius.circular(20),
            boxShadow: GlobalShadow.primary,
          ),
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                height: 56,
                width: 56,
                decoration: BoxDecoration(
                  gradient: GlobalColors.linearPrimary2,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.vaccines_outlined,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GlobalTextStyles.font16w600ColorBlack,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _HistoryInfoChip(
                          icon: Icons.inventory_2_outlined,
                          label: amountLabel,
                        ),
                        _HistoryInfoChip(
                          icon: Icons.schedule_outlined,
                          label: timeLabel,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                onPressed: onTap,
                icon: const Icon(Icons.delete_forever_outlined),
                color: Colors.redAccent,
                splashRadius: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String convertAmountWithUnit(int amount, String? unit) {
    if (unit == null || unit.isEmpty) {
      return amount.toString();
    }
    if (unit == L.pillUnit || unit == L.pillUnit.tr || unit == "pill") {
      final bool isSingular = amount == 1;
      final String localizedUnit = isSingular ? L.pillUnit.tr : L.pillUnits.tr;
      return "$amount $localizedUnit";
    }
    return "$amount ${unit.tr}";
  }
}

class _HistoryInfoChip extends StatelessWidget {
  const _HistoryInfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: GlobalColors.bg1,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: GlobalColors.colorLastLinear),
          const SizedBox(width: 6),
          Text(
            label,
            style: GlobalTextStyles.font12w400ColorBlack,
          ),
        ],
      ),
    );
  }
}
