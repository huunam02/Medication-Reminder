import 'package:medication_reminder/screen/navbar/navbar.dart';

import '/config/global_color.dart';
import '/widget/appbar_base.dart';
import '/widget/gradient_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '/widget/body_background.dart';
import '/base/lifecycle_state.dart';
import '/config/global_text_style.dart';
import '/lang/l.dart';
import '/model/languege.dart';
import '/screen/languege/controller/languege_controller.dart';
import '/screen/languege/widget/item_languege.dart';
import '/util/preferences_util.dart';
import '/config/global_sadow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key, required this.isSetting});
  final bool isSetting;
  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends LifecycleState<LanguageScreen> {
  final langCtl = Get.find<LanguageController>();
  @override
  void initState() {
    super.initState();
    langCtl.checkLanguege();
  }

  @override
  Widget build(BuildContext context) {
    return BodyCustom(
      isShowBgImages: false,
      appbar: _buildAppbar(),
      edgeInsetsPadding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          24.verticalSpace,
          _buildHeroCard(),
          24.verticalSpace,
          _buildSectionHeader(),
          16.verticalSpace,
          _buidListItem(),
          20.verticalSpace,
        ],
      ),
    );
  }

  Expanded _buidListItem() {
    return Expanded(
      child: Obx(
        () {
          final languages = langCtl.listLanguege;
          final hasSelection =
              langCtl.isClickLang.value || PreferencesUtil.isSelectFirstLanguage();
          final selectedIndex = langCtl.selectedLanguageIndex.value;
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32.r),
              boxShadow: GlobalShadow.primary,
            ),
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemCount: languages.length,
              padding: EdgeInsets.symmetric(vertical: 8.h),
              separatorBuilder: (_, __) => 12.verticalSpace,
              itemBuilder: (context, index) {
                final Languege languege = languages[index];
                final bool isSelected = hasSelection && selectedIndex == index;
                return ItemLanguege(
                  onTap: () {
                    langCtl.isClickLang.value = true;
                    langCtl.selectLanguage(index);
                  },
                  language: languege.name,
                  imagePath: languege.image,
                  isSelected: isSelected,
                );
              },
            ),
          );
        },
      ),
    );
  }

  AppbarBase _buildAppbar() {
    return AppbarBase(
      title: _buildTitle(),
      leading: _buildLeadingButton(),
      actions: _buildAction,
    );
  }

  List<Widget> get _buildAction {
    return [
      GestureDetector(
        onTap: () {
          if (langCtl.isClickLang.value ||
              PreferencesUtil.isSelectFirstLanguage()) {
            if (widget.isSetting) {
              Get.back();
              langCtl.saveLanguage();
            } else {
              langCtl.saveLanguage();
              Get.offAll(() => const NavbarScreen());
            }
          }
        },
        child: Obx(
          () => SvgPicture.asset(
            "assets/icons/ic_check.svg",
            width: 28.0,
            height: 28.0,
            color: langCtl.isClickLang.value ||
                    PreferencesUtil.isSelectFirstLanguage()
                ? GlobalColors.colorLastLinear
                : Colors.white.withOpacity(0),
          ),
        ),
      ),
      16.horizontalSpace
    ];
  }

  GradientText _buildTitle() {
    return GradientText(
      L.language.tr,
      style: GlobalTextStyles.font18w700ColorBlack,
      gradient: GlobalColors.linearPrimary2,
    );
  }

  Center _buildLeadingButton() {
    return Center(
      child: SizedBox(
        height: 24.0,
        width: 24.0,
        child: widget.isSetting
            ? GestureDetector(
                onTap: () => Get.back(),
                child: SvgPicture.asset(
                  "assets/icons/back.svg",
                  fit: BoxFit.cover,
                  color: Colors.black,
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildHeroCard() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: GlobalColors.linearPrimary1,
        borderRadius: BorderRadius.circular(32.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  L.language.tr,
                  style: GlobalTextStyles.font20w700ColorWhite,
                ),
                8.verticalSpace,
                Text(
                  L.languageHeroDescription.tr,
                  style: GlobalTextStyles.font12w400ColorWhiteOp60,
                ),
              ],
            ),
          ),
          16.horizontalSpace,
          Container(
            height: 88.w,
            width: 88.w,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.translate,
              color: Colors.white,
              size: 40.w,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          L.languageAvailableTitle.tr,
          style: GlobalTextStyles.font18w700ColorBlack,
        ),
        4.verticalSpace,
        Text(
          L.languageAvailableSubtitle.tr,
          style: GlobalTextStyles.font12w400ColorNewtral,
        ),
      ],
    );
  }

  @override
  void onDetached() {}

  @override
  void onInactive() {}

  @override
  void onPaused() {}

  @override
  void onResumed() {}

  @override
  void onKeyboardHint() {}

  @override
  void onKeyboardShow() {}
}
