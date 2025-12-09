import 'package:flutter_svg/svg.dart';
import 'package:medication_reminder/model/history.dart';
import 'package:medication_reminder/screen/history/controller/history_controller.dart';
import 'package:medication_reminder/screen/history/widget/custom_item_recent.dart';
import 'package:medication_reminder/widget/dialog_delete_record.dart';
import '/config/global_color.dart';
import '/config/global_text_style.dart';
import '/lang/l.dart';
import '/widget/appbar_base.dart';
import '/widget/body_background.dart';
import '/widget/gradient_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final textCtr = TextEditingController();
  final historyCtl = Get.find<HistoryController>();
  @override
  void initState() {
    super.initState();
    historyCtl.getListHistoryDay();
  }

  @override
  Widget build(BuildContext context) {
    return BodyCustom(
      appbar: AppbarBase(
        title: GradientText(
          L.history.tr,
          gradient: GlobalColors.linearPrimary2,
          style: GlobalTextStyles.font20w600ColorWhite,
        ),
      ),
      edgeInsetsPadding: EdgeInsets.symmetric(horizontal: 16.0),
      isShowBgImages: false,
      child: Obx(
        () => historyCtl.listHistoryDay.isNotEmpty
            ? SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    historyCtl.listHistoryDay.length,
                    (index) {
                      History history = historyCtl.listHistoryDay[
                          historyCtl.listHistoryDay.length - index - 1];
                      return CustomItemRecent(
                        history: history,
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => Dialog(
                              child: DialogDeleteRecord(
                                ontap: () {
                                  historyCtl.deleteRecord(history, 0);
                                },
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
            )
            : Center(
                child: Column(
                  children: [
                    SvgPicture.asset("assets/icons/no_recent.svg"),
                    SizedBox(
                      height: 16.0,
                    ),
                    Text(
                      L.noRecent.tr,
                      style: GlobalTextStyles.font14w600ColorWhite
                          .copyWith(color: Color(0xFF4B5563)),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
