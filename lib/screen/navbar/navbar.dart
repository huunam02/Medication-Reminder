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
    const MedicineScreen(),
    const HistoryScreen(),
    const ReminderScreen(),
    const SettingScreen(),
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
      bottomNavigationBar: _RoundedNavBar(
        items: _navItems,
        selectedIndex: _selectedIndex,
        onItemTap: _onItemTapped,
      ),
      child: _screens[_selectedIndex],
    );
  }

  List<_NavItem> get _navItems => [
        _NavItem(
          label: L.takeMedicine.tr,
          iconData: Icons.medication_outlined,
          activeIconData: Icons.medication,
        ),
        _NavItem(
          label: L.history.tr,
          iconPath: 'assets/icons/navbar2.svg',
          activeIconPath: 'assets/icons/navbar22.svg',
        ),
        _NavItem(
          label: L.reminder.tr,
          iconPath: 'assets/icons/notification.svg',
          activeIconPath: 'assets/icons/notification_on.svg',
        ),
        _NavItem(
          label: L.settings.tr,
          iconPath: 'assets/icons/navbar3.svg',
          activeIconPath: 'assets/icons/navbar33.svg',
        ),
      ];
}

class _RoundedNavBar extends StatelessWidget {
  final List<_NavItem> items;
  final int selectedIndex;
  final ValueChanged<int> onItemTap;

  const _RoundedNavBar({
    required this.items,
    required this.selectedIndex,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    final highlight = GlobalColors.linearPrimary2.colors.last;
    return Padding(
      padding: EdgeInsets.only(left: 8.w, right: 8.w, bottom: 16.h),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              GlobalColors.container1.withOpacity(0.9),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(36),
          border: Border.all(color: highlight.withOpacity(0.12)),
          boxShadow: [
            BoxShadow(
              color: highlight.withOpacity(0.18),
              blurRadius: 32,
              offset: const Offset(0, 18),
            ),
          ],
        ),
        child: Row(
          children: List.generate(
            items.length,
            (index) => _NavButton(
              item: items[index],
              isSelected: selectedIndex == index,
              onTap: () => onItemTap(index),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final _NavItem item;
  final bool isSelected;
  final VoidCallback onTap;

  static const _duration = Duration(milliseconds: 220);

  const _NavButton({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final highlight = GlobalColors.linearPrimary2.colors.last;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        child: AnimatedContainer(
          duration: _duration,
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? highlight.withOpacity(0.12) : Colors.transparent,
            borderRadius: BorderRadius.circular(28),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: _duration,
                curve: Curves.easeOut,
                padding: EdgeInsets.all(isSelected ? 10 : 8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? Colors.white : GlobalColors.bg1.withOpacity(0.6),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: highlight.withOpacity(0.35),
                            blurRadius: 18,
                            offset: const Offset(0, 10),
                          ),
                        ]
                      : null,
                ),
                child: _NavIcon(
                  item: item,
                  isSelected: isSelected,
                  color: highlight,
                ),
              ),
              8.verticalSpace,
              AnimatedDefaultTextStyle(
                duration: _duration,
                style: isSelected
                    ? GlobalTextStyles.font12w600ColorWhite.copyWith(color: highlight)
                    : GlobalTextStyles.font12w400ColorNewtral,
                child: Text(
                  item.label,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              6.verticalSpace,
              AnimatedContainer(
                duration: _duration,
                height: 4,
                width: isSelected ? 22 : 0,
                decoration: BoxDecoration(
                  color: highlight,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  final _NavItem item;
  final bool isSelected;
  final Color color;

  const _NavIcon({
    required this.item,
    required this.isSelected,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    if (item.iconPath != null) {
      final path = isSelected && item.activeIconPath != null
          ? item.activeIconPath!
          : item.iconPath!;
      return SvgPicture.asset(
        path,
        height: 20,
        width: 20,
      );
    }

    final iconData = isSelected && item.activeIconData != null
        ? item.activeIconData!
        : item.iconData;

    return Icon(
      iconData,
      size: 20,
      color: isSelected ? color : GlobalColors.newtral,
    );
  }
}

class _NavItem {
  final String label;
  final String? iconPath;
  final String? activeIconPath;
  final IconData? iconData;
  final IconData? activeIconData;

  const _NavItem({
    required this.label,
    this.iconPath,
    this.activeIconPath,
    this.iconData,
    this.activeIconData,
  }) : assert(iconPath != null || iconData != null,
            'Each nav item requires either an asset path or icon data');
}
