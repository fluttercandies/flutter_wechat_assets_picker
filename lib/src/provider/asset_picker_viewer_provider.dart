// Copyright 2019 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by an Apache license that can be found
// in the LICENSE file.

import 'package:flutter/foundation.dart' show ChangeNotifier;

import '../constants/constants.dart';

/// [ChangeNotifier] for assets picker viewer.
/// 资源选择查看器的 provider model.
class AssetPickerViewerProvider<Asset> extends ChangeNotifier {
  AssetPickerViewerProvider(
    List<Asset>? assets, {
    this.maxAssets = defaultMaxAssetsCount,
  }) : assert(maxAssets > 0, 'maxAssets must be greater than 0.') {
    // Copy selected assets for editing when constructing.
    // 构造时深拷贝已选择的资源集合，用于后续编辑。
    _currentlySelectedAssets = (assets ?? <Asset>[]).toList();
  }

  /// Maximum count for asset selection.
  /// 资源选择的最大数量
  final int maxAssets;

  /// Selected assets in the viewer.
  /// 查看器中已选择的资源
  late List<Asset> _currentlySelectedAssets;

  List<Asset> get currentlySelectedAssets => _currentlySelectedAssets;

  set currentlySelectedAssets(List<Asset> value) {
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
  void selectAsset(Asset item) {
    if (currentlySelectedAssets.length == maxAssets ||
        currentlySelectedAssets.contains(item)) {
      return;
    }
    final List<Asset> newList = _currentlySelectedAssets.toList()..add(item);
    currentlySelectedAssets = newList;
  }

  /// Un-select asset.
  /// 取消选中资源
  void unSelectAsset(Asset item) {
    if (currentlySelectedAssets.isEmpty ||
        !currentlySelectedAssets.contains(item)) {
      return;
    }
    final List<Asset> newList = _currentlySelectedAssets.toList()..remove(item);
    currentlySelectedAssets = newList;
  }
}
