// Copyright 2019 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by an Apache license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:wechat_assets_picker_demo/l10n/gen/app_localizations.dart';

extension BuildContextExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}

extension BrightnessExtension on Brightness {
  bool get isDark => this == Brightness.dark;

  bool get isLight => this == Brightness.light;

  Brightness get reverse =>
      this == Brightness.light ? Brightness.dark : Brightness.light;
}

extension ColorExtension on Color {
  MaterialColor get swatch => Colors.primaries.firstWhere(
        (Color c) => c.value == value,
        orElse: () => _swatch,
      );

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

  MaterialColor get _swatch => MaterialColor(value, getMaterialColorValues);

  Color _swatchShade(int swatchValue) => HSLColor.fromColor(this)
      .withLightness(1 - (swatchValue / 1000))
      .toColor();
}
