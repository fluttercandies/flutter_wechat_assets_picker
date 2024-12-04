// Copyright 2019 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by an Apache license that can be found
// in the LICENSE file.

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart' show AssetEntity;

import '../provider/asset_picker_provider.dart';
import 'asset_picker_builder_delegate.dart';

/// The coordinator that will calculates the corresponding item position based on
/// gesture details. This will only works with
/// the [DefaultAssetPickerBuilderDelegate] and the [DefaultAssetPickerProvider].
class AssetGridDragSelectionCoordinator {
  AssetGridDragSelectionCoordinator({
    required this.delegate,
  });

  /// [ChangeNotifier] for asset picker.
  /// 资源选择器状态保持
  final DefaultAssetPickerBuilderDelegate delegate;

  // An eyeballed value for a smooth scrolling experience.
  static const double _kDefaultAutoScrollVelocityScalar = 50.0;

  /// 边缘自动滚动控制器
  /// Support edge auto scroll when drag positions reach
  /// the edge of device's screen.
  EdgeDraggingAutoScroller? _autoScroller;

  /// 起始选择序号
  /// The first selecting item index.
  int initialSelectingIndex = -1;

  int largestSelectingIndex = -1;
  int smallestSelectingIndex = -1;

  /// 拖拽状态
  /// Dragging status.
  bool dragging = false;

  /// 拖拽选择 或 拖拽取消选择
  /// Whether to add or to remove the selected assets.
  bool addSelected = true;

  DefaultAssetPickerProvider get provider => delegate.provider;

  /// 长按启动拖拽
  /// Long Press to enable drag and select
  void onSelectionStart(
    BuildContext context,
    Offset globalPosition,
    int index,
    AssetEntity entity,
  ) {
    dragging = true;

    final scrollableState = _checkScrollableStatePresent(context);
    if (scrollableState == null) {
      return;
    }

    _autoScroller = EdgeDraggingAutoScroller(
      scrollableState,
      velocityScalar: _kDefaultAutoScrollVelocityScalar,
    );

    initialSelectingIndex = index;
    largestSelectingIndex = index;
    smallestSelectingIndex = index;

    addSelected = !delegate.provider.selectedAssets.contains(entity);
  }

  void onSelectionUpdate(BuildContext context, Offset globalPosition) {
    if (!dragging) {
      return;
    }

    final view = View.of(context);
    final dimensionSize = view.physicalSize / view.devicePixelRatio;

    // Calculate the coordinate of the current drag position's
    // asset representation.
    final gridCount = delegate.gridCount;
    final itemSize = dimensionSize.width / gridCount;

    // Get the actual top padding. Since `viewPadding` represents the
    // physical pixels, it should be divided by the device pixel ratio
    // to get the logical pixels.
    final appBarSize =
        delegate.appBarPreferredSize ?? delegate.appBar(context).preferredSize;
    final topPadding =
        appBarSize.height + view.viewPadding.top / view.devicePixelRatio;
    final bottomPadding = delegate.bottomActionBarHeight +
        view.viewPadding.bottom / view.devicePixelRatio;

    // Row index is calculated based on the drag's global position.
    // The AppBar height, status bar height, and scroll offset are subtracted
    // to adjust for padding and scrolling. This gives the actual row index.
    final gridRevert = delegate.effectiveShouldRevertGrid(context);
    int columnIndex = _getDragPositionIndex(globalPosition.dx, itemSize);
    if (gridRevert) {
      columnIndex = gridCount - columnIndex - 2;
    }
    final rowIndex = _getDragPositionIndex(
      switch (gridRevert) {
        true => dimensionSize.height - bottomPadding - globalPosition.dy,
        false => globalPosition.dy - topPadding,
      },
      itemSize,
    );

    final currentDragIndex = rowIndex * gridCount + columnIndex;

    // Check the selecting index in order to diff unselecting assets.
    smallestSelectingIndex = math.min(
      currentDragIndex,
      smallestSelectingIndex,
    );
    smallestSelectingIndex = math.max(0, smallestSelectingIndex);
    largestSelectingIndex = math.max(
      currentDragIndex + 1,
      largestSelectingIndex,
    );
    largestSelectingIndex = math.max(0, largestSelectingIndex);

    // Filter out pending assets to manipulate.
    final Iterable<AssetEntity> filteredAssetList;
    if (currentDragIndex < initialSelectingIndex) {
      filteredAssetList = provider.currentAssets
          .getRange(
            math.max(0, currentDragIndex),
            math.min(
              initialSelectingIndex + 1,
              provider.currentAssets.length,
            ),
          )
          .toList()
          .reversed;
    } else {
      filteredAssetList = provider.currentAssets.getRange(
        math.max(0, initialSelectingIndex),
        math.min(
          currentDragIndex + 1,
          provider.currentAssets.length,
        ),
      );
    }
    final touchedAssets = List<AssetEntity>.from(
      provider.currentAssets.getRange(
        smallestSelectingIndex,
        largestSelectingIndex,
      ),
    );

    // Do not select or unselect more assets if the limit has been reached.
    if (filteredAssetList.isNotEmpty) {
      if (addSelected && provider.selectedMaximumAssets) {
        return;
      }
      if (!addSelected && !provider.isSelectedNotEmpty) {
        return;
      }
    }

    // Toggle all filtered assets.
    for (final asset in filteredAssetList) {
      delegate.selectAsset(context, asset, currentDragIndex, !addSelected);
      touchedAssets.remove(asset);
    }
    // Revert the selection of touched but not filtered assets.
    for (final asset in touchedAssets) {
      delegate.selectAsset(context, asset, currentDragIndex, addSelected);
    }

    final stopAutoScroll = switch (addSelected) {
      true => provider.selectedAssets.length == provider.maxAssets,
      false => provider.selectedAssets.isEmpty,
    };

    if (stopAutoScroll) {
      _autoScroller?.stopAutoScroll();
      return;
    }

    // Enable auto scrolling if the drag detail is at edge
    _autoScroller?.startAutoScrollIfNecessary(
      Offset(
            (columnIndex + 1) * itemSize,
            globalPosition.dy > dimensionSize.height * 0.8
                ? (rowIndex + 1) * itemSize
                : math.max(topPadding, globalPosition.dy),
          ) &
          Size.square(itemSize),
    );
  }

  void onDragEnd(Offset globalPosition) {
    resetDraggingStatus();
  }

  /// 复原拖拽状态
  /// Reset dragging status
  void resetDraggingStatus() {
    _autoScroller?.stopAutoScroll();
    _autoScroller = null;
    dragging = false;
    addSelected = true;
    initialSelectingIndex = -1;
    largestSelectingIndex = -1;
    smallestSelectingIndex = -1;
  }

  /// 检查 [Scrollable] state是否存在
  /// Check if the [Scrollable] state is exist
  ///
  /// This is to ensure that the edge auto scrolling is functioning and the drag function is placed correctly
  /// inside the Scrollable
  /// 拖拽选择功能必须被放在 可滚动视图下才能启动边缘自动滚动功能
  ScrollableState? _checkScrollableStatePresent(BuildContext context) {
    final scrollable = Scrollable.maybeOf(context);
    assert(
      scrollable != null,
      'The drag select feature must use along with scrollables.',
    );
    assert(
      scrollable?.position.axis == Axis.vertical,
      'The drag select feature must use along with vertical scrollables.',
    );
    if (scrollable == null || scrollable.position.axis != Axis.vertical) {
      resetDraggingStatus();
      return null;
    }

    return scrollable;
  }

  /// 获取坐标
  /// Get Coordinate Helper
  int _getDragPositionIndex(double delta, double itemSize) {
    return delta ~/ itemSize;
  }
}
