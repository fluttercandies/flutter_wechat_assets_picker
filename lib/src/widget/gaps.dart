// Copyright 2019 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by an Apache license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';

class Gap extends StatelessWidget {
  const Gap.h(
    double width, {
    super.key,
    double? height,
    this.color,
  })  : _width = width,
        _height = height;

  const Gap.v(
    double height, {
    super.key,
    double? width,
    this.color,
  })  : _width = width,
        _height = height;

  final double? _width;
  final double? _height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    Widget w = SizedBox(width: _width, height: _height);
    if (color != null) {
      w = ColoredBox(color: color!, child: w);
    }
    return w;
  }
}

class SliverGap extends StatelessWidget {
  const SliverGap.h(
    double width, {
    super.key,
    double? height,
    this.color,
  })  : _width = width,
        _height = height;

  const SliverGap.v(
    double height, {
    super.key,
    double? width,
    this.color,
  })  : _width = width,
        _height = height;

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
