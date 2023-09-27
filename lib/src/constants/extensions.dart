// Copyright 2019 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by an Apache license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

typedef CNP<T extends ChangeNotifier?> = ChangeNotifierProvider<T>;

extension BuildContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);

  IconThemeData get iconTheme => IconTheme.of(this);

  TextTheme get textTheme => Theme.of(this).textTheme;

  double get topPadding => MediaQuery.paddingOf(this).top;

  double get bottomPadding => MediaQuery.paddingOf(this).bottom;

  double get bottomInsets => MediaQuery.viewInsetsOf(this).bottom;
}

extension BrightnessExtension on Brightness {
  bool get isDark => this == Brightness.dark;

  bool get isLight => this == Brightness.light;

  Brightness get reverse =>
      this == Brightness.light ? Brightness.dark : Brightness.light;
}

extension ColorExtension on Color {
  bool get isTransparent => this == Colors.transparent || alpha == 0x00;
}

extension ThemeDataExtension on ThemeData {
  Brightness get effectiveBrightness =>
      appBarTheme.systemOverlayStyle?.statusBarBrightness ?? brightness;
}
