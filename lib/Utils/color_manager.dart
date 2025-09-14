import 'package:flutter/material.dart';

class ColorManager {
  static const primaryColor = Color(0xFF191933);
  static const secondaryColor = Color(0xFF146AFF);
  static const backGround = Color(0xFFF5F6FA);
  static const colorRed = Color(0xFFEF6060);
  static const surfaceWhite = Color(0xFFFFFBFA);
  static const ratingColor = Color(0xFFEE5A30);
  static const blackColor = Color(0xFF313131);
  static const appHeader = Color(0xFFb2d2ee);

  static const darkGrey = Color(0xFF525252);
  static const grey = Color(0xFF737477);
  static const lightGrey = Color(0xFF9E9E9E);
  static const pinkColor = Color(0xFFFE2C55);
  static const white = Color(0xFFFFFFFF);
}

extension HexColor on Color {
  static Color fromHex(String hexColorString) {
    hexColorString = hexColorString.replaceAll('#', '');
    if (hexColorString.length == 6) {
      hexColorString = 'FF$hexColorString';
    }
    return Color(int.parse(hexColorString, radix: 16));
  }
}
