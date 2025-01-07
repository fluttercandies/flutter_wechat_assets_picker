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

  bool get _debug => false;
  final _debugLastPosition = ValueNotifier<(int, int)?>(null);

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
    _debugLastPosition.value = null;
  }

  /// 长按启动拖拽
  /// Long Press to enable drag and select
  void onSelectionStart(
    BuildContext context,
    Offset globalPosition,
    int index,
    AssetEntity entity,
  ) {
    final scrollableState = _checkScrollableStatePresent(context);
    if (scrollableState == null) {
      return;
    }

    if (delegate.gridScrollController.position.isScrollingNotifier.value) {
      return;
    }

    dragging = true;

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

    // Get the actual top padding. Since `viewPadding` represents the
    // physical pixels, it should be divided by the device pixel ratio
    // to get the logical pixels.
    final appBarSize =
        delegate.appBarPreferredSize ?? delegate.appBar(context).preferredSize;
    final viewPaddingTop = view.viewPadding.top / view.devicePixelRatio;
    final viewPaddingBottom = view.viewPadding.bottom / view.devicePixelRatio;
    final topPadding = appBarSize.height + viewPaddingTop;
    final bottomPadding = delegate.bottomActionBarHeight + viewPaddingBottom;
    final gridViewport = dimensionSize.height - topPadding - bottomPadding;

    // Calculate the coordinate of the current drag position's
    // asset representation.
    final gridCount = delegate.gridCount;
    final itemSize = dimensionSize.width / gridCount;
    final dividedSpacing = delegate.itemSpacing / gridCount;

    // Row index is calculated based on the drag's global position.
    // The AppBar height, status bar height, and scroll offset are subtracted
    // to adjust for padding and scrolling. This gives the actual row index.
    final gridRevert = delegate.effectiveShouldRevertGrid(context);
    final maxRow = (provider.currentAssets.length / gridCount).ceil();
    final maxRowPerPage = (gridViewport / itemSize).ceil();
    final bool onlyOneScreen = maxRow * itemSize <= gridViewport;

    final double anchor;
    if (!gridRevert || onlyOneScreen) {
      anchor = 0.0;
    } else {
      anchor = math.min(
        (maxRow * (itemSize + dividedSpacing) +
                topPadding -
                delegate.itemSpacing) /
            dimensionSize.height,
        1.0,
      );
    }

    int getDragAxisIndex(double delta, double itemSize) {
      return delta ~/ (itemSize + dividedSpacing);
    }

    int rowIndex = getDragAxisIndex(
      switch (gridRevert && !onlyOneScreen) {
        true => dimensionSize.height -
            topPadding -
            globalPosition.dy +
            delegate.bottomSectionHeight -
            delegate.gridScrollController.offset,
        false =>
          globalPosition.dy - topPadding + delegate.gridScrollController.offset,
      },
      itemSize,
    );

    final double initialFirstPosition = dimensionSize.height * anchor;
    if (gridRevert && dimensionSize.height > initialFirstPosition) {
      final deductedRow =
          (dimensionSize.height - initialFirstPosition) ~/ itemSize;
      rowIndex -= deductedRow;
    }

    final int placeholderCount = delegate.assetsGridItemPlaceholderCount(
      context: context,
      pathWrapper: provider.currentPath,
      onlyOneScreen: onlyOneScreen,
    );

    int columnIndex = getDragAxisIndex(globalPosition.dx, itemSize);
    if (gridRevert) {
      columnIndex = gridCount - columnIndex - placeholderCount;
      if (maxRow > maxRowPerPage) {
        // The grid is actually being reverted.
        columnIndex -= 1;
      }
    }

    if (placeholderCount > 0 &&
        !onlyOneScreen &&
        rowIndex > 0 &&
        anchor < 1.0) {
      rowIndex -= 1;
    }

    _debugLastPosition.value = (rowIndex, columnIndex);
    final currentDragIndex = rowIndex * gridCount + columnIndex;

    // Check the selecting index in order to diff unselecting assets.
    smallestSelectingIndex = math.min(
      currentDragIndex,
      smallestSelectingIndex,
    );
    smallestSelectingIndex = math.max(0, smallestSelectingIndex);
    largestSelectingIndex = math.max(
      currentDragIndex,
      largestSelectingIndex,
    );

    // To avoid array indexed out of bounds
    largestSelectingIndex = math.min(
      math.max(0, largestSelectingIndex),
      provider.currentAssets.length,
    );

    // Filter out pending assets to manipulate.
    final Iterable<AssetEntity> filteredAssetList;
    if (currentDragIndex < initialSelectingIndex) {
      filteredAssetList = provider.currentAssets
          .getRange(
            math.max(0, currentDragIndex),
            math.min(initialSelectingIndex + 1, provider.currentAssets.length),
          )
          .toList()
          .reversed;
    } else {
      filteredAssetList = provider.currentAssets.getRange(
        math.max(0, initialSelectingIndex),
        math.min(
          currentDragIndex + (maxRow > maxRowPerPage ? 1 : 0),
          provider.currentAssets.length,
        ),
      );
    }
    final touchedAssets = List<AssetEntity>.from(
      provider.currentAssets.getRange(
        math.max(0, smallestSelectingIndex),
        math.min(largestSelectingIndex + 1, provider.currentAssets.length),
      ),
    );

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
      true => provider.selectedAssets.length == provider.maxAssets ||
          (gridRevert && delegate.gridScrollController.offset == 0.0),
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

  Widget buildDebugInfo(BuildContext context) {
    if (!_debug) {
      return const SizedBox.shrink();
    }
    return Align(
      alignment: Alignment.bottomCenter,
      child: ValueListenableBuilder(
        valueListenable: _debugLastPosition,
        builder: (_, value, __) => Text(
          value?.toString() ?? '',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            shadows: const [Shadow(blurRadius: 8.0)],
          ),
        ),
      ),
    );
  }
}
