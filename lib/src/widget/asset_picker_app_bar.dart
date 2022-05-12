// Copyright 2019 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by an Apache license that can be found
// in the LICENSE file.

import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';

/// A custom app bar.
/// 自定义的顶栏
class AssetPickerAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AssetPickerAppBar({
    super.key,
    this.automaticallyImplyLeading = true,
    this.automaticallyImplyActions = true,
    this.brightness,
    this.title,
    this.leading,
    this.bottom,
    this.centerTitle = true,
    this.backgroundColor,
    this.elevation = 0,
    this.actions,
    this.actionsPadding,
    this.height,
    this.blurRadius = 0,
    this.iconTheme,
    this.semanticsBuilder,
  });

  /// Title widget. Typically a [Text] widget.
  /// 标题部件
  final Widget? title;

  /// Leading widget.
  /// 头部部件
  final Widget? leading;

  /// Action widgets.
  /// 尾部操作部件
  final List<Widget>? actions;

  /// This widget appears across the bottom of the app bar.
  /// 显示在顶栏下方的 widget
  final PreferredSizeWidget? bottom;

  /// Padding for actions.
  /// 尾部操作部分的内边距
  final EdgeInsetsGeometry? actionsPadding;

  /// Whether it should imply leading with [BackButton] automatically.
  /// 是否会自动检测并添加返回按钮至头部
  final bool automaticallyImplyLeading;

  /// Whether the [title] should be at the center.
  /// [title] 是否会在正中间
  final bool centerTitle;

  /// Whether it should imply actions size with [effectiveHeight].
  /// 是否会自动使用 [effectiveHeight] 进行占位
  final bool automaticallyImplyActions;

  /// Background color.
  /// 背景颜色
  final Color? backgroundColor;

  /// Height of the app bar.
  /// 高度
  final double? height;

  /// Elevation to [Material].
  /// 设置在 [Material] 的阴影
  final double elevation;

  /// The blur radius applies on the bar.
  /// 顶栏的高斯模糊值
  final double blurRadius;

  /// Set the brightness for the status bar's layer.
  /// 设置状态栏亮度层
  final Brightness? brightness;

  final IconThemeData? iconTheme;

  final Semantics Function(Widget appBar)? semanticsBuilder;

  bool canPop(BuildContext context) =>
      Navigator.of(context).canPop() && automaticallyImplyLeading;

  double get _barHeight => height ?? kToolbarHeight;

  double get effectiveHeight =>
      _barHeight + (bottom?.preferredSize.height ?? 0);

  @override
  Size get preferredSize => Size.fromHeight(effectiveHeight);

  @override
  Widget build(BuildContext context) {
    Widget? titleWidget = title;
    if (centerTitle) {
      titleWidget = Center(child: title);
    }
    Widget child = Container(
      width: double.maxFinite,
      height: _barHeight + MediaQuery.of(context).padding.top,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Stack(
        children: <Widget>[
          if (canPop(context))
            PositionedDirectional(
              top: 0.0,
              bottom: 0.0,
              child: leading ?? const BackButton(),
            ),
          if (titleWidget != null)
            PositionedDirectional(
              top: 0.0,
              bottom: 0.0,
              start: canPop(context) ? _barHeight : 0.0,
              end: automaticallyImplyActions ? _barHeight : 0.0,
              child: Align(
                alignment: centerTitle
                    ? Alignment.center
                    : AlignmentDirectional.centerStart,
                child: DefaultTextStyle(
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(fontSize: 23.0),
                  maxLines: 1,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  child: titleWidget,
                ),
              ),
            ),
          if (canPop(context) && (actions?.isEmpty ?? true))
            SizedBox(width: _barHeight)
          else if (actions?.isNotEmpty ?? false)
            PositionedDirectional(
              top: 0.0,
              end: 0.0,
              height: _barHeight,
              child: Padding(
                padding: actionsPadding ?? EdgeInsets.zero,
                child: Row(mainAxisSize: MainAxisSize.min, children: actions!),
              ),
            ),
        ],
      ),
    );

    // Allow custom blur radius using [ui.ImageFilter.blur].
    if (blurRadius > 0.0) {
      child = ClipRect(
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: blurRadius, sigmaY: blurRadius),
          child: child,
        ),
      );
    }

    if (iconTheme != null) {
      child = IconTheme.merge(data: iconTheme!, child: child);
    }

    // Set [SystemUiOverlayStyle] according to the brightness.
    final Brightness effectiveBrightness = brightness ??
        Theme.of(context).appBarTheme.systemOverlayStyle?.statusBarBrightness ??
        Theme.of(context).brightness;
    child = AnnotatedRegion<SystemUiOverlayStyle>(
      value: effectiveBrightness == Brightness.dark
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          child,
          if (bottom != null) bottom!,
        ],
      ),
    );

    final Widget result = Material(
      // Wrap to ensure the child rendered correctly
      color: Color.lerp(
        backgroundColor ?? Theme.of(context).colorScheme.surface,
        Colors.transparent,
        blurRadius > 0.0 ? 0.1 : 0.0,
      ),
      elevation: elevation,
      child: child,
    );
    return semanticsBuilder?.call(result) ??
        Semantics(sortKey: const OrdinalSortKey(0), child: result);
  }
}

/// Wrapper for [AssetPickerAppBar]. Avoid elevation covered by body.
/// 顶栏封装。防止内容块层级高于顶栏导致遮挡阴影。
class AssetPickerAppBarWrapper extends StatelessWidget {
  const AssetPickerAppBarWrapper({
    super.key,
    required this.appBar,
    required this.body,
  });

  final AssetPickerAppBar appBar;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            top: MediaQuery.of(context).padding.top +
                appBar.preferredSize.height,
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: body,
            ),
          ),
          Positioned.fill(bottom: null, child: appBar),
        ],
      ),
    );
  }
}
