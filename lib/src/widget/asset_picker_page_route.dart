// Copyright 2019 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by an Apache license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';

/// Build [AssetPickerPageRoute] with the given generic type.
/// 构建匹配泛型的 [AssetPickerPageRoute]
typedef AssetPickerPageRouteBuilder<T> = AssetPickerPageRoute<T> Function(
  Widget picker,
);

/// Built a slide page transition for the picker.
/// 为选择器构造一个上下进出的页面过渡动画
class AssetPickerPageRoute<T> extends PageRoute<T> {
  AssetPickerPageRoute({
    required this.builder,
    this.transitionCurve = Curves.easeIn,
    this.transitionDuration = const Duration(milliseconds: 250),
    this.barrierColor,
    this.barrierDismissible = false,
    this.barrierLabel,
    this.maintainState = true,
    this.opaque = true,
    this.canTransitionFromPredicate,
    super.settings,
  });

  final WidgetBuilder builder;

  final Curve transitionCurve;
  @override
  final Duration transitionDuration;

  @override
  final Color? barrierColor;
  @override
  final bool barrierDismissible;
  @override
  final String? barrierLabel;
  @override
  final bool opaque;
  @override
  final bool maintainState;

  final bool Function(TransitionRoute<dynamic>)? canTransitionFromPredicate;

  /// The curved animation.
  CurvedAnimation? _curvedAnimation;

  @override
  void dispose() {
    _curvedAnimation?.dispose();
    super.dispose();
  }

  @override
  bool canTransitionFrom(TransitionRoute<dynamic> previousRoute) =>
      canTransitionFromPredicate?.call(previousRoute) ?? false;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return builder(context);
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    _curvedAnimation ??=
        CurvedAnimation(curve: transitionCurve, parent: animation);
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(
        _curvedAnimation!,
      ),
      child: ClipRect(child: child), // Clip the overflowed part.
    );
  }
}

/// Build [AssetPickerViewerPageRoute] with the given generic type.
/// 构建匹配泛型的 [AssetPickerViewerPageRoute]
typedef AssetPickerViewerPageRouteBuilder<T> = AssetPickerViewerPageRoute<T>
    Function(Widget viewer);

/// Built a fade transition for the viewer.
/// 为预览器构造一个渐变的页面过渡动画
class AssetPickerViewerPageRoute<T> extends PageRoute<T> {
  AssetPickerViewerPageRoute({
    required this.builder,
    this.transitionCurve = Curves.easeIn,
    this.transitionDuration = const Duration(milliseconds: 250),
    this.barrierColor,
    this.barrierDismissible = false,
    this.barrierLabel,
    this.maintainState = true,
    this.opaque = true,
    this.canTransitionFromPredicate,
    super.settings,
  });

  final WidgetBuilder builder;

  final Curve transitionCurve;
  @override
  final Duration transitionDuration;

  @override
  final Color? barrierColor;
  @override
  final bool barrierDismissible;
  @override
  final String? barrierLabel;
  @override
  final bool opaque;
  @override
  final bool maintainState;

  final bool Function(TransitionRoute<dynamic>)? canTransitionFromPredicate;

  @override
  bool canTransitionFrom(TransitionRoute<dynamic> previousRoute) =>
      canTransitionFromPredicate?.call(previousRoute) ?? false;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return builder(context);
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(opacity: animation, child: child);
  }
}
