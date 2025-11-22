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

class AssetPickerViewer<
    Asset,
    Path,
    Provider extends AssetPickerViewerProvider<Asset>,
    Delegate extends AssetPickerViewerBuilderDelegate<Asset, Path,
        Provider>> extends StatefulWidget {
  const AssetPickerViewer({
    super.key,
    required this.builder,
  });

  final Delegate builder;

  @override
  AssetPickerViewerState<Asset, Path, Provider, Delegate> createState() =>
      AssetPickerViewerState<Asset, Path, Provider, Delegate>();

  /// Static method to push with the navigator.
  /// 跳转至选择预览的静态方法
  static Future<List<AssetEntity>?>
      pushToViewer<P extends DefaultAssetPickerProvider>(
    BuildContext context, {
    int currentIndex = 0,
    required List<AssetEntity> previewAssets,
    required ThemeData themeData,
    P? selectorProvider,
    ThumbnailSize? previewThumbnailSize,
    List<AssetEntity>? selectedAssets,
    SpecialPickerType? specialPickerType,
    int? maxAssets,
    bool shouldReversePreview = false,
    AssetSelectPredicate<AssetEntity>? selectPredicate,
    bool shouldAutoplayPreview = false,
    bool enableLivePhoto = true,
    bool useRootNavigator = false,
    RouteSettings? pageRouteSettings,
    AssetPickerViewerPageRouteBuilder<List<AssetEntity>>? pageRouteBuilder,
  }) async {
    if (previewAssets.isEmpty) {
      throw StateError('Previewing empty assets is not allowed.');
    }
    final viewer = AssetPickerViewer<
        AssetEntity,
        AssetPathEntity,
        AssetPickerViewerProvider<AssetEntity>,
        DefaultAssetPickerViewerBuilderDelegate>(
      builder: DefaultAssetPickerViewerBuilderDelegate<
          AssetPickerViewerProvider<AssetEntity>, P>(
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
        enableLivePhoto: enableLivePhoto,
      ),
    );
    final result = await Navigator.maybeOf(
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
  static Future<List<Asset>?> pushToViewerWithDelegate<
      Asset,
      Path,
      Provider extends AssetPickerViewerProvider<Asset>,
      Delegate extends AssetPickerViewerBuilderDelegate<Asset, Path, Provider>>(
    BuildContext context, {
    required Delegate delegate,
    PermissionRequestOption permissionRequestOption =
        const PermissionRequestOption(),
    bool useRootNavigator = false,
    RouteSettings? pageRouteSettings,
    AssetPickerViewerPageRouteBuilder<List<Asset>>? pageRouteBuilder,
  }) async {
    await AssetPicker.permissionCheck(requestOption: permissionRequestOption);
    final viewer = AssetPickerViewer<Asset, Path, Provider, Delegate>(
      builder: delegate,
    );
    final pageRoute = pageRouteBuilder?.call(viewer) ??
        AssetPickerViewerPageRoute(builder: (context) => viewer);
    final result =
        await Navigator.maybeOf(context)?.push<List<Asset>>(pageRoute);
    return result;
  }
}

class AssetPickerViewerState<
        Asset,
        Path,
        Provider extends AssetPickerViewerProvider<Asset>,
        Delegate extends AssetPickerViewerBuilderDelegate<Asset, Path,
            Provider>>
    extends State<AssetPickerViewer<Asset, Path, Provider, Delegate>>
    with TickerProviderStateMixin {
  Delegate get builder => widget.builder;

  @override
  void initState() {
    super.initState();
    builder.initState(this);
  }

  @override
  void didUpdateWidget(
    covariant AssetPickerViewer<Asset, Path, Provider, Delegate> oldWidget,
  ) {
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
