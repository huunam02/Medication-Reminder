import '/config/global_color.dart';
import '/screen/config/global_text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';
import '/screen/water/controller/warter_controller.dart'; // Đảm bảo import đúng

class CupRiverAnimation extends StatefulWidget {
  const CupRiverAnimation({super.key});

  @override
  State<CupRiverAnimation> createState() => _CupRiverAnimationState();
}

class _CupRiverAnimationState extends State<CupRiverAnimation> {
  final WarterController waterController = Get.find<WarterController>();

  SMIInput<double>? _waterLevelInput;

  void _onRiveInit(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(artboard, 'default');
    if (controller != null) {
      artboard.addController(controller);
      _waterLevelInput = controller.findInput<double>('input');
      if (_waterLevelInput != null) {
        _waterLevelInput!.value = waterController.waterLevel.value * 100;
        waterController.waterLevel.listen((value) {
          _waterLevelInput?.value = (value * 100).clamp(0, 100);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        children: [
          SizedBox.expand(
            child: RiveAnimation.asset(
              'assets/rivers/cup.riv',
              fit: BoxFit.cover,
              onInit: _onRiveInit,
            ),
          ),
          Center(
            child: Obx(() {
              double waterLevel = waterController.waterLevel.value;
              double percentage =
                  (waterLevel / waterController.maxWaterLevel * 100)
                      .clamp(0, 100);
              Color textColor =
                  percentage < 50 ? GlobalColors.colorLastLinear : Colors.white;

              return Text(
                '${percentage.toStringAsFixed(0)} %',
                style: GlobalTextStyles.font24w700ColorWhite
                    .copyWith(color: textColor),
              );
            }),
          ),
        ],
      ),
    );
  }
}
