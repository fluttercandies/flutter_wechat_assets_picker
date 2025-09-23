// Copyright 2019 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by an Apache license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart' hide Path;
import 'package:photo_manager/photo_manager.dart';

import '../constants/constants.dart';
import '../constants/enums.dart';
import '../constants/typedefs.dart';
import '../delegates/asset_picker_viewer_builder_delegate.dart';
import '../provider/asset_picker_provider.dart';
import '../provider/asset_picker_viewer_provider.dart';
import 'asset_picker.dart';
import 'asset_picker_page_route.dart';

class AssetPickerViewer<Asset, Path> extends StatefulWidget {
  const AssetPickerViewer({
    super.key,
    required this.builder,
  });

  final AssetPickerViewerBuilderDelegate<Asset, Path> builder;

  @override
  AssetPickerViewerState<Asset, Path> createState() =>
      AssetPickerViewerState<Asset, Path>();

  /// Static method to push with the navigator.
  /// 跳转至选择预览的静态方法
  static Future<List<AssetEntity>?> pushToViewer(
    BuildContext context, {
    int currentIndex = 0,
    required List<AssetEntity> previewAssets,
    required ThemeData themeData,
    DefaultAssetPickerProvider? selectorProvider,
    ThumbnailSize? previewThumbnailSize,
    List<AssetEntity>? selectedAssets,
    SpecialPickerType? specialPickerType,
    int? maxAssets,
    bool shouldReversePreview = false,
    AssetSelectPredicate<AssetEntity>? selectPredicate,
    PermissionRequestOption permissionRequestOption =
        const PermissionRequestOption(),
    bool shouldAutoplayPreview = false,
    bool useRootNavigator = false,
    RouteSettings? pageRouteSettings,
    AssetPickerViewerPageRouteBuilder<List<AssetEntity>>? pageRouteBuilder,
  }) async {
    if (previewAssets.isEmpty) {
      throw StateError('Previewing empty assets is not allowed.');
    }
    await AssetPicker.permissionCheck(requestOption: permissionRequestOption);
    final Widget viewer = AssetPickerViewer<AssetEntity, AssetPathEntity>(
      builder: DefaultAssetPickerViewerBuilderDelegate(
        currentIndex: currentIndex,
        previewAssets: previewAssets,
        provider: selectedAssets != null
            ? AssetPickerViewerProvider<AssetEntity>(
                selectedAssets,
                maxAssets: maxAssets ??
                    selectorProvider?.maxAssets ??
                    defaultMaxAssetsCount,
              )
            : null,
        themeData: themeData,
        previewThumbnailSize: previewThumbnailSize,
        specialPickerType: specialPickerType,
        selectedAssets: selectedAssets,
        selectorProvider: selectorProvider,
        maxAssets: maxAssets,
        shouldReversePreview: shouldReversePreview,
        selectPredicate: selectPredicate,
        shouldAutoplayPreview: shouldAutoplayPreview,
      ),
    );
    final List<AssetEntity>? result = await Navigator.maybeOf(
      context,
      rootNavigator: useRootNavigator,
    )?.push<List<AssetEntity>>(
      pageRouteBuilder?.call(viewer) ??
          AssetPickerViewerPageRoute(builder: (context) => viewer),
    );
    return result;
  }

  /// Call the viewer with provided delegate and provider.
  /// 通过指定的 [delegate] 调用查看器
  static Future<List<A>?> pushToViewerWithDelegate<A, P>(
    BuildContext context, {
    required AssetPickerViewerBuilderDelegate<A, P> delegate,
    PermissionRequestOption permissionRequestOption =
        const PermissionRequestOption(),
    bool useRootNavigator = false,
    RouteSettings? pageRouteSettings,
    AssetPickerViewerPageRouteBuilder<List<A>>? pageRouteBuilder,
  }) async {
    await AssetPicker.permissionCheck(requestOption: permissionRequestOption);
    final Widget viewer = AssetPickerViewer<A, P>(builder: delegate);
    final List<A>? result = await Navigator.maybeOf(
      context,
      rootNavigator: useRootNavigator,
    )?.push<List<A>>(
      pageRouteBuilder?.call(viewer) ??
          AssetPickerViewerPageRoute(builder: (context) => viewer),
    );
    return result;
  }
}

class AssetPickerViewerState<Asset, Path>
    extends State<AssetPickerViewer<Asset, Path>>
    with TickerProviderStateMixin {
  AssetPickerViewerBuilderDelegate<Asset, Path> get builder => widget.builder;

  @override
  void initState() {
    super.initState();
    builder.initStateAndTicker(this, this);
  }

  @override
  void didUpdateWidget(covariant AssetPickerViewer<Asset, Path> oldWidget) {
    super.didUpdateWidget(oldWidget);
    builder.didUpdateViewer(this, oldWidget, widget);
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
