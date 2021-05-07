///
/// [Author] Alex (https://github.com/Alex525)
/// [Date] 2020/3/31 16:27
///
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../constants/constants.dart';

class AssetPickerViewer<A, P> extends StatefulWidget {
  const AssetPickerViewer({
    Key? key,
    required this.builder,
  }) : super(key: key);

  final AssetPickerViewerBuilderDelegate<A, P> builder;

  @override
  AssetPickerViewerState<A, P> createState() => AssetPickerViewerState<A, P>();

  /// Static method to push with the navigator.
  /// 跳转至选择预览的静态方法
  static Future<List<AssetEntity>?> pushToViewer(
    BuildContext context, {
    int currentIndex = 0,
    required List<AssetEntity> previewAssets,
    required ThemeData themeData,
    DefaultAssetPickerProvider? selectorProvider,
    List<int>? previewThumbSize,
    List<AssetEntity>? selectedAssets,
    SpecialPickerType? specialPickerType,
    int? maxAssets,
  }) async {
    try {
      final Widget viewer = AssetPickerViewer<AssetEntity, AssetPathEntity>(
        builder: DefaultAssetPickerViewerBuilderDelegate(
          currentIndex: currentIndex,
          previewAssets: previewAssets,
          provider: selectedAssets != null
              ? AssetPickerViewerProvider<AssetEntity>(selectedAssets)
              : null,
          themeData: themeData,
          previewThumbSize: previewThumbSize,
          specialPickerType: specialPickerType,
          selectedAssets: selectedAssets,
          selectorProvider: selectorProvider,
          maxAssets: maxAssets,
        ),
      );
      final PageRouteBuilder<List<AssetEntity>> pageRoute =
          PageRouteBuilder<List<AssetEntity>>(
        pageBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
        ) {
          return viewer;
        },
        transitionsBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child,
        ) {
          return FadeTransition(opacity: animation, child: child);
        },
      );
      final List<AssetEntity>? result =
          await Navigator.of(context).push<List<AssetEntity>>(pageRoute);
      return result;
    } catch (e) {
      realDebugPrint('Error when calling assets picker viewer: $e');
      return null;
    }
  }
}

class AssetPickerViewerState<A, P> extends State<AssetPickerViewer<A, P>>
    with TickerProviderStateMixin {
  AssetPickerViewerBuilderDelegate<A, P> get builder => widget.builder;

  @override
  void initState() {
    super.initState();
    builder.initStateAndTicker(this, this);
  }

  @override
  void dispose() {
    builder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return builder.build(context);
  }
}
