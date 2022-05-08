// Copyright 2019 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by an Apache license that can be found
// in the LICENSE file.

import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';

import '../constants/constants.dart';
import '../delegates/sort_path_delegate.dart';
import '../internal/singleton.dart';

/// [ChangeNotifier] for assets picker.
///
/// The provider maintain all methods that control assets and paths.
/// By extending it you can customize how you can get all assets or paths,
/// how to fetch the next page of assets,
/// and how to get the thumbnail data of a path.
abstract class AssetPickerProvider<Asset, Path> extends ChangeNotifier {
  AssetPickerProvider({
    this.maxAssets = 9,
    this.pageSize = 320,
    this.pathThumbnailSize = defaultPathThumbnailSize,
    List<Asset>? selectedAssets,
  }) {
    if (selectedAssets?.isNotEmpty == true) {
      _selectedAssets = List<Asset>.from(selectedAssets!);
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

  /// Thumbnail size for path selector.
  /// 路径选择器中缩略图的大小
  final ThumbnailSize pathThumbnailSize;

  /// Clear all fields when dispose.
  /// 销毁时重置所有内容
  @override
  void dispose() {
    _isAssetsEmpty = false;
    _pathsList.clear();
    _currentPath = null;
    _currentAssets.clear();
    _selectedAssets.clear();
    super.dispose();
  }

  /// Get paths.
  /// 获取所有的资源路径
  Future<void> getPaths();

  /// Get the thumbnail from the first asset under the specific path entity.
  /// 获取指定路径下的第一个资源的缩略图数据
  Future<Uint8List?> getThumbnailFromPath(Path path);

  /// Switch between paths.
  /// 切换路径
  Future<void> switchPath([Path? path]);

  /// Get assets under the specific path entity.
  /// 获取指定路径下的资源
  Future<void> getAssetsFromPath(int page, Path path);

  /// Load more assets.
  /// 加载更多资源
  Future<void> loadMoreAssets();

  /// Whether there are assets on the devices.
  /// 设备上是否有资源文件
  bool get isAssetsEmpty => _isAssetsEmpty;
  bool _isAssetsEmpty = false;

  set isAssetsEmpty(bool value) {
    if (value == _isAssetsEmpty) {
      return;
    }
    _isAssetsEmpty = value;
    notifyListeners();
  }

  /// Whether there are any assets can be displayed.
  /// 是否有资源可供显示
  bool get hasAssetsToDisplay => _hasAssetsToDisplay;
  bool _hasAssetsToDisplay = false;

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
  int get totalAssetsCount => _totalAssetsCount;
  int _totalAssetsCount = 0;

  set totalAssetsCount(int value) {
    if (value == _totalAssetsCount) {
      return;
    }
    _totalAssetsCount = value;
    notifyListeners();
  }

  /// Map for all path entity.
  /// 所有包含资源的路径里列表
  ///
  /// Using [Map] in order to save the thumbnail data
  /// for the first asset under the path.
  /// 使用 [Map] 来保存路径下第一个资源的缩略图数据
  Map<Path, Uint8List?> get pathsList => _pathsList;
  final Map<Path, Uint8List?> _pathsList = <Path, Uint8List?>{};

  /// Set thumbnail [data] for the specific [path].
  /// 为指定的路径设置缩略图数据
  void setPathThumbnail(Path path, Uint8List? data) {
    _pathsList[path] = data;
    notifyListeners();
  }

  /// How many path has a valid thumb data.
  /// 当前有多少目录已经正常载入了缩略图
  ///
  /// This getter provides a "Should Rebuild" condition judgement to [Selector]
  /// with the path entities widget.
  /// 它为目录部件展示部分的 [Selector] 提供了是否重建的条件。
  int get validPathThumbnailsCount =>
      _pathsList.values.where((Uint8List? d) => d != null).length;

  /// The path which is currently using.
  /// 正在查看的资源路径
  Path? get currentPath => _currentPath;
  Path? _currentPath;

  set currentPath(Path? value) {
    if (value == _currentPath) {
      return;
    }
    _currentPath = value;
    notifyListeners();
  }

  /// Assets under current path entity.
  /// 正在查看的资源路径下的所有资源
  List<Asset> get currentAssets => _currentAssets;
  List<Asset> _currentAssets = <Asset>[];

  set currentAssets(List<Asset> value) {
    if (value == _currentAssets) {
      return;
    }
    _currentAssets = List<Asset>.from(value);
    notifyListeners();
  }

  /// Selected assets.
  /// 已选中的资源
  List<Asset> get selectedAssets => _selectedAssets;
  List<Asset> _selectedAssets = <Asset>[];

  set selectedAssets(List<Asset> value) {
    if (value == _selectedAssets) {
      return;
    }
    _selectedAssets = List<Asset>.from(value);
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
        (List<String> list, Asset a) => list..add(a.toString()),
      ).join();

  /// 选中资源是否为空
  bool get isSelectedNotEmpty => selectedAssets.isNotEmpty;

  /// 是否已经选择了最大数量的资源
  bool get selectedMaximumAssets => selectedAssets.length == maxAssets;

  /// Select asset.
  /// 选中资源
  void selectAsset(Asset item) {
    if (selectedAssets.length == maxAssets || selectedAssets.contains(item)) {
      return;
    }
    final List<Asset> _set = List<Asset>.from(selectedAssets);
    _set.add(item);
    selectedAssets = _set;
  }

  /// Un-select asset.
  /// 取消选中资源
  void unSelectAsset(Asset item) {
    final List<Asset> _set = List<Asset>.from(selectedAssets);
    _set.remove(item);
    selectedAssets = _set;
  }
}

class DefaultAssetPickerProvider
    extends AssetPickerProvider<AssetEntity, AssetPathEntity> {
  DefaultAssetPickerProvider({
    List<AssetEntity>? selectedAssets,
    this.requestType = RequestType.image,
    this.sortPathDelegate = SortPathDelegate.common,
    this.filterOptions,
    int maxAssets = 9,
    int pageSize = 80,
    ThumbnailSize pathThumbnailSize = const ThumbnailSize.square(80),
  }) : super(
          maxAssets: maxAssets,
          pageSize: pageSize,
          pathThumbnailSize: pathThumbnailSize,
          selectedAssets: selectedAssets,
        ) {
    Singleton.sortPathDelegate = sortPathDelegate ?? SortPathDelegate.common;
    // Call [getAssetList] with route duration when constructing.
    Future<void>(() async {
      await getPaths();
      await getAssetsFromCurrentPath();
    });
  }

  @visibleForTesting
  DefaultAssetPickerProvider.forTest({
    List<AssetEntity>? selectedAssets,
    this.requestType = RequestType.image,
    this.sortPathDelegate = SortPathDelegate.common,
    this.filterOptions,
    int maxAssets = 9,
    int pageSize = 80,
    ThumbnailSize pathThumbnailSize = const ThumbnailSize.square(80),
  }) : super(
          maxAssets: maxAssets,
          pageSize: pageSize,
          pathThumbnailSize: pathThumbnailSize,
          selectedAssets: selectedAssets,
        ) {
    Singleton.sortPathDelegate = sortPathDelegate ?? SortPathDelegate.common;
  }

  /// Request assets type.
  /// 请求的资源类型
  final RequestType requestType;

  /// Delegate to sort asset path entities.
  /// 资源路径排序的实现
  final SortPathDelegate<AssetPathEntity>? sortPathDelegate;

  /// Filter options for the picker.
  /// 选择器的筛选条件
  ///
  /// Will be merged into the base configuration.
  /// 将会与基础条件进行合并。
  final FilterOptionGroup? filterOptions;

  @override
  set currentPath(AssetPathEntity? value) {
    if (value == _currentPath) {
      return;
    }
    _currentPath = value;
    if (value != null &&
        _pathsList.keys.any((AssetPathEntity p) => p.id == value.id)) {
      final AssetPathEntity previous = _pathsList.keys.singleWhere(
        (AssetPathEntity p) => p.id == value.id,
      );
      final int index = _pathsList.keys.toList().indexOf(previous);
      final List<MapEntry<AssetPathEntity, Uint8List?>> newEntries =
          _pathsList.entries.toList()
            ..removeAt(index)
            ..insert(index, MapEntry<AssetPathEntity, Uint8List?>(value, null));
      _pathsList
        ..clear()
        ..addEntries(newEntries);
      getThumbnailFromPath(value);
    }
    notifyListeners();
  }

  @override
  Future<void> getPaths() async {
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
    Singleton.sortPathDelegate.sort(_list);

    for (final AssetPathEntity pathEntity in _list) {
      // Use sync method to avoid unnecessary wait.
      _pathsList[pathEntity] = null;
      getThumbnailFromPath(pathEntity);
    }

    // Set first path entity as current path entity.
    if (_pathsList.isNotEmpty) {
      _currentPath ??= pathsList.keys.elementAt(0);
    }
  }

  @override
  Future<void> getAssetsFromPath(int page, AssetPathEntity path) async {
    final List<AssetEntity> list = await path.getAssetListPaged(
      page: page,
      size: pageSize,
    );
    _currentAssets = List<AssetEntity>.of(list);
    _hasAssetsToDisplay = currentAssets.isNotEmpty;
    notifyListeners();
  }

  @override
  Future<void> loadMoreAssets() async {
    final List<AssetEntity> list = await currentPath!.getAssetListPaged(
      page: currentAssetsListPage,
      size: pageSize,
    );
    final List<AssetEntity> assets = List<AssetEntity>.of(list);
    if (assets.isNotEmpty && currentAssets.contains(assets[0])) {
      return;
    }
    final List<AssetEntity> tempList = <AssetEntity>[];
    tempList.addAll(_currentAssets);
    tempList.addAll(assets);
    currentAssets = tempList;
  }

  @override
  Future<void> switchPath([AssetPathEntity? path]) async {
    assert(
      () {
        if (_currentPath == null && path == null) {
          throw FlutterError.fromParts(<DiagnosticsNode>[
            ErrorSummary('Empty $AssetPathEntity was switched.'),
            ErrorDescription(
              'Neither currentPathEntity nor pathEntity is non-null, '
              'which makes this method useless.',
            ),
            ErrorHint(
              'You need to pass a non-null $AssetPathEntity '
              'or call this method when currentPathEntity is not null.',
            ),
          ]);
        }
        return true;
      }(),
    );
    if (_currentPath == null && path == null) {
      return;
    }
    path ??= _currentPath!;
    _currentPath = path;
    _totalAssetsCount = path.assetCount;
    notifyListeners();
    await getAssetsFromPath(0, currentPath!);
  }

  @override
  Future<Uint8List?> getThumbnailFromPath(
    AssetPathEntity path,
  ) async {
    assert(
      () {
        if (path.assetCount < 1) {
          throw FlutterError.fromParts(<DiagnosticsNode>[
            ErrorSummary('No assets in the path ${path.id}.'),
            ErrorDescription(
              'Thumbnail can only obtained when the path contains assets.',
            ),
          ]);
        }
        return true;
      }(),
    );
    if (requestType == RequestType.audio) {
      return null;
    }
    final List<AssetEntity> assets = await path.getAssetListRange(
      start: 0,
      end: 1,
    );
    if (assets.isEmpty) {
      return null;
    }
    final AssetEntity asset = assets.single;
    // Obtain the thumbnail only when the asset is image or video.
    if (asset.type != AssetType.image && asset.type != AssetType.video) {
      return null;
    }
    final Uint8List? assetData = await asset.thumbnailDataWithSize(
      pathThumbnailSize,
    );
    _pathsList[path] = assetData;
    notifyListeners();
    return assetData;
  }

  /// Get assets list from current path entity.
  /// 从当前已选路径获取资源列表
  Future<void> getAssetsFromCurrentPath() async {
    if (_pathsList.isNotEmpty) {
      totalAssetsCount = currentPath!.assetCount;
      await getAssetsFromPath(0, currentPath!);
    } else {
      isAssetsEmpty = true;
    }
  }
}
