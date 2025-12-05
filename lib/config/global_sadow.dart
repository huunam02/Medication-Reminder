import 'package:flutter/material.dart';

class GlobalShadow {
  static List<BoxShadow> primary = [
    BoxShadow(
      color: Color(0x0D000000), // tương đương với #0000000D
      blurRadius: 16, // tương đương với giá trị 16px
      offset: Offset(0, 0), // không dịch chuyển theo trục x, y
      spreadRadius: 0, // tương đương với 0px
    ),
  ];
}
