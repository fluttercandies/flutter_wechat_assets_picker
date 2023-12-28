// Copyright 2019 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by an Apache license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';

class ScaleText extends StatelessWidget {
  const ScaleText(
    this.text, {
    super.key,
    this.style,
    this.strutStyle,
    this.maxLines,
    this.overflow,
    this.textAlign,
    this.textDirection,
    this.semanticsLabel,
    this.softWrap,
    this.minScaleFactor = 0.7,
    this.maxScaleFactor = 1.3,
  });

  final String text;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final String? semanticsLabel;
  final bool? softWrap;

  final double minScaleFactor;
  final double maxScaleFactor;

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mqd = MediaQuery.of(context);
    final double effectiveFactor = mqd.textScaleFactor.clamp(
      minScaleFactor,
      maxScaleFactor,
    );
    return MediaQuery(
      data: mqd.copyWith(textScaleFactor: effectiveFactor),
      child: Text(
        text,
        style: style,
        strutStyle: strutStyle,
        maxLines: maxLines,
        textAlign: textAlign,
        overflow: overflow,
        textDirection: textDirection,
        semanticsLabel: semanticsLabel,
        softWrap: softWrap,
      ),
    );
  }
}
