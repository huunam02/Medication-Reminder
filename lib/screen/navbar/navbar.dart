import '/config/global_sadow.dart';
import '/lang/l.dart';
import '/screen/history/history.dart';
import '/screen/notification/notification.dart';
import '/screen/setting/setting_screen.dart';
import '/screen/water/water_screen.dart';
import '/widget/body_background.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '/config/global_color.dart';
import '/config/global_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NavbarScreen extends StatefulWidget {
  const NavbarScreen({super.key});

  @override
  State<NavbarScreen> createState() => _NavbarScreenState();
}

class _NavbarScreenState extends State<NavbarScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    WaterScreen(),
    HistoryScreen(),
    NotificationScreen(),
    SettingScreen(),
  ];

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
              _selectedIndex == 0
                  ? "assets/icons/navbar11.svg"
                  : "assets/icons/navbar1.svg",
              L.water.tr,
              0,
            ),
            buildNavBarItem(
              _selectedIndex == 1
                  ? "assets/icons/navbar22.svg"
                  : "assets/icons/navbar2.svg",
              L.statistical.tr,
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

  Widget buildNavBarItem(String icon, String label, int index) {
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
              SvgPicture.asset(
                icon,
                height: 24,
                width: 24,
                fit: BoxFit.cover,
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
