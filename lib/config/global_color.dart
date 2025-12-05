import 'package:flutter/material.dart';

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

class GlobalColors {
  static LinearGradient linearPrimary1 = const LinearGradient(
    colors: [
      Color(0xFF4350B0),
      Color(0xFF83D2F7),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient linearContainer2 = const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF1D273E),
      Color(0xFF212B45),
    ],
    stops: [0.0, 1.0],
  );

  static LinearGradient linearPrimary = const LinearGradient(
    begin: Alignment.topCenter, // Tương đương góc 0 độ
    end: Alignment.bottomCenter, // Tương đương góc 180 độ
    colors: [
      Color(0xFF00E4BE), // Màu #00E4BE
      Color(0xFF00977C), // Màu #00977C
    ],
  );
  static LinearGradient linearPrimary2 = LinearGradient(
    begin: Alignment(0.6, -1.0), // tương đương khoảng 156.44 độ
    end: Alignment(-1.0, 1.0),
    colors: [
      Color(0xFF4B8CE7), // Màu bắt đầu
      Color(0xFF186EE7), // Màu kết thúc
    ],
    stops: [0.0, 0.6518], // Tương ứng với 0% và 65.18%
  );
  static Color bg1 = Color(0xFFF0F0F0);
  static Color color2 = const Color(0xFF3E3F42);
  static Color newtral = const Color(0xFF6B7280);
  static Color colorLastLinear = const Color(0xFF186EE7);
  static Color container1 = Colors.white;
  static Color container2 = const Color(0xFF21374A);
}
