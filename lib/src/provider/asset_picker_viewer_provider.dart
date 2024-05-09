// Copyright 2019 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by an Apache license that can be found
// in the LICENSE file.

import 'package:flutter/widgets.dart';

import '../constants/constants.dart';

/// [ChangeNotifier] for assets picker viewer.
/// 资源选择查看器的 provider model.
class AssetPickerViewerProvider<A> extends ChangeNotifier {
  /// Copy selected assets for editing when constructing.
  /// 构造时深拷贝已选择的资源集合，用于后续编辑。
  AssetPickerViewerProvider(
    List<A>? assets, {
    this.maxAssets = defaultMaxAssetsCount,
  }) : assert(maxAssets > 0, 'maxAssets must be greater than 0.') {
    _currentlySelectedAssets = (assets ?? <A>[]).toList();
  }

  /// Maximum count for asset selection.
  /// 资源选择的最大数量
  final int maxAssets;

  /// Selected assets in the viewer.
  /// 查看器中已选择的资源
  late List<A> _currentlySelectedAssets;

  List<A> get currentlySelectedAssets => _currentlySelectedAssets;

  set currentlySelectedAssets(List<A> value) {
    if (value == _currentlySelectedAssets) {
      return;
    }
    _currentlySelectedAssets = value;
    notifyListeners();
  }

  /// 选中资源是否为空
  bool get isSelectedNotEmpty => currentlySelectedAssets.isNotEmpty;

  /// Select asset.
  /// 选中资源
  void selectAsset(A item) {
    if (currentlySelectedAssets.length == maxAssets ||
        currentlySelectedAssets.contains(item)) {
      return;
    }
    final List<A> newList = _currentlySelectedAssets.toList()..add(item);
    currentlySelectedAssets = newList;
  }

  /// Un-select asset.
  /// 取消选中资源
  void unSelectAsset(A item) {
    if (currentlySelectedAssets.isEmpty ||
        !currentlySelectedAssets.contains(item)) {
      return;
    }
    final List<A> newList = _currentlySelectedAssets.toList()..remove(item);
    currentlySelectedAssets = newList;
  }

  @Deprecated('Use selectAsset instead. This will be removed in 10.0.0')
  void selectAssetEntity(A entity) {
    selectAsset(entity);
  }

  @Deprecated('Use unSelectAsset instead. This will be removed in 10.0.0')
  void unselectAssetEntity(A entity) {
    unSelectAsset(entity);
  }
}
