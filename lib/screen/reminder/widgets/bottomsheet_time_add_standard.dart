import 'package:flutter_screenutil/flutter_screenutil.dart';
import '/lang/l.dart';
import 'package:get/get.dart';
import '/config/global_color.dart';
import '/config/global_text_style.dart';
import 'package:flutter/material.dart';

class BottomsheetTimeAddStandard extends StatefulWidget {
  const BottomsheetTimeAddStandard(
      {super.key,
      required this.onChangeHour,
      required this.onChangeMinute,
      required this.defaultHour,
      required this.defaultMinute,
      required this.onClickSave,
      required this.onChangeTitle,
      required this.onChangeQuantity,
      required this.onChangeRepeatDays});
  final int defaultHour;
  final int defaultMinute;
  final GestureTapCallback onClickSave;
  final ValueChanged<int> onChangeHour;
  final ValueChanged<int> onChangeMinute;
  final ValueChanged<String> onChangeTitle;
  final ValueChanged<String> onChangeQuantity;
  final ValueChanged<String> onChangeRepeatDays;

  @override
  State<BottomsheetTimeAddStandard> createState() =>
      __BottomsheetTimeAddStandardState();
}

class __BottomsheetTimeAddStandardState
    extends State<BottomsheetTimeAddStandard> {
  int hour = 12;
  int minute = 30;
  final int totalHours = 24;
  final int totalMinutes = 60;
  List<int> selectedDays = [1, 2, 3, 4, 5, 6, 7]; // Default all days
  bool isRepeat = true;

  late FixedExtentScrollController hourController;
  late FixedExtentScrollController minuteController;
  final _titleEdittingController = TextEditingController();
  final _quantityEdittingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    hour = widget.defaultHour % totalHours;
    minute = widget.defaultMinute % totalMinutes;
    // Khởi tạo các FixedExtentScrollController
    hourController = FixedExtentScrollController(initialItem: hour);
    minuteController = FixedExtentScrollController(initialItem: minute);
    widget.onChangeRepeatDays(selectedDays.join(","));
  }

  @override
  void dispose() {
    hourController.dispose();
    minuteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    return Container(
      padding: const EdgeInsets.all(24.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: GlobalColors.container1,
        borderRadius: BorderRadius.circular(8.0),
      ),
      height: h * 0.75,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            L.addReminder.tr,
            style: GlobalTextStyles.font16w600ColorBlack,
          ),
          16.verticalSpace,
          Container(
            height: 60.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(24.0),
            ),
            child: Center(
              child: TextField(
                onChanged: (value) {
                  widget.onChangeTitle(value);
                },
                keyboardType: TextInputType.text,
                controller: _titleEdittingController,
                style: GlobalTextStyles.font14w600ColorBlack,
                maxLength: 30,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  isDense: true,
                  counterText: "",
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                  ),
                  hintText: L.enterMedicineName.tr,
                  hintStyle: GlobalTextStyles.font14w600ColorBlack
                      .copyWith(color: const Color(0xFF4B5563)),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          16.verticalSpace,
          Container(
            height: 60.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(24.0),
            ),
            child: Center(
              child: TextField(
                onChanged: (value) {
                  widget.onChangeQuantity(value);
                },
                keyboardType: TextInputType.number,
                controller: _quantityEdittingController,
                style: GlobalTextStyles.font14w600ColorBlack,
                maxLength: 5,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  isDense: true,
                  counterText: "",
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                  ),
                  hintText: L.quantityHint.tr,
                  hintStyle: GlobalTextStyles.font14w600ColorBlack
                      .copyWith(color: const Color(0xFF4B5563)),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          10.verticalSpace,
          Expanded(
            child: Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildNumberPicker(
                      totalItems: totalHours,
                      currentValue: hour,
                      controller: hourController,
                      onChanged: (value) {
                        setState(() {
                          hour = value % totalHours; // Cuộn vô tận cho giờ
                          widget.onChangeHour(hour);
                        });
                      },
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    _buildNumberPicker(
                      totalItems: totalMinutes,
                      currentValue: minute,
                      controller: minuteController,
                      onChanged: (value) {
                        setState(() {
                          minute = value % totalMinutes; // Cuộn vô tận cho phút
                          widget.onChangeMinute(minute);
                        });
                      },
                    ),
                  ],
                ),
                // Đường viền ở giữa cho phần tử được chọn
                Align(
                  alignment: Alignment.center,
                  child: Text(":"),
                ),
              ],
            ),
          ),
          16.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                L.repeat.tr,
                style: GlobalTextStyles.font16w600ColorBlack,
              ),
              Switch(
                value: isRepeat,
                onChanged: (value) {
                  setState(() {
                    isRepeat = value;
                    if (isRepeat) {
                      selectedDays = [1, 2, 3, 4, 5, 6, 7];
                    } else {
                      selectedDays = [];
                    }
                    widget.onChangeRepeatDays(selectedDays.join(","));
                  });
                },
                activeColor: GlobalColors.colorLastLinear,
              ),
            ],
          ),
          if (isRepeat) ...[
            16.verticalSpace,
            _buildDaySelector(),
          ],
          SizedBox(
            height: 16.0,
          ),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 44.0,
                    decoration: BoxDecoration(
                        color: GlobalColors.container2,
                        borderRadius: BorderRadius.circular(22.0)),
                    child: Text(
                      L.cancel.tr,
                      style: GlobalTextStyles.font14w400ColorWhite,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 8.0,
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (_titleEdittingController.text.isEmpty) {
                      Get.snackbar(L.error.tr, L.enterMedicineName.tr,
                          backgroundColor: Colors.white);
                      return;
                    }
                    if (_quantityEdittingController.text.isEmpty) {
                      Get.snackbar(L.error.tr, L.enterQuantity.tr,
                          backgroundColor: Colors.white);
                      return;
                    }
                    widget.onClickSave();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 44.0,
                    decoration: BoxDecoration(
                        gradient: GlobalColors.linearPrimary2,
                        borderRadius: BorderRadius.circular(22.0)),
                    child: Text(
                      L.save.tr,
                      style: GlobalTextStyles.font14w600ColorWhite,
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildNumberPicker({
    required int totalItems,
    required int currentValue,
    required FixedExtentScrollController controller,
    required ValueChanged<int> onChanged,
  }) {
    return SizedBox(
      width: 100,
      height: 312,
      child: ListWheelScrollView.useDelegate(
        controller: controller,
        itemExtent: 46,
        physics: const FixedExtentScrollPhysics(),
        perspective: 0.0001,
        onSelectedItemChanged: onChanged,
        childDelegate: ListWheelChildBuilderDelegate(
          builder: (context, index) {
            final displayValue = index % totalItems;
            final isSelected = displayValue == currentValue;
            TextStyle style = isSelected
                ? GlobalTextStyles.font16w600ColorBlack
                : GlobalTextStyles.font16w600ColorBlackOp38;
            return Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: isSelected
                    ? Border(
                        top: BorderSide(
                            color: GlobalColors.colorLastLinear, width: 2.0),
                        bottom: BorderSide(
                            color: GlobalColors.colorLastLinear, width: 2.0),
                      )
                    : null,
              ),
              child: Text(
                displayValue.toString().padLeft(2, '0'),
                style: style,
              ),
            );
          },
          childCount: totalItems * 1000,
        ),
      ),
    );
  }

  Widget _buildDaySelector() {
    final days = [
      L.mondayShort.tr,
      L.tuesdayShort.tr,
      L.wednesdayShort.tr,
      L.thursdayShort.tr,
      L.fridayShort.tr,
      L.saturdayShort.tr,
      L.sundayShort.tr,
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(7, (index) {
        final dayIndex = index + 1;
        final isSelected = selectedDays.contains(dayIndex);
        return GestureDetector(
          onTap: () {
            setState(() {
              if (isSelected) {
                if (selectedDays.length > 1) {
                  selectedDays.remove(dayIndex);
                }
              } else {
                selectedDays.add(dayIndex);
              }
              selectedDays.sort();
              widget.onChangeRepeatDays(selectedDays.join(","));
            });
          },
          child: Container(
            width: 36.w,
            height: 36.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? GlobalColors.colorLastLinear : Colors.white,
              border: Border.all(
                color: isSelected
                    ? GlobalColors.colorLastLinear
                    : Colors.grey.shade300,
              ),
            ),
            child: Text(
              days[index],
              style: isSelected
                  ? GlobalTextStyles.font14w600ColorWhite
                  : GlobalTextStyles.font14w600ColorBlack,
            ),
          ),
        );
      }),
    );
  }
}
