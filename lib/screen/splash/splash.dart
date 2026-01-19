import 'dart:async';
import '/screen/navbar/navbar.dart';
import '/util/preferences_util.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import '/config/global_text_style.dart';
import '/config/global_color.dart';
import '/config/global_sadow.dart';
import '/lang/l.dart';
import '/screen/languege/language.dart';
import '/widget/body_background.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() {
    Future.delayed(
      const Duration(seconds: 3),
      () => handleNavigateLanguage(),
    );
  }

  void handleNavigateLanguage() {
    if (PreferencesUtil.getFirstTime() == false) {
      Get.offAll(const NavbarScreen());
      return;
    }
    Get.offAll(const LanguageScreen(isSetting: false));
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: BodyCustom(
        isShowBgImages: false,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFF4FFFB), Color(0xFFE7F7F0)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Stack(
            children: [
              _buildBackgroundOrb(
                alignment: const Alignment(-1.2, -0.8),
                size: 220,
                colors: const [Color(0xFF7BE0CB), Color(0xFF37B497)],
              ),
              _buildBackgroundOrb(
                alignment: const Alignment(1.3, -0.2),
                size: 180,
                colors: const [Color(0xFFB5EAF8), Color(0xFF6DD6F5)],
              ),
              _buildBackgroundOrb(
                alignment: const Alignment(1.1, 0.9),
                size: 260,
                colors: const [Color(0xFFD9EFFF), Color(0xFFC0F4E6)],
              ),
              Align(
                alignment: const Alignment(0, -0.1),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32.w),
                  child: _buildHeroCard(),
                ),
              ),
              Positioned(
                bottom: 48.h,
                left: 32.w,
                right: 32.w,
                child: _buildFooter(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackgroundOrb({
    required Alignment alignment,
    required double size,
    required List<Color> colors,
  }) {
    return Align(
      alignment: alignment,
      child: Container(
        width: size.w,
        height: size.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: colors
                .map((color) => color.withOpacity(0.45))
                .toList(growable: false),
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: GlobalShadow.primary,
        ),
      ),
    );
  }

  Widget _buildHeroCard() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 32.h),
      decoration: BoxDecoration(
        gradient: GlobalColors.linearPrimary1,
        borderRadius: BorderRadius.circular(36.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00977C).withOpacity(0.2),
            blurRadius: 30,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 110.w,
            height: 110.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.2),
              border: Border.all(
                color: Colors.white.withOpacity(0.45),
                width: 1.2,
              ),
            ),
            padding: EdgeInsets.all(18.w),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
          24.verticalSpace,
          Text(
            L.appName.tr,
            textAlign: TextAlign.center,
            style: GlobalTextStyles.font32w700ColorWhite,
          ),
          12.verticalSpace,
          Text(
            L.splashHeroSubtitle.tr,
            textAlign: TextAlign.center,
            style: GlobalTextStyles.font14w400ColorWhite.copyWith(
              color: Colors.white.withOpacity(0.85),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          L.splashPreparingReminders.tr,
          style: GlobalTextStyles.font14w400ColorNewtral,
        ),
        16.verticalSpace,
        ClipRRect(
          borderRadius: BorderRadius.circular(99.r),
          child: LinearProgressIndicator(
            minHeight: 6,
            valueColor: AlwaysStoppedAnimation<Color>(
              GlobalColors.linearPrimary2.colors.first,
            ),
            backgroundColor: Colors.white,
          ),
        ),
      ],
    );
  }
}
