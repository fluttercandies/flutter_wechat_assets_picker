///
/// [Author] Alex (https://github.com/AlexVincent525)
/// [Date] 2020/4/13 18:04
///
import 'package:flutter/material.dart';

/// Built a slide page transition for the picker.
/// 为选择器构造一个上下进出的页面过渡动画
class SlidePageTransitionBuilder<T> extends PageRouteBuilder<T> {
  SlidePageTransitionBuilder({@required this.builder});

  final Widget builder;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 500);

  @override
  RoutePageBuilder get pageBuilder => (
        BuildContext _,
        Animation<double> __,
        Animation<double> ___,
      ) {
        return builder;
      };

  @override
  RouteTransitionsBuilder get transitionsBuilder => (
        BuildContext _,
        Animation<double> animation,
        Animation<double> __,
        Widget child,
      ) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(CurvedAnimation(curve: Curves.easeIn, parent: animation)),
          child: child,
        );
      };
}
