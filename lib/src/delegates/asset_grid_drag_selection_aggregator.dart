import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class AssetGridDragSelectionAggregator {
  AssetGridDragSelectionAggregator({
    required this.delegate,
  });

  /// [ChangeNotifier] for asset picker.
  /// 资源选择器状态保持
  final DefaultAssetPickerBuilderDelegate delegate;

  /// 拖拽状态
  /// Drag status
  bool isInDragging = false;

  /// 边缘自动滚动控制器
  /// Edge Auto Scrolling Detector. Use to support edge auto scroll when drag position reach the edge of device's screen.
  EdgeDraggingAutoScroller? _autoScroller;

  // An eyeballed value for a smooth scrolling experience.
  static const double _kDefaultAutoScrollVelocityScalar = 50;

  /// 起始选择序号
  /// Item index of the first selected item
  int initialSelectedIdx = -1;

  /// 拖拽选择 或 拖拽取消选择
  /// Drag to select or deselect state
  bool dragSelect = true;

  /// 长按启动拖拽
  /// Long Press to enable drag and select
  void onDragStart(
    BuildContext context,
    LongPressStartDetails details,
    int index,
    AssetEntity entity,
  ) {
    isInDragging = true;

    final scrollableState = _checkScrollableStatePresent(context);
    if (scrollableState == null) {
      return;
    }

    _autoScroller = EdgeDraggingAutoScroller(
      scrollableState,
      velocityScalar: _kDefaultAutoScrollVelocityScalar,
    );

    initialSelectedIdx = index;

    dragSelect = !delegate.provider.selectedAssets.contains(entity);
  }

  void onDragUpdate(
    BuildContext context,
    LongPressMoveUpdateDetails details,
    double itemSize,
    int gridCount,
    double topPadding,
  ) {
    if (!isInDragging) {
      return;
    }

    if (dragSelect &&
        delegate.provider.selectedAssets.length ==
            delegate.provider.maxAssets) {
      return;
    }

    final scrollableState = _checkScrollableStatePresent(context);
    if (scrollableState == null) {
      return;
    }

    /// Calculate the coordinate of the current drag position's asset representation
    final columnIndex =
        _getDragPositionIndex(details.globalPosition.dx, itemSize);

    /// Get the actual top padding
    /// Since viewPadding represents the physical pixels,
    /// it should be divided by the device pixel ratio to get the logical pixels.
    final extraTopPadding = topPadding +
        (View.of(context).viewPadding.top / View.of(context).devicePixelRatio);

    /// Row index is calculated based on the drag's global position.
    /// The AppBar height, status bar height, and scroll offset are subtracted to adjust for padding and scrolling.
    /// This gives the actual row index.
    final rowIndex = _getDragPositionIndex(
      details.globalPosition.dy -
          extraTopPadding +
          scrollableState.position.pixels,
      itemSize,
    );

    final currentDragIndex = rowIndex * gridCount + columnIndex;

    final List<AssetEntity> filteredAssetList = <AssetEntity>[];
    // add asset
    if (currentDragIndex < initialSelectedIdx) {
      filteredAssetList.addAll(
        delegate.provider.currentAssets
            .getRange(
              currentDragIndex,
              math.min(
                initialSelectedIdx + 1,
                delegate.provider.currentAssets.length,
              ),
            )
            .toList()
          ..reversed,
      );
    } else {
      filteredAssetList.addAll(
        delegate.provider.currentAssets
            .getRange(
              initialSelectedIdx,
              math.min(
                currentDragIndex + 1,
                delegate.provider.currentAssets.length,
              ),
            )
            .toList(),
      );
    }

    for (final asset in filteredAssetList) {
      delegate.selectAsset(context, asset, currentDragIndex, !dragSelect);
    }

    final bool stopAutoScroll =
        (!dragSelect && delegate.provider.selectedAssets.isEmpty) ||
            (dragSelect &&
                delegate.provider.selectedAssets.length ==
                    delegate.provider.maxAssets);

    if (stopAutoScroll) {
      _autoScroller?.stopAutoScroll();
      _autoScroller = null;
      return;
    }

    /// Enable auto scrolling if the drag detail is at edge
    _autoScroller?.startAutoScrollIfNecessary(
      Rect.fromLTWH(
        (columnIndex + 1) * itemSize,
        details.globalPosition.dy > MediaQuery.sizeOf(context).height * 0.8
            ? (rowIndex + 1) * itemSize
            : math.max(topPadding, details.globalPosition.dy),
        itemSize,
        itemSize,
      ),
    );
  }

  void onDragEnd(LongPressEndDetails details) {
    resetDraggingStatus();
  }

  /// 复原拖拽状态
  /// Reset dragging status
  void resetDraggingStatus() {
    isInDragging = false;
    initialSelectedIdx = -1;
    dragSelect = true;
    _autoScroller?.stopAutoScroll();
    _autoScroller = null;
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
      'To use drag and select function, Scrollable state must be the present to get the actual item position.',
    );
    assert(
      scrollable?.position.axis == Axis.vertical,
      'To use drag and select function. The Scrollable Axis must be in vertical direction',
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
