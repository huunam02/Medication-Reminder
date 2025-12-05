import '/util/ads_helper.dart';
import '/util/audio_player_helper.dart';
import '/config/global_color.dart';
import '/config/global_text_style.dart';
import '/lang/l.dart';
import '/screen/create_drink/controller/create_drink_controller.dart';
import '/screen/create_drink/widget/cup_water_seekbar.dart';
import '/screen/setting/controller/setting_controller.dart';
import '/screen/water/controller/warter_controller.dart';
import '/widget/appbar_base.dart';
import '/widget/gradient_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class CreateDrinkScreen extends StatefulWidget {
  const CreateDrinkScreen({super.key});

  @override
  State<CreateDrinkScreen> createState() => _CreateDrinkScreenState();
}

class _CreateDrinkScreenState extends State<CreateDrinkScreen> {
  final textCtr = TextEditingController();
  final waterCtr = Get.find<WarterController>();
  final settingCtl = Get.find<SettingController>();
  bool isValid = false;
  final createDrinkCtl = Get.find<CreateDrinkController>();
  VoidCallback? _pendingAction;
  @override
  void initState() {
    super.initState();
    textCtr.text = "0";
    createDrinkCtl.hideLoading();
  }

  void _runPendingAction() {
    final action = _pendingAction;
    _pendingAction = null;
    if (action != null) action();
  }

  void _performSaveIfValid() {
    try {
      if (isValid) {
        Get.back();
        int result = 0;
        if (settingCtl.unit.value == "L") {
          result = (double.parse(textCtr.text) * 1000).toInt();
        } else if (settingCtl.unit.value == 'fl oz') {
          result = (double.parse(textCtr.text) * 29.00).toInt();
        } else {
          result = int.parse(textCtr.text);
        }
        createDrinkCtl.waterLevel.value = 0.12;
        waterCtr.addDrank(result, true, null);
        AudioPlayerHelper.playAudio("sounds/water.mp3");
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Color(0xFFFAFAFA),
        appBar: AppbarBase(
          leading: GestureDetector(
            onTap: () {
              createDrinkCtl.waterLevel.value = 0.12;
              Get.back();
            },
            child: Icon(Icons.arrow_back_ios_new_rounded, size: 24.0),
          ),
          title: GradientText(
            L.createDrink.tr,
            gradient: GlobalColors.linearPrimary2,
            style: GlobalTextStyles.font20w600ColorWhite,
          ),
        ),
        body: Stack(
          children: [
            SizedBox.expand(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 40.0,
                    ),
                    CupWaterSeekbarCusstom(
                      onChange: (value) {
                        setState(() {
                          textCtr.text = convertUnitData(value.toInt());
                        });
                        try {
                          if (textCtr.text.isNotEmpty &&
                              double.tryParse(textCtr.text) != null &&
                              double.tryParse(textCtr.text)! > 0) {
                            setState(() {
                              isValid = true;
                            });
                          }
                        } catch (e) {
                          setState(() {
                            isValid = false;
                          });
                          print(e);
                        }
                      },
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    SizedBox(
                      width: 148.0,
                      height: 44.0,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SvgPicture.asset("assets/icons/pen.svg"),
                          Expanded(
                            child: TextField(
                              onChanged: (value) {
                                if (value.isNotEmpty &&
                                    double.tryParse(value) != null &&
                                    double.tryParse(value)! > 0.0) {
                                  int result = 0;
                                  setState(() {
                                    isValid = true;
                                  });
                                  if (settingCtl.unit.value == "L") {
                                    result = (double.parse(textCtr.text) * 1000)
                                        .toInt();
                                  } else if (settingCtl.unit.value == 'fl oz') {
                                    result =
                                        (double.parse(textCtr.text) * 29.00)
                                            .toInt();
                                  } else {
                                    result = int.parse(textCtr.text);
                                  }

                                  if (result >= 700) {
                                    createDrinkCtl.waterLevel.value = 0.56;
                                  } else if (result < 700 && result > 0) {
                                    createDrinkCtl.waterLevel.value =
                                        ((0.56 - 0.12) / 700) * result + 0.12;
                                  } else {
                                    createDrinkCtl.waterLevel.value = 0.12;
                                    setState(() {
                                      isValid = true;
                                    });
                                  }
                                } else {
                                  setState(() {
                                    isValid = false;
                                  });
                                }
                              },
                              controller: textCtr,
                              textAlign: TextAlign.center,
                              textAlignVertical: TextAlignVertical.center,
                              keyboardType: TextInputType.number,
                              style: GlobalTextStyles.font32w600ColorBlack,
                              decoration: InputDecoration(
                                isCollapsed: true,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                                hintStyle: GlobalTextStyles.font14w600ColorBlack
                                    .copyWith(color: Color(0xFF4B5563)),
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: GlobalColors.newtral)),
                              ),
                            ),
                          ),
                          Text(
                            " ${settingCtl.unit.value}",
                            style: GlobalTextStyles.font14w600ColorBlack,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 42,
                    ),
                    GestureDetector(
                      onTap: () async {
                        _pendingAction = _performSaveIfValid;

                        _runPendingAction();
                      },
                      child: Container(
                        height: 56.0,
                        width: 192.0,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            gradient: isValid
                                ? GlobalColors.linearPrimary2
                                : GlobalColors.linearPrimary2.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(28.0)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset("assets/icons/add.svg",
                                height: 24.0,
                                width: 24.0,
                                color: isValid
                                    ? null
                                    : Colors.black.withOpacity(.4)),
                            SizedBox(
                              width: 12.0,
                            ),
                            Text(
                              L.save.tr,
                              style: GlobalTextStyles.font16w600ColorWhite
                                  .copyWith(
                                      color: isValid
                                          ? null
                                          : Colors.black.withOpacity(.4)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Obx(
              () => createDrinkCtl.isLoading.value
                  ? Container(
                      height: double.infinity,
                      width: double.infinity,
                      alignment: Alignment.center,
                      color: GlobalColors.bg1,
                      child: CircularProgressIndicator(),
                    )
                  : SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  String convertUnitData(int ml) {
    if (settingCtl.unit.value == "ml") {
      return ml.toString();
    } else if (settingCtl.unit.value == "L") {
      return (ml.toDouble() / 1000).toStringAsFixed(1);
    } else {
      return (ml.toDouble() / 29.00).toStringAsFixed(1);
    }
  }
}
