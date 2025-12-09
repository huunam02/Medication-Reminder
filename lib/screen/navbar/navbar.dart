import '/config/global_sadow.dart';
import '/lang/l.dart';
import '/screen/history/history.dart';
import '../reminder/reminder_screen.dart';
import '/screen/setting/setting_screen.dart';
import '../medicine/medicine.dart';
import '/widget/body_background.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '/config/global_color.dart';
import '/config/global_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '/util/preferences_util.dart';

class NavbarScreen extends StatefulWidget {
  const NavbarScreen({super.key});

  @override
  State<NavbarScreen> createState() => _NavbarScreenState();
}

class _NavbarScreenState extends State<NavbarScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    MedicineScreen(),
    HistoryScreen(),
    ReminderScreen(),
    SettingScreen(),
  ];

  @override
  void initState() {
    super.initState();
    PreferencesUtil.putFirstTime(false);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BodyCustom(
      isShowBgImages: false,
      bottomNavigationBar: Container(
        height: 90.h,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: GlobalShadow.primary,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32.r),
            topRight: Radius.circular(32.r),
          ),
        ),
        child: Row(
          children: [
            buildNavBarItem(
              Icons.medication,
              "Trang chủ",
              0,
            ),
            buildNavBarItem(
              _selectedIndex == 1
                  ? "assets/icons/navbar22.svg"
                  : "assets/icons/navbar2.svg",
              "Lịch sử",
              1,
            ),
            buildNavBarItem(
              _selectedIndex == 2
                  ? "assets/icons/notification_on.svg"
                  : "assets/icons/notification.svg",
              L.reminder.tr,
              2,
            ),
            buildNavBarItem(
              _selectedIndex == 3
                  ? "assets/icons/navbar33.svg"
                  : "assets/icons/navbar3.svg",
              L.settings.tr,
              3,
            ),
          ],
        ),
      ),
      child: _screens[_selectedIndex],
    );
  }

  Widget buildNavBarItem(dynamic icon, String label, int index) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          _onItemTapped(index);
        },
        child: Container(
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              icon is String
                  ? SvgPicture.asset(
                      icon,
                      height: 24,
                      width: 24,
                      fit: BoxFit.cover,
                    )
                  : Icon(
                      icon,
                      size: 24,
                      color: _selectedIndex == index
                          ? GlobalColors.colorLastLinear
                          : GlobalColors.newtral,
                    ),
              const SizedBox(
                height: 4.0,
              ),
              Text(
                label,
                style: _selectedIndex == index
                    ? GlobalTextStyles.font12w600ColorWhite
                        .copyWith(color: GlobalColors.colorLastLinear)
                    : GlobalTextStyles.font12w400ColorNewtral,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
