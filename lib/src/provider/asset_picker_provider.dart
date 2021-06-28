///
/// [Author] Alex (https://github.com/Alex525)
/// [Date] 2020/3/31 15:28
///
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../constants/constants.dart';

/// [ChangeNotifier] for assets picker.
///
/// The provider maintain all methods that control assets and paths.
/// By extending it you can customize how you can get all assets or paths,
/// how to fetch the next page of assets, how to get the thumb data of a path.
abstract class AssetPickerProvider<A, P> extends ChangeNotifier {
  AssetPickerProvider({
    this.maxAssets = 9,
    this.pageSize = 320,
    this.pathThumbSize = 80,
    List<A>? selectedAssets,
  }) {
    if (selectedAssets?.isNotEmpty == true) {
      _selectedAssets = List<A>.from(selectedAssets!);
    }
  }

  /// Maximum count for asset selection.
  /// 资源选择的最大数量
  final int maxAssets;

  /// Assets should be loaded per page.
  /// 资源选择的最大数量
  ///
  /// Use `null` to display all assets into a single grid.
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
    _currentPathEntity = null;
    _currentAssets.clear();
    _selectedAssets.clear();
    super.dispose();
  }

  /// Whether there are assets on the devices.
  /// 设备上是否有资源文件
  bool _isAssetsEmpty = false;

  bool get isAssetsEmpty => _isAssetsEmpty;

  set isAssetsEmpty(bool value) {
    if (value == _isAssetsEmpty) {
      return;
    }
    _isAssetsEmpty = value;
    notifyListeners();
  }

  /// Whether there are any assets can be displayed.
  /// 是否有资源可供显示
  bool _hasAssetsToDisplay = false;

  bool get hasAssetsToDisplay => _hasAssetsToDisplay;

  set hasAssetsToDisplay(bool value) {
    if (value == _hasAssetsToDisplay) {
      return;
    }
    _hasAssetsToDisplay = value;
    notifyListeners();
  }

  /// Whether more assets are waiting for a load.
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
  final Map<P, Uint8List?> _pathEntityList = <P, Uint8List?>{};

  Map<P, Uint8List?> get pathEntityList => _pathEntityList;

  /// How many path has a valid thumb data.
  /// 当前有多少目录已经正常载入了缩略图
  ///
  /// This getter provides a "Should Rebuild" condition judgement to [Selector]
  /// with the path entities widget.
  /// 它为目录部件展示部分的 [Selector] 提供了是否重建的条件。
  int get validPathThumbCount =>
      _pathEntityList.values.where((Uint8List? d) => d != null).length;

  /// The path which is currently using.
  /// 正在查看的资源路径
  P? _currentPathEntity;

  P? get currentPathEntity => _currentPathEntity;

  set currentPathEntity(P? value) {
    if (value == null || value == _currentPathEntity) {
      return;
    }
    _currentPathEntity = value;
    notifyListeners();
  }

  /// Assets under current path entity.
  /// 正在查看的资源路径下的所有资源
  List<A> _currentAssets = <A>[];

  List<A> get currentAssets => _currentAssets;

  set currentAssets(List<A> value) {
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
    if (value == _selectedAssets) {
      return;
    }
    _selectedAssets = List<A>.from(value);
    notifyListeners();
  }

  /// Descriptions for selected assets currently.
  /// 当前已被选中的资源的描述
  ///
  /// This getter provides a "Should Rebuild" condition judgement to [Selector]
  /// with the preview widget's selective part.
  /// 它为预览部件的选中部分的 [Selector] 提供了是否重建的条件。
  String get selectedDescriptions => _selectedAssets.fold(
        <String>[],
        (List<String> list, A a) => list..add(a.toString()),
      ).join();

  /// 选中资源是否为空
  bool get isSelectedNotEmpty => selectedAssets.isNotEmpty;

  /// Get assets path entities.
  /// 获取所有的资源路径
  Future<void> getAssetPathList();

  /// Get thumb data from the first asset under the specific path entity.
  /// 获取指定路径下的第一个资源的缩略数据
  Future<Uint8List?> getFirstThumbFromPathEntity(P pathEntity);

  /// Get assets under the specific path entity.
  /// 获取指定路径下的资源
  Future<void> getAssetsFromEntity(int page, P pathEntity);

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
  void switchPath(P pathEntity);
}

class DefaultAssetPickerProvider
    extends AssetPickerProvider<AssetEntity, AssetPathEntity> {
  /// Call [getAssetList] with route duration when constructing.
  /// 构造时根据路由时长延时获取资源
  DefaultAssetPickerProvider({
    List<AssetEntity>? selectedAssets,
    this.requestType = RequestType.image,
    this.sortPathDelegate = SortPathDelegate.common,
    this.filterOptions,
    int maxAssets = 9,
    int pageSize = 80,
    int pathThumbSize = 80,
    Duration routeDuration = const Duration(milliseconds: 300),
  }) : super(
          maxAssets: maxAssets,
          pageSize: pageSize,
          pathThumbSize: pathThumbSize,
          selectedAssets: selectedAssets,
        ) {
    Constants.sortPathDelegate = sortPathDelegate ?? SortPathDelegate.common;
    Future<void>.delayed(routeDuration).then(
      (dynamic _) async {
        await getAssetPathList();
        await getAssetList();
      },
    );
  }

  /// Request assets type.
  /// 请求的资源类型
  final RequestType requestType;

  /// Delegate to sort asset path entities.
  /// 资源路径排序的实现
  final SortPathDelegate? sortPathDelegate;

  /// Filter options for the picker.
  /// 选择器的筛选条件
  ///
  /// Will be merged into the base configuration.
  /// 将会与基础条件进行合并。
  final FilterOptionGroup? filterOptions;

  @override
  Future<void> getAssetPathList() async {
    // Initial base options.
    // Enable need title for audios and image to get proper display.
    final FilterOptionGroup options = FilterOptionGroup(
      imageOption: const FilterOption(
        needTitle: true,
        sizeConstraint: SizeConstraint(ignoreSize: true),
      ),
      audioOption: const FilterOption(
        needTitle: true,
        sizeConstraint: SizeConstraint(ignoreSize: true),
      ),
      containsPathModified: true,
    );

    // Merge user's filter option into base options if it's not null.
    if (filterOptions != null) {
      options.merge(filterOptions!);
    }

    final List<AssetPathEntity> _list = await PhotoManager.getAssetPathList(
      type: requestType,
      filterOption: options,
    );

    // Sort path using sort path delegate.
    Constants.sortPathDelegate.sort(_list);

    for (final AssetPathEntity pathEntity in _list) {
      // Use sync method to avoid unnecessary wait.
      _pathEntityList[pathEntity] = null;
      if (requestType != RequestType.audio) {
        getFirstThumbFromPathEntity(pathEntity).then((Uint8List? data) {
          _pathEntityList[pathEntity] = data;
          notifyListeners();
        });
      }
    }

    // Set first path entity as current path entity.
    if (_pathEntityList.isNotEmpty) {
      _currentPathEntity ??= pathEntityList.keys.elementAt(0);
    }
  }

  /// Get assets list from current path entity.
  /// 从当前已选路径获取资源列表
  Future<void> getAssetList() async {
    if (_pathEntityList.isNotEmpty) {
      _currentPathEntity = _pathEntityList.keys.elementAt(0);
      totalAssetsCount = currentPathEntity!.assetCount;
      await getAssetsFromEntity(0, currentPathEntity!);
      // Update total assets count.
    } else {
      isAssetsEmpty = true;
    }
  }

  @override
  Future<void> getAssetsFromEntity(int page, AssetPathEntity pathEntity) async {
    _currentAssets = (await pathEntity.getAssetListPaged(
      page,
      pageSize,
    ))
        .toList();
    _hasAssetsToDisplay = currentAssets.isNotEmpty;
    notifyListeners();
  }

  @override
  Future<void> loadMoreAssets() async {
    final List<AssetEntity> assets =
        (await currentPathEntity!.getAssetListPaged(
      currentAssetsListPage,
      pageSize,
    ))
            .toList();
    if (assets.isNotEmpty && currentAssets.contains(assets[0])) {
      return;
    }
    final List<AssetEntity> tempList = <AssetEntity>[];
    tempList.addAll(_currentAssets);
    tempList.addAll(assets);
    currentAssets = tempList;
  }

  @override
  Future<void> switchPath(AssetPathEntity pathEntity) async {
    _isSwitchingPath = false;
    _currentPathEntity = pathEntity;
    _totalAssetsCount = pathEntity.assetCount;
    notifyListeners();
    await getAssetsFromEntity(0, currentPathEntity!);
  }

  @override
  Future<Uint8List?> getFirstThumbFromPathEntity(
    AssetPathEntity pathEntity,
  ) async {
    final AssetEntity asset = (await pathEntity.getAssetListRange(
      start: 0,
      end: 1,
    ))
        .elementAt(0);
    final Uint8List? assetData =
        await asset.thumbDataWithSize(pathThumbSize, pathThumbSize);
    return assetData;
  }
}
