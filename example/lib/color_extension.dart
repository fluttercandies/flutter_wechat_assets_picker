///
/// [Author] Alex (https://github.com/AlexVincent525)
/// [Date] 2020/4/1 17:55
///
import 'package:flutter/material.dart';

extension ColorExtension on Color {
  MaterialColor get swatch => Colors.primaries.firstWhere(
    (MaterialColor c) => c.value == value,
    orElse: () => _swatch,
  );

  MaterialColor get _swatch => MaterialColor(value, getMaterialColorValues);

  Map<int, Color> get getMaterialColorValues => <int, Color>{
    50: _swatchShade(50),
    100: _swatchShade(100),
    200: _swatchShade(200),
    300: _swatchShade(300),
    400: _swatchShade(400),
    500: _swatchShade(500),
    600: _swatchShade(600),
    700: _swatchShade(700),
    800: _swatchShade(800),
    900: _swatchShade(900),
  };

  Color _swatchShade(int swatchValue) =>
      HSLColor.fromColor(this).withLightness(1 - (swatchValue / 1000)).toColor();
}