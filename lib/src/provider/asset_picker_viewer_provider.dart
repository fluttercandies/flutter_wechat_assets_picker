///
/// [Author] Alex (https://github.com/Alex525)
/// [Date] 2020/3/31 15:37
///
import 'package:flutter/material.dart';

/// [ChangeNotifier] for assets picker viewer.
/// 资源选择查看器的 provider model.
class AssetPickerViewerProvider<A> extends ChangeNotifier {
  /// Copy selected assets for editing when constructing.
  /// 构造时深拷贝已选择的资源集合，用于后续编辑。
  AssetPickerViewerProvider(List<A>? assets) {
    _currentlySelectedAssets = List<A>.from(assets ?? <A>[]);
  }

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
  void selectAssetEntity(A entity) {
    final List<A> set = List<A>.from(currentlySelectedAssets);
    set.add(entity);
    currentlySelectedAssets = List<A>.from(set);
  }

  /// Un-select asset.
  /// 取消选中资源
  void unSelectAssetEntity(A entity) {
    final List<A> set = List<A>.from(currentlySelectedAssets);
    set.remove(entity);
    currentlySelectedAssets = List<A>.from(set);
  }
}
