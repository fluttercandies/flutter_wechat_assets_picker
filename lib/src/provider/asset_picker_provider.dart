///
/// [Author] Alex (https://github.com/Alex525)
/// [Date] 2020/3/31 15:28
///
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

import 'package:wechat_assets_picker/src/constants/constants.dart';

/// [ChangeNotifier] for assets picker.
/// 资源选择器的 provider model
class AssetPickerProvider extends ChangeNotifier {
  /// Call [getAssetList] with route duration when constructing.
  /// 构造时根据路由时长延时获取资源
  AssetPickerProvider({
    this.maxAssets = 9,
    this.pageSize = 320,
    this.pathThumbSize = 80,
    this.requestType = RequestType.image,
    this.sortPathDelegate = SortPathDelegate.common,
    this.filterOptions,
    List<AssetEntity> selectedAssets,
    Duration routeDuration,
  }) {
    if (selectedAssets?.isNotEmpty ?? false) {
      _selectedAssets = List<AssetEntity>.from(selectedAssets);
    }
    Constants.sortPathDelegate = sortPathDelegate ?? SortPathDelegate.common;
    Future<void>.delayed(routeDuration).then(
      (dynamic _) async {
        await getAssetPathList();
        await getAssetList();
      },
    );
  }

  /// Maximum count for asset selection.
  /// 资源选择的最大数量
  final int maxAssets;

  /// Assets should be loaded per page.
  /// 资源选择的最大数量
  final int pageSize;

  /// Thumb size for path selector.
  /// 路径选择器中缩略图的大小
  final int pathThumbSize;

  /// Request assets type.
  /// 请求的资源类型
  final RequestType requestType;

  /// Delegate to sort asset path entities.
  /// 资源路径排序的实现
  final SortPathDelegate sortPathDelegate;

  /// Filter options for the picker.
  /// 选择器的筛选条件
  ///
  /// Will be merged into the base configuration.
  /// 将会与基础条件进行合并。
  final FilterOptionGroup filterOptions;

  /// Clear all fields when dispose.
  /// 销毁时重置所有内容
  @override
  void dispose() {
    _isAssetsEmpty = false;
    _isSwitchingPath = false;
    _pathEntityList.clear();
    _currentPathEntity = null;
    _currentAssets = null;
    _selectedAssets.clear();
    super.dispose();
  }

  /// Whether there're any assets on the devices.
  /// 设备上是否有资源文件
  bool _isAssetsEmpty = false;

  bool get isAssetsEmpty => _isAssetsEmpty;

  set isAssetsEmpty(bool value) {
    if (value == null || value == _isAssetsEmpty) {
      return;
    }
    _isAssetsEmpty = value;
    notifyListeners();
  }

  /// Whether there're any assets that can be displayed.
  /// 是否有资源可供显示
  bool _hasAssetsToDisplay = false;

  bool get hasAssetsToDisplay => _hasAssetsToDisplay;

  set hasAssetsToDisplay(bool value) {
    assert(value != null);
    if (value == _hasAssetsToDisplay) {
      return;
    }
    _hasAssetsToDisplay = value;
    notifyListeners();
  }

  /// Whether there're more assets waiting for load.
  /// 是否还有更多资源可以加载
  bool get hasMoreToLoad => _currentAssets.length < _totalAssetsCount;

  /// The current page for assets list.
  /// 当前加载的资源列表分页数
  int get currentAssetsListPage =>
      (math.max(1, _currentAssets.length) / pageSize).ceil();

  /// Total count for assets.
  /// 资源总数
  int _totalAssetsCount = 0;

  int get totalAssetsCount => _totalAssetsCount;

  set totalAssetsCount(int value) {
    assert(value != null);
    if (value == _totalAssetsCount) {
      return;
    }
    _totalAssetsCount = value;
    notifyListeners();
  }

  /// If path switcher opened.
  /// 是否正在进行路径选择
  bool _isSwitchingPath = false;

  bool get isSwitchingPath => _isSwitchingPath;

  set isSwitchingPath(bool value) {
    assert(value != null);
    if (value == _isSwitchingPath) {
      return;
    }
    _isSwitchingPath = value;
    notifyListeners();
  }

  /// Map for all path entity.
  /// 所有包含资源的路径里列表
  ///
  /// Using [Map] in order to save the thumb data for the first asset under the path.
  /// 使用[Map]来保存路径下第一个资源的缩略数据。
  final Map<AssetPathEntity, Uint8List> _pathEntityList =
      <AssetPathEntity, Uint8List>{};

  Map<AssetPathEntity, Uint8List> get pathEntityList => _pathEntityList;

  /// Path entity currently using.
  /// 正在查看的资源路径
  AssetPathEntity _currentPathEntity;

  AssetPathEntity get currentPathEntity => _currentPathEntity;

  set currentPathEntity(AssetPathEntity value) {
    assert(value != null);
    if (value == _currentPathEntity) {
      return;
    }
    _currentPathEntity = value;
    notifyListeners();
  }

  /// Assets under current path entity.
  /// 正在查看的资源路径下的所有资源
  List<AssetEntity> _currentAssets;

  List<AssetEntity> get currentAssets => _currentAssets;

  set currentAssets(List<AssetEntity> value) {
    assert(value != null);
    if (value == _currentAssets) {
      return;
    }
    _currentAssets = List<AssetEntity>.from(value);
    notifyListeners();
  }

  /// Selected assets.
  /// 已选中的资源
  List<AssetEntity> _selectedAssets = <AssetEntity>[];

  List<AssetEntity> get selectedAssets => _selectedAssets;

  set selectedAssets(List<AssetEntity> value) {
    assert(value != null);
    if (value == _selectedAssets) {
      return;
    }
    _selectedAssets = List<AssetEntity>.from(value);
    notifyListeners();
  }

  /// 选中资源是否为空
  bool get isSelectedNotEmpty => selectedAssets.isNotEmpty;

  /// Get assets path entities.
  /// 获取所有的资源路径
  Future<void> getAssetPathList() async {
    /// Initial base options.
    /// Enable need title for audios and image to get proper display.
    final FilterOptionGroup options = FilterOptionGroup()
      ..setOption(
        AssetType.audio,
        const FilterOption(needTitle: true),
      )
      ..setOption(
        AssetType.image,
        const FilterOption(
          needTitle: true,
          sizeConstraint: SizeConstraint(ignoreSize: true),
        ),
      );

    /// Merge user's filter option into base options if it's not null.
    if (filterOptions != null) {
      options.merge(filterOptions);
    }

    final List<AssetPathEntity> _list = await PhotoManager.getAssetPathList(
      type: requestType,
      filterOption: options,
    );

    /// Sort path using sort path delegate.
    Constants.sortPathDelegate.sort(_list);

    for (final AssetPathEntity pathEntity in _list) {
      // Use sync method to avoid unnecessary wait.
      _pathEntityList[pathEntity] = null;
      if (requestType != RequestType.audio) {
        getFirstThumbFromPathEntity(pathEntity).then((Uint8List data) {
          _pathEntityList[pathEntity] = data;
        });
      }
    }

    /// Set first path entity as current path entity.
    if (_pathEntityList.isNotEmpty) {
      _currentPathEntity ??= pathEntityList.keys.elementAt(0);
    }
  }

  /// Get assets list from current path entity.
  /// 从当前已选路径获取资源列表
  Future<void> getAssetList() async {
    if (_pathEntityList.isNotEmpty) {
      _currentPathEntity = pathEntityList.keys.elementAt(0);
      totalAssetsCount = currentPathEntity.assetCount;
      getAssetsFromEntity(0, currentPathEntity);
      // Update total assets count.
    } else {
      isAssetsEmpty = true;
    }
  }

  /// Get thumb data from the first asset under the specific path entity.
  /// 获取指定路径下的第一个资源的缩略数据
  Future<Uint8List> getFirstThumbFromPathEntity(
      AssetPathEntity pathEntity) async {
    final AssetEntity asset =
        (await pathEntity.getAssetListRange(start: 0, end: 1)).elementAt(0);
    final Uint8List assetData =
        await asset.thumbDataWithSize(pathThumbSize, pathThumbSize);
    return assetData;
  }

  /// Get assets under the specific path entity.
  /// 获取指定路径下的资源
  Future<void> getAssetsFromEntity(int page, AssetPathEntity pathEntity) async {
    _currentAssets = (await pathEntity.getAssetListPaged(
            page, pageSize ?? pathEntity.assetCount))
        .toList();
    _hasAssetsToDisplay = currentAssets?.isNotEmpty ?? false;
    notifyListeners();
  }

  /// Load more assets.
  /// 加载更多资源
  Future<void> loadMoreAssets() async {
    final List<AssetEntity> assets = (await currentPathEntity.getAssetListPaged(
      currentAssetsListPage,
      pageSize,
    ))
        .toList();
    if (assets.isNotEmpty && currentAssets.contains(assets[0])) {
      return;
    } else {
      final List<AssetEntity> tempList = <AssetEntity>[];
      tempList.addAll(_currentAssets);
      tempList.addAll(assets);
      currentAssets = tempList;
    }
  }

  /// Select asset.
  /// 选中资源
  void selectAsset(AssetEntity item) {
    if (selectedAssets.length == maxAssets || selectedAssets.contains(item)) {
      return;
    }
    final List<AssetEntity> _set = List<AssetEntity>.from(selectedAssets);
    _set.add(item);
    selectedAssets = _set;
  }

  /// Un-select asset.
  /// 取消选中资源
  void unSelectAsset(AssetEntity item) {
    final List<AssetEntity> _set = List<AssetEntity>.from(selectedAssets);
    _set.remove(item);
    selectedAssets = _set;
  }

  /// Switch path entity.
  /// 切换路径
  void switchPath(AssetPathEntity pathEntity) {
    _isSwitchingPath = false;
    _currentPathEntity = pathEntity;
    _totalAssetsCount = pathEntity.assetCount;
    notifyListeners();
    getAssetsFromEntity(0, currentPathEntity);
  }
}
