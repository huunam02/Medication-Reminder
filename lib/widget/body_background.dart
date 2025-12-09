import '/config/global_color.dart';
import 'package:flutter/material.dart';

class BodyCustom extends StatelessWidget {
  const BodyCustom(
      {super.key,
      required this.child,
      this.edgeInsetsPadding,
      required this.isShowBgImages,
      this.appbar,
      this.bottomNavigationBar,
      this.resizeToAvoidBottomInset,
      this.floatingActionButton});
  final Widget child;
  final EdgeInsets? edgeInsetsPadding;
  final bool isShowBgImages;
  final PreferredSizeWidget? appbar;
  final Widget? bottomNavigationBar;
  final bool? resizeToAvoidBottomInset;
  final Widget? floatingActionButton;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      appBar: appbar,
      backgroundColor: isShowBgImages ? Colors.transparent : GlobalColors.bg1,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      body: Container(
          padding: edgeInsetsPadding,
          height: double.infinity,
          width: double.infinity,
          decoration: isShowBgImages
              ? const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/bg.png"),
                      fit: BoxFit.cover))
              : null,
          child: child),
    );
  }
}
