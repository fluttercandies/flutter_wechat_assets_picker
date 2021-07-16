import 'package:flutter/material.dart';

class ScaleText extends StatelessWidget {
  const ScaleText(
    this.text, {
    this.style,
    this.strutStyle,
    this.maxLines,
    this.overflow,
    this.textAlign,
    this.textDirection,
    this.maxScaleFactor = 1.3,
  });

  final String text;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final double? maxScaleFactor;

  @override
  Widget build(BuildContext context) {
    final Text textWidget = Text(
      text ?? '',
      style: style,
      strutStyle: strutStyle,
      maxLines: maxLines,
      textAlign: textAlign,
      overflow: overflow,
      textDirection: textDirection,
    );
    if (maxScaleFactor != null) {
      final MediaQueryData mqd = MediaQuery.of(context);
      final double effectiveFactor =
          mqd.textScaleFactor.clamp(0.9, maxScaleFactor!).toDouble();
      return MediaQuery(
        data: mqd.copyWith(textScaleFactor: effectiveFactor),
        child: textWidget,
      );
    }
    return textWidget;
  }
}
