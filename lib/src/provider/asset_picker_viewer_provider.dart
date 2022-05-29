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
  }) {
    _currentlySelectedAssets = List<A>.from(assets ?? <A>[]);
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
    currentlySelectedAssets = _currentlySelectedAssets..add(item);
  }

  /// Un-select asset.
  /// 取消选中资源
  void unSelectAsset(A item) {
    if (currentlySelectedAssets.isEmpty ||
        !currentlySelectedAssets.contains(item)) {
      return;
    }
    currentlySelectedAssets = _currentlySelectedAssets..remove(item);
  }

  @Deprecated('Use selectAsset instead')
  void selectAssetEntity(A entity) => selectAsset(entity);

  @Deprecated('Use unSelectAsset instead')
  void unselectAssetEntity(A entity) => unSelectAsset(entity);
}
