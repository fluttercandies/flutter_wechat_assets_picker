///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2020/10/27 17:14
///
import 'package:flutter/material.dart';

class Gap extends StatelessWidget {
  const Gap.h(
    double width, {
    Key? key,
    double? height,
    this.color,
  })  : _width = width,
        _height = height,
        super(key: key);

  const Gap.v(
    double height, {
    Key? key,
    double? width,
    this.color,
  })  : _width = width,
        _height = height,
        super(key: key);

  final double? _width;
  final double? _height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    Widget _w = SizedBox(width: _width, height: _height);
    if (color != null) {
      _w = ColoredBox(color: color!, child: _w);
    }
    return _w;
  }
}

class SliverGap extends StatelessWidget {
  const SliverGap.h(
    double width, {
    Key? key,
    double? height,
    this.color,
  })  : _width = width,
        _height = height,
        super(key: key);

  const SliverGap.v(
    double height, {
    Key? key,
    double? width,
    this.color,
  })  : _width = width,
        _height = height,
        super(key: key);

  final double? _width;
  final double? _height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (_width != null) {
      child = Gap.h(_width!, height: _height, color: color);
    } else if (_height != null) {
      child = Gap.v(_height!, width: _width, color: color);
    } else {
      child = const SizedBox.shrink();
    }
    return SliverToBoxAdapter(child: child);
  }
}
