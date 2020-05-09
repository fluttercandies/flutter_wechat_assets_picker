///
/// [Author] Alex (https://github.com/AlexVincent525)
/// [Date] 2020/3/31 16:02
///
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// Screens utils with multiple properties access.
/// 获取屏幕各项属性的工具类
class Screens {
  const Screens._();

  /// Get [MediaQueryData] from [ui.window]
  /// 通过 [ui.window] 获取 [MediaQueryData]
  static MediaQueryData get mediaQuery => MediaQueryData.fromWindow(ui.window);

  /// The number of device pixels for each logical pixel.
  /// 设备每个逻辑像素对应的dp比例
  static double get scale => mediaQuery.devicePixelRatio;

  /// The horizontal extent of this size.
  /// 水平范围的大小
  static double get width => mediaQuery.size.width;

  /// The horizontal pixels of this size.
  /// 水平范围的像素值
  static int get widthPixels => (width * scale).toInt();

  /// The vertical extent of this size.
  /// 垂直范围的大小
  static double get height => mediaQuery.size.height;

  /// The vertical pixels of this size.
  /// 垂直范围的像素值
  static int get heightPixels => (height * scale).toInt();

  /// Top offset in the [ui.window], usually is the notch size.
  /// 从 [ui.window] 获取的顶部偏移（间距），通常是刘海的大小。
  static double get topSafeHeight => mediaQuery.padding.top;

  /// Bottom offset in the [ui.window], usually is the action bar/navigation bar size.
  /// 从 [ui.window] 获取的底部偏移（间距），通常是操作条/导航条的大小。
  static double get bottomSafeHeight => mediaQuery.padding.bottom;
}
