import '/config/global_color.dart';
import '/screen/create_drink/controller/create_drink_controller.dart';
import '/screen/create_drink/widget/divider_water.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class CupWaterSeekbarCusstom extends StatefulWidget {
  const CupWaterSeekbarCusstom({super.key, required this.onChange});
  final ValueChanged<double> onChange;
  @override
  State<CupWaterSeekbarCusstom> createState() => _CupWaterSeekbarCusstomState();
}

class _CupWaterSeekbarCusstomState extends State<CupWaterSeekbarCusstom> {
  double _startDragPosition = 0.0;
  static const double maxWater = 700;

  final createDrinkCtl = Get.find<CreateDrinkController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: GlobalColors.container1,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 32.0),
      child: AspectRatio(
        aspectRatio: 255 / 284,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Obx(
                () => Container(
                  alignment: Alignment.topCenter,
                  height: createDrinkCtl.waterLevel.value * 650,
                  width: double.infinity,
                  child: Column(
                    children: [
                      Transform.rotate(
                          angle: 3.14159,
                          child: Lottie.asset(
                            "assets/lotties/water2.json",
                          )),
                      Expanded(
                          child: Container(
                        alignment: Alignment.topCenter,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          // gradient: GlobalColors.linearPrimary2,
                          color: GlobalColors.linearPrimary2.colors.first,
                        ),
                      ))
                    ],
                  ),
                ),
              ),
            ),
            Image.asset("assets/images/create_drink3.png"),
            Padding(
              padding: const EdgeInsets.only(top: 48.0, bottom: 12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DividerWaterCusstom(),
                  DividerWaterCusstom(),
                  DividerWaterCusstom(),
                  DividerWaterCusstom(),
                  DividerWaterCusstom(),
                  DividerWaterCusstom(),
                  DividerWaterCusstom(),
                  DividerWaterCusstom(),
                ],
              ),
            ),
            AspectRatio(
              aspectRatio: 255 / 284,
              child: Column(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onVerticalDragStart: (details) {
                        _startDragPosition = details.localPosition.dy;
                      },
                      onVerticalDragUpdate: (details) {
                        double delta =
                            _startDragPosition - details.localPosition.dy;

                        double temp =
                            (createDrinkCtl.waterLevel.value + delta / 600)
                                .clamp(0.0, 1.0);
                        if (temp < 0.56 && temp >= 0.11) {
                          createDrinkCtl.waterLevel.value = temp;
                          _startDragPosition = details.localPosition.dy;
                          if (temp >= 0.55) {
                            widget.onChange(maxWater);
                          } else if (temp <= 0.12) {
                            widget.onChange(0);
                          } else {
                            widget.onChange(
                                (createDrinkCtl.waterLevel.value - 0.12) /
                                    (0.55 - 0.12) *
                                    maxWater);
                          }
                        }
                      },
                      child: SizedBox(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Obx(
                            () => Container(
                              alignment: Alignment.topCenter,
                              height: createDrinkCtl.waterLevel.value * 650,
                              width: double.infinity,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(
                                      child: Container(
                                    padding: EdgeInsets.only(top: 36),
                                    alignment: Alignment.topCenter,
                                    width: double.infinity,
                                    color: Colors.transparent,
                                    child: Image.asset(
                                      "assets/images/seekbar2.png",
                                      height: 44.w,
                                      width: 44.w,
                                    ),
                                  ))
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
