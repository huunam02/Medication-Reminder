import '/config/global_sadow.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '/config/global_color.dart';
import '/config/global_text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ItemLanguege extends StatelessWidget {
  final String language;
  final String imagePath;
  final bool isSelected;
  final VoidCallback onTap;
  const ItemLanguege(
      {super.key,
      required this.language,
      required this.imagePath,
      required this.isSelected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    final textStyle = isSelected
        ? GlobalTextStyles.font16w600ColorWhite
        : GlobalTextStyles.font16w600ColorBlackOp60;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        decoration: BoxDecoration(
          gradient: isSelected ? GlobalColors.linearPrimary2 : null,
          color: isSelected ? null : Colors.white,
          borderRadius: BorderRadius.circular(28.r),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : Colors.black.withOpacity(0.08),
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF00E4BE).withOpacity(0.28),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ]
              : GlobalShadow.primary,
        ),
        child: Row(
          children: [
            Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withOpacity(0.18)
                    : Colors.black.withOpacity(0.03),
                shape: BoxShape.circle,
              ),
              padding: EdgeInsets.all(10.w),
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
              ),
            ),
            16.horizontalSpace,
            Expanded(
              child: Text(
                language.tr,
                style: textStyle,
              ),
            ),
            Container(
              height: 30.w,
              width: 30.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? Colors.white
                    : Colors.black.withOpacity(0.03),
                border: Border.all(
                  color: isSelected
                      ? Colors.white
                      : Colors.black.withOpacity(0.08),
                ),
              ),
              child: Center(
                child: Icon(
                  isSelected ? Icons.check : Icons.circle_outlined,
                  size: 18.w,
                  color: isSelected
                      ? GlobalColors.color2
                      : Colors.black.withOpacity(0.4),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
