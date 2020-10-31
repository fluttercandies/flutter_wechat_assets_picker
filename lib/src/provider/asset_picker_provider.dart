///
/// [Author] Alex (https://github.com/Alex525)
/// [Date] 2020/3/31 15:28
///
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../constants/constants.dart';

/// [ChangeNotifier] for assets picker.
/// 资源选择器的 provider model
abstract class AssetPickerProvider<A, P> extends ChangeNotifier {
  /// Call [getAssetList] with route duration when constructing.
  /// 构造时根据路由时长延时获取资源
  AssetPickerProvider({
    this.maxAssets = 9,
    this.pageSize = 320,
    this.pathThumbSize = 80,
    List<A> selectedAssets,
    Duration routeDuration,
  }) {
    if (selectedAssets?.isNotEmpty ?? false) {
      _selectedAssets = List<A>.from(selectedAssets);
    }
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

  /// Clear all fields when dispose.
  /// 销毁时重置所有内容
  @override
  void dispose() {
    _isAssetsEmpty = false;
    _isSwitchingPath = false;
    _pathEntityList.clear();
    _currentPath = null;
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
  final Map<P, Uint8List> _pathEntityList = <P, Uint8List>{};

  Map<P, Uint8List> get pathEntityList => _pathEntityList;

  /// The path which is currently using.
  /// 正在查看的资源路径
  P _currentPath;

  P get currentPath => _currentPath;

  set currentPathEntity(P value) {
    assert(value != null);
    if (value == _currentPath) {
      return;
    }
    _currentPath = value;
    notifyListeners();
  }

  /// Assets under current path entity.
  /// 正在查看的资源路径下的所有资源
  List<A> _currentAssets;

  List<A> get currentAssets => _currentAssets;

  set currentAssets(List<A> value) {
    assert(value != null);
    if (value == _currentAssets) {
      return;
    }
    _currentAssets = List<A>.from(value);
    notifyListeners();
  }

  /// Selected assets.
  /// 已选中的资源
  List<A> _selectedAssets = <A>[];

  List<A> get selectedAssets => _selectedAssets;

  set selectedAssets(List<A> value) {
    assert(value != null);
    if (value == _selectedAssets) {
      return;
    }
    _selectedAssets = List<A>.from(value);
    notifyListeners();
  }

  /// 选中资源是否为空
  bool get isSelectedNotEmpty => selectedAssets.isNotEmpty;

  /// Get assets path entities.
  /// 获取所有的资源路径
  Future<void> getAssetPathList();

  /// Get assets list from current path entity.
  /// 从当前已选路径获取资源列表
  Future<void> getAssetList();

  /// Get thumb data from the first asset under the specific path entity.
  /// 获取指定路径下的第一个资源的缩略数据
  Future<Uint8List> getFirstThumbFromPathEntity(P path);

  /// Get assets under the specific path entity.
  /// 获取指定路径下的资源
  Future<void> getAssetsFromEntity(int page, P path);

  /// Load more assets.
  /// 加载更多资源
  Future<void> loadMoreAssets();

  /// Select asset.
  /// 选中资源
  void selectAsset(A item) {
    if (selectedAssets.length == maxAssets || selectedAssets.contains(item)) {
      return;
    }
    final List<A> _set = List<A>.from(selectedAssets);
    _set.add(item);
    selectedAssets = _set;
  }

  /// Un-select asset.
  /// 取消选中资源
  void unSelectAsset(A item) {
    final List<A> _set = List<A>.from(selectedAssets);
    _set.remove(item);
    selectedAssets = _set;
  }

  /// Switch path entity.
  /// 切换路径
  void switchPath(P path);
}

class DefaultAssetPickerProvider
    extends AssetPickerProvider<AssetEntity, AssetPathEntity> {
  DefaultAssetPickerProvider({
    this.requestType = RequestType.image,
    this.sortPathDelegate = SortPathDelegate.common,
    this.filterOptions,
    int maxAssets = 9,
    int pageSize = 320,
    int pathThumbSize = 80,
    List<AssetEntity> selectedAssets,
    Duration routeDuration,
  }) : super(
          maxAssets: maxAssets,
          pageSize: pageSize,
          pathThumbSize: pathThumbSize,
          selectedAssets: selectedAssets,
          routeDuration: routeDuration,
        ) {
    Constants.sortPathDelegate = sortPathDelegate ?? SortPathDelegate.common;
  }

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

  @override
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
      _currentPath ??= pathEntityList.keys.elementAt(0);
    }
  }

  @override
  Future<void> getAssetList() async {
    if (_pathEntityList.isNotEmpty) {
      _currentPath = pathEntityList.keys.elementAt(0);
      totalAssetsCount = currentPath.assetCount;
      await getAssetsFromEntity(0, currentPath);
      // Update total assets count.
    } else {
      isAssetsEmpty = true;
    }
  }

  @override
  Future<void> getAssetsFromEntity(int page, AssetPathEntity path) async {
    _currentAssets =
        (await path.getAssetListPaged(page, pageSize ?? path.assetCount))
            .toList();
    _hasAssetsToDisplay = currentAssets?.isNotEmpty ?? false;
    notifyListeners();
  }

  @override
  Future<void> loadMoreAssets() async {
    final List<AssetEntity> assets = (await currentPath.getAssetListPaged(
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

  @override
  void switchPath(AssetPathEntity path) {
    _isSwitchingPath = false;
    _currentPath = path;
    _totalAssetsCount = path.assetCount;
    notifyListeners();
    getAssetsFromEntity(0, currentPath);
  }

  @override
  Future<Uint8List> getFirstThumbFromPathEntity(AssetPathEntity path) async {
    final AssetEntity asset =
        (await path.getAssetListRange(start: 0, end: 1)).elementAt(0);
    final Uint8List assetData =
        await asset.thumbDataWithSize(pathThumbSize, pathThumbSize);
    return assetData;
  }
}
