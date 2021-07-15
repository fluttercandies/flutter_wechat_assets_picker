import 'package:flutter/material.dart';

class ScaleText extends StatelessWidget {
  const ScaleText(this.text,
      {this.style,
      this.strutStyle,
      this.maxLines,
      this.overflow,
      this.textAlign,
      this.textDirection,
      this.maxScaleFactor});

  final String? text;
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
      final MediaQueryData mediaQueryData = MediaQuery.of(context);
      final num constrainedTextScaleFactor =
          mediaQueryData.textScaleFactor.clamp(0.9, maxScaleFactor!);
      return MediaQuery(
        data: mediaQueryData.copyWith(
            textScaleFactor: constrainedTextScaleFactor as double?),
        child: textWidget,
      );
    }
    return textWidget;
  }
}
