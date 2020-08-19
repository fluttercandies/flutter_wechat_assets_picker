///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2020/8/19 10:29
///
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  /// Height exclude top and bottom safe height.
  /// 去除顶部和底部安全区域的高度
  static double get safeHeight => height - topSafeHeight - bottomSafeHeight;

  /// Method to update status bar's style.
  /// 更新状态栏样式的方法
  static void updateStatusBarStyle(SystemUiOverlayStyle style) {
    SystemChrome.setSystemUIOverlayStyle(style);
  }

  /// Scale factor for the text.
  /// 文字缩放的倍数
  static double get textScaleFactor => mediaQuery.textScaleFactor;

  /// Return a fixed font size according to text scale factor.
  /// 根据文字缩放计算出的固定文字大小
  static double fixedFontSize(double fontSize) => fontSize / textScaleFactor;
}
