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
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Container(
          decoration: BoxDecoration(
            gradient: isSelected ? GlobalColors.linearPrimary2 : null,
            borderRadius: BorderRadius.circular(99.w),
            color: Colors.white,
            boxShadow: GlobalShadow.primary,
          ),
          child: ListTile(
            leading: Image.asset(
              imagePath,
              width: 24,
              height: 24,
            ),
            title: Text(
              language.tr,
              style: isSelected
                  ? GlobalTextStyles.font16w600ColorWhite
                  : GlobalTextStyles.font14w400ColorBlack,
            ),
          ),
        ),
      ),
    );
  }
}
