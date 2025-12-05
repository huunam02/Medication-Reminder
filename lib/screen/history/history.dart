import '/config/global_color.dart';
import '/config/global_text_style.dart';
import '/lang/l.dart';
import '/screen/history/widget/tab_view_month.dart';
import '/screen/history/widget/tab_view_week.dart';
import '/widget/appbar_base.dart';
import '/widget/body_background.dart';
import '/widget/gradient_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'widget/tab_view_day.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final textCtr = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BodyCustom(
      appbar: AppbarBase(
        title: GradientText(
          L.statistical.tr,
          gradient: GlobalColors.linearPrimary2,
          style: GlobalTextStyles.font20w600ColorWhite,
        ),
      ),
      edgeInsetsPadding: EdgeInsets.symmetric(horizontal: 16.0),
      isShowBgImages: false,
      child: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            TabBar(
              indicatorColor: GlobalColors.colorLastLinear,
              indicatorSize: TabBarIndicatorSize.tab,
              unselectedLabelStyle: GlobalTextStyles.font14w400ColorNewtral,
              labelStyle: GlobalTextStyles.font14w600ColorWhite
                  .copyWith(color: GlobalColors.colorLastLinear),
              dividerHeight: 0.5,
              dividerColor: Colors.black.withOpacity(.2),
              indicatorWeight: 3,
              tabs: [
                Tab(
                  text: L.day.tr,
                ),
                Tab(text: L.week.tr),
                Tab(
                  text: L.month.tr,
                ),
              ],
            ),
            const Expanded(
              child: TabBarView(
                children: [
                  TabBarViewDay(),
                  TabViewWeek(),
                  TabViewMonth(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
