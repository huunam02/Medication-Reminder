import '/util/audio_player_helper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '/config/global_color.dart';
import '/config/global_text_style.dart';
import '/model/history.dart';
import '/screen/water/controller/warter_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class WaterHistoryItem extends StatefulWidget {
  const WaterHistoryItem({super.key, required this.history});
  final History history;

  @override
  State<WaterHistoryItem> createState() => _WaterHistoryItemState();
}

class _WaterHistoryItemState extends State<WaterHistoryItem> {
  final waterCtr = Get.find<WarterController>();
  bool isClicking = false;
  void checkSpam(ontap) async {
    if (!isClicking) {
      isClicking = true;
      ontap();
      await Future.delayed(const Duration(seconds: 1));
      isClicking = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => checkSpam(() {
        AudioPlayerHelper.playAudio("sounds/water.mp3");
        waterCtr.addDrank(widget.history.ml!, false, widget.history);
      }),
      child: Container(
        margin: EdgeInsets.only(left: 16.0),
        height: 100.h,
        width: 110.h,
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: GlobalColors.container1),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/cup2.png",
                  height: 34,
                  width: 27,
                ),
                SizedBox(
                  height: 8.0,
                ),
                Text(
                  "+ ${convertUnitData(widget.history.ml!, widget.history.unit!)}${widget.history.unit}",
                  style: GlobalTextStyles.font12w400ColorNewtral,
                )
              ],
            ),
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () => checkSpam(() {
                  waterCtr.deleteWater(widget.history);
                }),
                child: SvgPicture.asset(
                  "assets/icons/delete.svg",
                  height: 20.0,
                  width: 20.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String convertUnitData(int ml, String unit) {
    if (unit == "ml") {
      return ml.toString();
    } else if (unit == "L") {
      return (ml.toDouble() / 1000).toStringAsFixed(1);
    } else {
      return (ml.toDouble() / 29.00).toStringAsFixed(1);
    }
  }
}
