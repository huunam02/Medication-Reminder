import '/config/global_color.dart';
import 'package:flutter/material.dart';

class AppbarBase extends StatelessWidget implements PreferredSizeWidget {
  const AppbarBase(
      {super.key,
      this.centerTitle = true,
      this.title,
      this.leading,
      this.actions,
      this.automaticallyImplyLeading});
  final bool? centerTitle;
  final Widget? title;
  final Widget? leading;
  final List<Widget>? actions;
  final bool? automaticallyImplyLeading;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: GlobalColors.bg1,
      elevation: 0,
      leading: leading,
      title: title,
      centerTitle: centerTitle,
      actions: actions,
      automaticallyImplyLeading: automaticallyImplyLeading ?? true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
