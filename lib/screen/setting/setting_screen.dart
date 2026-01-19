import 'package:flutter_screenutil/flutter_screenutil.dart';
import '/widget/gradient_text.dart';
import '/config/global_color.dart';
import '/config/global_text_style.dart';
import '/lang/l.dart';
import '/screen/languege/controller/languege_controller.dart';
import '/screen/languege/language.dart';
import '/screen/privacy/privacy.dart';
import '/screen/setting/controller/setting_controller.dart';
import '/widget/body_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final langCtl = Get.find<LanguageController>();
  final settingCtl = Get.find<SettingController>();
  bool isClicking = false;

  void checkSpam(VoidCallback onTap) async {
    if (!isClicking) {
      isClicking = true;
      onTap();
      await Future.delayed(const Duration(seconds: 2));
      isClicking = false;
    }
  }

  @override
  void initState() {
    super.initState();
    settingCtl.setVersion();
  }

  @override
  Widget build(BuildContext context) {
    return BodyCustom(
      edgeInsetsPadding: const EdgeInsets.only(top: 20),
      isShowBgImages: false,
      appbar: AppBar(
        backgroundColor: GlobalColors.bg1,
        title: GradientText(
          L.settings.tr,
          gradient: GlobalColors.linearPrimary2,
          style: GlobalTextStyles.font20w600ColorWhite,
        ),
        centerTitle: true,
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeroBanner(),
              24.verticalSpace,
              _buildSettingsPanel(),
              24.verticalSpace,
              _buildAboutCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      decoration: BoxDecoration(
        gradient: GlobalColors.linearPrimary2,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 56,
            width: 56,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.tune_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
          18.verticalSpace,
          Text(
            L.settings.tr,
            style: GlobalTextStyles.font20w600ColorWhite,
          ),
          6.verticalSpace,
          Text(
            L.appName.tr,
            style: GlobalTextStyles.font16w600ColorWhite
                .copyWith(fontWeight: FontWeight.w400, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsPanel() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: GlobalColors.container1,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 32,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          Obx(
            () => _SettingTile(
              iconPath: 'assets/icons/ic_language.svg',
              title: L.language.tr,
              subtitle: langCtl.currentNameLang.value,
              onTap: () => checkSpam(() {
                Get.to(() => const LanguageScreen(isSetting: true));
              }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Divider(
              height: 1,
              color: GlobalColors.newtral.withOpacity(0.08),
            ),
          ),
          _SettingTile(
            iconPath: 'assets/icons/ic_lock.svg',
            title: L.privacyPolicy.tr,
            onTap: () => checkSpam(() {
              Get.to(const PrivacyPolicyScreen());
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutCard() {
    return Obx(() {
      final language = langCtl.currentNameLang.value;
      final version =
          settingCtl.version.value.isEmpty ? '--' : settingCtl.version.value;
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: GlobalColors.container1,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: GlobalColors.newtral.withOpacity(0.08),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              L.appName.tr,
              style: GlobalTextStyles.font16w600ColorBlack,
            ),
            8.verticalSpace,
            Text(
              "${L.version.tr} $version",
              style: GlobalTextStyles.font12w400ColorNewtral,
            ),
            16.verticalSpace,
            _InfoBadge(
              label: L.language.tr,
              value: language,
            ),
          ],
        ),
      );
    });
  }
}

class _SettingTile extends StatelessWidget {
  final String iconPath;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const _SettingTile({
    required this.iconPath,
    required this.title,
    required this.onTap,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: GlobalColors.bg1,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    iconPath,
                    height: 24,
                    width: 24,
                  ),
                ),
              ),
              16.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GlobalTextStyles.font14w600ColorBlack,
                    ),
                    if (subtitle != null) ...[
                      4.verticalSpace,
                      Text(
                        subtitle!,
                        style: GlobalTextStyles.font12w400ColorNewtral,
                      ),
                    ],
                  ],
                ),
              ),
              SvgPicture.asset(
                'assets/icons/ic_next_setting.svg',
                height: 24,
                width: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoBadge extends StatelessWidget {
  final String label;
  final String value;

  const _InfoBadge({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: GlobalColors.bg1,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GlobalTextStyles.font12w400ColorNewtral,
          ),
          4.verticalSpace,
          Text(
            value,
            style: GlobalTextStyles.font14w600ColorBlack,
          ),
        ],
      ),
    );
  }
}
