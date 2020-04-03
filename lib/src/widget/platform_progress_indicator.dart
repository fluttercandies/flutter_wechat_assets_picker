///
/// [Author] Alex (https://github.com/AlexVincent525)
/// [Date] 2020/3/31 17:47
///
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Progress Indicator. Used in loading data.
/// 根据平台判断的进度指示器
class PlatformProgressIndicator extends StatelessWidget {
  const PlatformProgressIndicator({
    Key key,
    this.strokeWidth = 4.0,
    this.radius = 10.0,
    this.size = 48.0,
    this.color,
    this.value,
    this.brightness,
  }) : super(key: key);

  final double strokeWidth;
  final double radius;
  final double size;
  final Color color;
  final double value;
  final Brightness brightness;

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: Size.square(size),
      child: Platform.isIOS
          ? CupertinoTheme(
              data: const CupertinoThemeData(brightness: Brightness.dark),
              child: CupertinoActivityIndicator(radius: radius),
            )
          : CircularProgressIndicator(
              strokeWidth: strokeWidth,
              valueColor:
                  color != null ? AlwaysStoppedAnimation<Color>(color) : null,
              value: value,
            ),
    );
  }
}
