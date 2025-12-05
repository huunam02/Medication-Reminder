import '/config/global_color.dart';
import '/config/global_text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../lang/l.dart';

class DialogDeleteRecord extends StatelessWidget {
  const DialogDeleteRecord({super.key, required this.ontap});
  final GestureTapCallback ontap;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 328 / 200,
      child: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
            color: GlobalColors.container1,
            borderRadius: BorderRadius.circular(16)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              L.deleteRecord.tr,
              textAlign: TextAlign.center,
              style: GlobalTextStyles.font16w600ColorBlack,
            ),
            Text(
              L.areYouSureDelete.tr,
              textAlign: TextAlign.center,
              style: GlobalTextStyles.font14w400ColorNewtral,
            ),
            Row(
              children: [
                Expanded(
                    child: GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    height: 40.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(19),
                        color: GlobalColors.container2),
                    child: Center(
                      child: Text(
                        L.cancel.tr,
                        style: GlobalTextStyles.font14w400ColorWhite,
                      ),
                    ),
                  ),
                )),
                SizedBox(
                  width: 16.0,
                ),
                Expanded(
                    child: GestureDetector(
                  onTap: () {
                    ontap();
                  },
                  child: Container(
                    height: 40.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(19),
                        color: Color(0xFFD04B4B)),
                    child: Center(
                      child: Text(
                        L.delete.tr,
                        style: GlobalTextStyles.font14w600ColorWhite,
                      ),
                    ),
                  ),
                ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
