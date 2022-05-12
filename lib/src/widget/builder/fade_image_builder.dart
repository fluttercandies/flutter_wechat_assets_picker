// Copyright 2019 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by an Apache license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';

class FadeImageBuilder extends StatelessWidget {
  const FadeImageBuilder({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 150),
      builder: (_, double value, Widget? w) => Opacity(
        opacity: value,
        child: w,
      ),
      child: child,
    );
  }
}
