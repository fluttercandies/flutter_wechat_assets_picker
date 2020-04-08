///
/// [Author] Alex (https://github.com/AlexVincent525)
/// [Date] 2019-11-19 10:06
///
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../constants/constants.dart';

class FixedAppBar extends StatelessWidget {
  const FixedAppBar({
    Key key,
    this.automaticallyImplyLeading = true,
    this.title,
    this.leading,
    this.centerTitle = true,
    this.backgroundColor,
    this.elevation = 2.0,
    this.actions,
    this.actionsPadding,
    this.height,
    this.blurRadius = 0.0,
  }) : super(key: key);

  final Widget title;
  final Widget leading;
  final List<Widget> actions;
  final EdgeInsetsGeometry actionsPadding;
  final bool automaticallyImplyLeading;
  final bool centerTitle;
  final Color backgroundColor;
  final double elevation;
  final double height;
  final double blurRadius;

  @override
  Widget build(BuildContext context) {
    Widget _title = title;
    if (centerTitle) {
      _title = Center(child: _title);
    }
    Widget child = Container(
      width: Screens.width,
      height: (height ?? kToolbarHeight) + MediaQuery.of(context).padding.top,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      decoration: BoxDecoration(
        boxShadow: elevation > 0
            ? <BoxShadow>[
                BoxShadow(
                  color: const Color(0x0d000000),
                  blurRadius: elevation * 1.0,
                  offset: Offset(0, elevation * 2.0),
                ),
              ]
            : null,
        color: (backgroundColor ?? Theme.of(context).primaryColor)
            .withOpacity(blurRadius > 0.0 ? 0.90 : 1.0),
      ),
      child: Stack(
        children: <Widget>[
          if (automaticallyImplyLeading && Navigator.of(context).canPop())
            leading ?? const BackButton(),
          if (_title != null)
            Positioned(
              top: 0.0,
              bottom: 0.0,
              left: automaticallyImplyLeading && Navigator.of(context).canPop()
                  ? kMinInteractiveDimension
                  : 0.0,
              right: kMinInteractiveDimension,
              child: Align(
                alignment: centerTitle
                    ? Alignment.center
                    : AlignmentDirectional.centerStart,
                child: DefaultTextStyle(
                  child: _title,
                  style: Theme.of(context)
                      .textTheme
                      .title
                      .copyWith(fontSize: 23.0),
                  maxLines: 1,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          if (automaticallyImplyLeading &&
              Navigator.of(context).canPop() &&
              (actions?.isEmpty ?? true))
            const SizedBox(width: kMinInteractiveDimension)
          else if (actions?.isNotEmpty ?? false)
            PositionedDirectional(
              end: 0.0,
              height: kToolbarHeight,
              child: Padding(
                padding: actionsPadding ?? EdgeInsets.zero,
                child: Row(mainAxisSize: MainAxisSize.min, children: actions),
              ),
            ),
        ],
      ),
    );
    if (blurRadius > 0.0) {
      child = ClipRect(
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: blurRadius, sigmaY: blurRadius),
          child: child,
        ),
      );
    }
    return Material(type: MaterialType.transparency, child: child);
  }
}

/// Wrapper for [FixedAppBar]. Avoid elevation covered by body.
/// 顶栏封装。防止内容块层级高于顶栏导致遮挡阴影。
class FixedAppBarWrapper extends StatelessWidget {
  const FixedAppBarWrapper({
    Key key,
    @required this.appBar,
    @required this.body,
  })  : assert(
          appBar != null && body != null,
          'All fields must not be null.',
        ),
        super(key: key);

  final FixedAppBar appBar;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: <Widget>[
          Positioned(
            top: kToolbarHeight + MediaQuery.of(context).padding.top,
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: body,
          ),
          Positioned(top: 0.0, left: 0.0, right: 0.0, child: appBar),
        ],
      ),
    );
  }
}
