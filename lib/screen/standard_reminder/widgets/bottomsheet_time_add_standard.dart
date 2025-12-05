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
      required this.onChangeTitle});
  final int defaultHour;
  final int defaultMinute;
  final GestureTapCallback onClickSave;
  final ValueChanged<int> onChangeHour;
  final ValueChanged<int> onChangeMinute;
  final ValueChanged<String> onChangeTitle;

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

  late FixedExtentScrollController hourController;
  late FixedExtentScrollController minuteController;
  final _titleEdittingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    hour = widget.defaultHour % totalHours;
    minute = widget.defaultMinute % totalMinutes;
    // Khởi tạo các FixedExtentScrollController
    hourController = FixedExtentScrollController(initialItem: hour);
    minuteController = FixedExtentScrollController(initialItem: minute);
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
      height: h * 0.6,
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
                  hintText: L.enterTitle.tr,
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
}
