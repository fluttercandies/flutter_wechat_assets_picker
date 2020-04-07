///
/// [Author] Alex (https://github.com/AlexVincent525)
/// [Date] 2020/3/31 16:02
///
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class Screens {
  const Screens._();

  static MediaQueryData get mediaQuery => MediaQueryData.fromWindow(ui.window);

  static double get scale => mediaQuery.devicePixelRatio;

  static double get width => mediaQuery.size.width;

  static int get widthPixels => (width * scale).toInt();

  static double get height => mediaQuery.size.height;

  static int get heightPixels => (height * scale).toInt();

  static double get topSafeHeight => mediaQuery.padding.top;

  static double get bottomSafeHeight => mediaQuery.padding.bottom;
}
