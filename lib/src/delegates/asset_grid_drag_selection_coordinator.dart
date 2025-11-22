// Copyright 2019 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by an Apache license that can be found
// in the LICENSE file.

import 'dart:math' as math show max, min;

import 'package:flutter/widgets.dart';
import 'package:photo_manager/photo_manager.dart' show AssetEntity;

import '../provider/asset_picker_provider.dart';
import 'asset_picker_builder_delegate.dart';

/// The coordinator that will calculates the corresponding item position
/// based on gesture details. This will only works with
/// [DefaultAssetPickerBuilderDelegate] and [DefaultAssetPickerProvider].
class AssetGridDragSelectionCoordinator {
  AssetGridDragSelectionCoordinator({
    required this.delegate,
  });

  /// Access the delegate to calculate layout details.
  final DefaultAssetPickerBuilderDelegate delegate;

  // An eyeballed value for a smooth scrolling experience.
  static const double _kDefaultAutoScrollVelocityScalar = 50.0;

  /// Support edge auto scroll when drag positions reach
  /// the edge of device's screen.
  EdgeDraggingAutoScroller? _autoScroller;

  /// The first selecting item index.
  int initialSelectingIndex = -1;

  int largestSelectingIndex = -1;
  int smallestSelectingIndex = -1;

  /// Dragging status.
  bool dragging = false;

  /// Whether to add or to remove the selected assets.
  bool addSelected = true;

  DefaultAssetPickerProvider get provider => delegate.provider;

  /// Reset all dragging status.
  void resetDraggingStatus() {
    _autoScroller?.stopAutoScroll();
    _autoScroller = null;
    dragging = false;
    addSelected = true;
    initialSelectingIndex = -1;
    largestSelectingIndex = -1;
    smallestSelectingIndex = -1;
  }

  /// Long Press or horizontal drag to start the selection.
  void onSelectionStart({
    required BuildContext context,
    required Offset globalPosition,
    required int index,
    required AssetEntity asset,
  }) {
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

    addSelected = !delegate.provider.selectedAssets.contains(asset);
  }

  void onSelectionUpdate({
    required BuildContext context,
    required Offset globalPosition,
    required BoxConstraints constraints,
  }) {
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
    final topSectionHeight = appBarSize.height + viewPaddingTop;
    final bottomSectionHeight =
        delegate.bottomSectionHeight + viewPaddingBottom;
    final gridViewport =
        dimensionSize.height - topSectionHeight - bottomSectionHeight;

    // Calculate the coordinate of the current drag position's
    // asset representation.
    final gridCount = delegate.gridCount;
    final itemSize = dimensionSize.width / gridCount;
    final dividedSpacing = delegate.itemSpacing / gridCount;

    // Row index is calculated based on the drag's global position.
    // The AppBar height, status bar height, and scroll offset are subtracted
    // to adjust for padding and scrolling. This gives the actual row index.
    final gridRevert = delegate.effectiveShouldRevertGrid(context);
    final totalRows = (provider.currentAssets.length / gridCount).ceil();
    final onlyOneScreen =
        totalRows * (itemSize + delegate.itemSpacing) <= gridViewport;
    final reverted = gridRevert && !onlyOneScreen;

    final specialItems = delegate.assetsGridSpecialItemsFinalized(
      context: context,
      path: provider.currentPath?.path,
    );

    final double anchor = delegate.assetGridAnchor(
      context: context,
      constraints: constraints,
      pathWrapper: provider.currentPath,
      specialItemsFinalized: specialItems,
    );
    final scrolledOffset = delegate.gridScrollController.offset
        .abs(); // Offset is negative when reverted.

    // Corrects the Y position according the reverted status.
    final correctedY = switch (reverted) {
          true =>
            dimensionSize.height - bottomSectionHeight - globalPosition.dy,
          false => globalPosition.dy - topSectionHeight,
        } +
        scrolledOffset;

    int getDragAxisIndex(double delta, double itemSize) {
      return delta ~/ (itemSize + dividedSpacing);
    }

    int rowIndex = getDragAxisIndex(correctedY, itemSize);
    final initialFirstPosition = dimensionSize.height * anchor;
    if (reverted && dimensionSize.height > initialFirstPosition) {
      final deductedRow = getDragAxisIndex(
        dimensionSize.height - initialFirstPosition,
        itemSize,
      );
      rowIndex -= deductedRow;
    }

    final placeholderCount = delegate.assetsGridItemPlaceholderCount(
      context: context,
      pathWrapper: provider.currentPath,
      onlyOneScreen: onlyOneScreen,
      specialItemsFinalized: specialItems,
    );
    // Make the index starts with the bottom if the grid is reverted.
    if (reverted && placeholderCount > 0 && rowIndex > 0 && anchor < 1.0) {
      rowIndex -= 1;
    }

    int columnIndex = getDragAxisIndex(globalPosition.dx, itemSize);
    if (reverted) {
      columnIndex = gridCount - columnIndex - placeholderCount - 1;
    }

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

    // Avoid index overflow.
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
        math.min(currentDragIndex + 1, provider.currentAssets.length),
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

    if (filteredAssetList.isEmpty) {
      return;
    }

    if (provider.selectedAssets.isEmpty ||
        provider.selectedAssets.length == provider.maxAssets) {
      _autoScroller?.stopAutoScroll();
      return;
    }

    // Enable auto-scrolling if the pointer is at the edge.
    final Offset dragOffset = Offset(
      columnIndex * itemSize,
      globalPosition.dy +
          (globalPosition.dy > (dimensionSize.height / 2)
              ? bottomSectionHeight
              : -topSectionHeight),
    );
    final dragTarget = dragOffset & Size.square(itemSize);
    _autoScroller?.startAutoScrollIfNecessary(dragTarget);
  }

  void onDragEnd({required Offset globalPosition}) {
    resetDraggingStatus();
  }

  /// Check if the [Scrollable] state is exist.
  ///
  /// Ensures that the edge auto scrolling is functioning and the drag function
  /// is placed correctly inside the [Scrollable].
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
}
