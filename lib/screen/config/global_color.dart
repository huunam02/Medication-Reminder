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

  static LinearGradient linearPrimary2 = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF4350B0),
      Color(0xFF3076C9),
    ],
    stops: [-0.0033, 0.9967],
  );

  static Color color2 = const Color(0xFF3E3F42);
  static Color primary= const Color(0xFF55FDFD);
}
