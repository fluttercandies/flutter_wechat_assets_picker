///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2020/8/19 10:34
///
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

typedef CNP<T extends ChangeNotifier?> = ChangeNotifierProvider<T>;

extension BuildContextExtension on BuildContext {
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  ThemeData get themeData => Theme.of(this);

  double get topPadding => mediaQuery.padding.top;

  double get bottomPadding => mediaQuery.padding.bottom;

  double get bottomInsets => mediaQuery.viewInsets.bottom;
}

extension BrightnessExtension on Brightness {
  bool get isDark => this == Brightness.dark;

  bool get isLight => this == Brightness.light;
}

extension ColorExtension on Color {
  bool get isTransparent => this == Colors.transparent || alpha == 0x00;
}

extension ThemeDataExtension on ThemeData {
  Brightness get effectiveBrightness =>
      appBarTheme.systemOverlayStyle?.statusBarBrightness ?? brightness;
}
