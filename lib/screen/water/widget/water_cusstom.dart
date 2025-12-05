import '/config/global_color.dart';
import '/screen/water/widget/percent_indicator_custom.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class WaterCusstom extends StatefulWidget {
  const WaterCusstom({super.key, required this.waterLevel});
  final double waterLevel;
  @override
  State<WaterCusstom> createState() => _WaterCusstomState();
}

class _WaterCusstomState extends State<WaterCusstom> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: GlobalColors.container1,
      width: double.infinity,
      child: AspectRatio(
        aspectRatio: 360 / 380,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                alignment: Alignment.topCenter,
                height: widget.waterLevel * 380,
                width: double.infinity,
                child: Column(
                  children: [
                    Transform.rotate(
                        angle: 3.14159,
                        child: Lottie.asset(
                          "assets/lotties/water.json",
                        )),
                    Expanded(
                        child: Container(
                      alignment: Alignment.topCenter,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: GlobalColors.linearPrimary,
                      ),
                    ))
                  ],
                ),
              ),
            ),
            Image.asset("assets/images/water_home.png"),
            Padding(
              padding: const EdgeInsets.only(top: 38.0, bottom: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PercentIndicatorCustom(
                      isSelected: widget.waterLevel == 0.98, val: "100"),
                  PercentIndicatorCustom(
                      isSelected:
                          widget.waterLevel >= 0.7 && widget.waterLevel < 0.85,
                      val: "75"),
                  PercentIndicatorCustom(
                      isSelected:
                          widget.waterLevel >= 0.55 && widget.waterLevel < 0.7,
                      val: "50"),
                  PercentIndicatorCustom(
                      isSelected:
                          widget.waterLevel >= 0.3 && widget.waterLevel < 0.55,
                      val: "25"),
                  PercentIndicatorCustom(
                      isSelected:
                          widget.waterLevel >= 0.186 && widget.waterLevel < 0.3,
                      val: "0")
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
