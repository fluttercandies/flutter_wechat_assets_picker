///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2020/8/19 10:34
///
import 'package:flutter/material.dart';

extension BuildContextExtension on BuildContext {
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  ThemeData get themeData => Theme.of(this);
}

extension BrightnessExtension on Brightness {
  bool get isDark => this == Brightness.dark;

  bool get isLight => this == Brightness.light;
}

extension ColorExtension on Color {
  bool get isTransparent => this == Colors.transparent;
}

extension ThemeDataExtension on ThemeData {
  Brightness get effectiveBrightness => appBarTheme.brightness ?? brightness;
}
