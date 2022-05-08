// Copyright 2019 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by an Apache license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';

class ValueListenableBuilder2<A, B> extends StatelessWidget {
  const ValueListenableBuilder2({
    Key? key,
    required this.firstNotifier,
    required this.secondNotifier,
    required this.builder,
    this.child,
  }) : super(key: key);

  final ValueNotifier<A> firstNotifier;
  final ValueNotifier<B> secondNotifier;
  final Widget Function(BuildContext, A, B, Widget?) builder;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<A>(
      valueListenable: firstNotifier,
      builder: (_, A first, __) => ValueListenableBuilder<B>(
        valueListenable: secondNotifier,
        builder: (BuildContext context, B second, Widget? w) {
          return builder(context, first, second, w);
        },
        child: child,
      ),
    );
  }
}
