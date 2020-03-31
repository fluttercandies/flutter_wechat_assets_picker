///
/// [Author] Alex (https://github.com/AlexVincent525)
/// [Date] 2020/3/31 16:02
///
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class Screens {
  const Screens._();

  static MediaQueryData get mediaQuery => MediaQueryData.fromWindow(ui.window);

  static double get width => mediaQuery.size.width;

  static double get height => mediaQuery.size.height;

  static double get topSafeHeight => mediaQuery.padding.top;

  static double get bottomSafeHeight => mediaQuery.padding.bottom;
}
