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
import '../models/path_wrapper.dart';

/// [ChangeNotifier] for assets picker.
///
/// The provider maintain all methods that control assets and paths.
/// By extending it you can customize how you can get all assets or paths,
/// how to fetch the next page of assets,
/// and how to get the thumbnail data of a path.
abstract class AssetPickerProvider<Asset, Path> extends ChangeNotifier {
  AssetPickerProvider({
    this.maxAssets = defaultMaxAssetsCount,
    this.pageSize = defaultAssetsPerPage,
    this.pathThumbnailSize = defaultPathThumbnailSize,
    List<Asset>? selectedAssets,
  }) {
    if (selectedAssets != null && selectedAssets.isNotEmpty) {
      _selectedAssets = selectedAssets.toList();
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
    _paths.clear();
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
  Future<Uint8List?> getThumbnailFromPath(PathWrapper<Path> path);

  /// Switch between paths.
  /// 切换路径
  Future<void> switchPath([PathWrapper<Path>? path]);

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
  bool get hasMoreToLoad => _currentAssets.length < _totalAssetsCount!;

  /// The current page for assets list.
  /// 当前加载的资源列表分页数
  int get currentAssetsListPage =>
      (math.max(1, _currentAssets.length) / pageSize).ceil();

  /// Total count for assets.
  /// 资源总数
  int? get totalAssetsCount => _totalAssetsCount;
  int? _totalAssetsCount;

  set totalAssetsCount(int? value) {
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
  List<PathWrapper<Path>> get paths => _paths;
  final List<PathWrapper<Path>> _paths = <PathWrapper<Path>>[];

  /// Set thumbnail [data] for the specific [path].
  /// 为指定的路径设置缩略图数据
  void setPathThumbnail(Path path, Uint8List? data) {
    final int index = _paths.indexWhere(
      (PathWrapper<Path> w) => w.path == path,
    );
    if (index != -1) {
      final PathWrapper<Path> newWrapper = _paths[index].copyWith(
        thumbnailData: data,
      );
      _paths[index] = newWrapper;
      notifyListeners();
    }
  }

  /// The path which is currently using.
  /// 正在查看的资源路径
  PathWrapper<Path>? get currentPath => _currentPath;
  PathWrapper<Path>? _currentPath;

  set currentPath(PathWrapper<Path>? value) {
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
    _currentAssets = value.toList();
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
    _selectedAssets = value.toList();
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
    final List<Asset> set = selectedAssets.toList();
    set.add(item);
    selectedAssets = set;
  }

  /// Un-select asset.
  /// 取消选中资源
  void unSelectAsset(Asset item) {
    final List<Asset> set = selectedAssets.toList();
    set.remove(item);
    selectedAssets = set;
  }
}

class DefaultAssetPickerProvider
    extends AssetPickerProvider<AssetEntity, AssetPathEntity> {
  DefaultAssetPickerProvider({
    super.selectedAssets,
    super.maxAssets,
    super.pageSize,
    super.pathThumbnailSize,
    this.requestType = RequestType.image,
    this.sortPathDelegate = SortPathDelegate.common,
    this.sortPathsByModifiedDate = false,
    this.filterOptions,
    Duration initializeDelayDuration = const Duration(milliseconds: 250),
  }) {
    Singleton.sortPathDelegate = sortPathDelegate ?? SortPathDelegate.common;
    // Call [getAssetList] with route duration when constructing.
    Future<void>.delayed(initializeDelayDuration, () async {
      await getPaths();
      await getAssetsFromCurrentPath();
    });
  }

  @visibleForTesting
  DefaultAssetPickerProvider.forTest({
    super.selectedAssets,
    this.requestType = RequestType.image,
    this.sortPathDelegate = SortPathDelegate.common,
    this.sortPathsByModifiedDate = false,
    this.filterOptions,
    super.maxAssets,
    super.pageSize = 80,
    super.pathThumbnailSize,
  }) {
    Singleton.sortPathDelegate = sortPathDelegate ?? SortPathDelegate.common;
  }

  /// Request assets type.
  /// 请求的资源类型
  final RequestType requestType;

  /// @{macro wechat_assets_picker.delegates.SortPathDelegate}
  final SortPathDelegate<AssetPathEntity>? sortPathDelegate;

  /// {@macro wechat_assets_picker.constants.AssetPickerConfig.sortPathsByModifiedDate}
  final bool sortPathsByModifiedDate;

  /// Filter options for the picker.
  /// 选择器的筛选条件
  ///
  /// Will be merged into the base configuration.
  /// 将会与基础条件进行合并。
  final FilterOptionGroup? filterOptions;

  @override
  set currentPath(PathWrapper<AssetPathEntity>? value) {
    if (value == _currentPath) {
      return;
    }
    _currentPath = value;
    if (value != null) {
      final int index = _paths.indexWhere(
        (PathWrapper<AssetPathEntity> p) => p.path.id == value.path.id,
      );
      if (index != -1) {
        _paths[index] = value;
        getThumbnailFromPath(value);
      }
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
      containsPathModified: sortPathsByModifiedDate,
    );

    // Merge user's filter option into base options if it's not null.
    if (filterOptions != null) {
      options.merge(filterOptions!);
    }

    final List<AssetPathEntity> list = await PhotoManager.getAssetPathList(
      type: requestType,
      filterOption: options,
    );

    for (final AssetPathEntity pathEntity in list) {
      final int index = _paths.indexWhere(
        (PathWrapper<AssetPathEntity> p) => p.path.id == pathEntity.id,
      );
      final PathWrapper<AssetPathEntity> wrapper = PathWrapper<AssetPathEntity>(
        path: pathEntity,
      );
      if (index == -1) {
        _paths.add(wrapper);
      } else {
        _paths[index] = wrapper;
      }
    }
    // Sort path using sort path delegate.
    Singleton.sortPathDelegate.sort(_paths);
    // Use sync method to avoid unnecessary wait.
    _paths
      ..forEach(getAssetCountFromPath)
      ..forEach(getThumbnailFromPath);

    // Set first path entity as current path entity.
    if (_paths.isNotEmpty) {
      _currentPath ??= _paths.first;
    }
  }

  @override
  Future<void> getAssetsFromPath([int? page, AssetPathEntity? path]) async {
    page ??= currentAssetsListPage;
    path ??= currentPath!.path;
    final List<AssetEntity> list = await path.getAssetListPaged(
      page: page,
      size: pageSize,
    );
    if (page == 0) {
      _currentAssets = list;
    } else {
      _currentAssets.addAll(list);
    }
    _hasAssetsToDisplay = currentAssets.isNotEmpty;
    notifyListeners();
  }

  @override
  Future<void> loadMoreAssets() => getAssetsFromPath();

  @override
  Future<void> switchPath([PathWrapper<AssetPathEntity>? path]) async {
    assert(
      () {
        if (path == null && _currentPath == null) {
          throw FlutterError.fromParts(<DiagnosticsNode>[
            ErrorSummary('Switching empty path.'),
            ErrorDescription(
              'Neither "path" nor "currentPathEntity" is non-null, '
              'which makes this method useless.',
            ),
            ErrorHint(
              'You need to pass a non-null path or call this method '
              'when the "currentPath" is not null.',
            ),
          ]);
        }
        return true;
      }(),
    );
    if (path == null && _currentPath == null) {
      return;
    }
    path ??= _currentPath!;
    _currentPath = path;
    await getAssetsFromCurrentPath();
  }

  @override
  Future<Uint8List?> getThumbnailFromPath(
    PathWrapper<AssetPathEntity> path,
  ) async {
    if (requestType == RequestType.audio) {
      return null;
    }
    final int assetCount = path.assetCount ?? await path.path.assetCountAsync;
    if (assetCount == 0) {
      return null;
    }
    final List<AssetEntity> assets = await path.path.getAssetListRange(
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
    final Uint8List? data = await asset.thumbnailDataWithSize(
      pathThumbnailSize,
    );
    final int index = _paths.indexWhere(
      (PathWrapper<AssetPathEntity> p) => p.path == path.path,
    );
    if (index != -1) {
      _paths[index] = _paths[index].copyWith(thumbnailData: data);
      notifyListeners();
    }
    return data;
  }

  Future<void> getAssetCountFromPath(PathWrapper<AssetPathEntity> path) async {
    final int assetCount = await path.path.assetCountAsync;
    final int index = _paths.indexWhere(
      (PathWrapper<AssetPathEntity> p) => p == path,
    );
    if (index != -1) {
      _paths[index] = _paths[index].copyWith(assetCount: assetCount);
      if (index == 0) {
        _currentPath = _currentPath?.copyWith(assetCount: assetCount);
      }
      notifyListeners();
    }
  }

  /// Get assets list from current path entity.
  /// 从当前已选路径获取资源列表
  Future<void> getAssetsFromCurrentPath() async {
    if (_currentPath != null && _paths.isNotEmpty) {
      final PathWrapper<AssetPathEntity> wrapper = _currentPath!;
      final int assetCount =
          wrapper.assetCount ?? await wrapper.path.assetCountAsync;
      totalAssetsCount = assetCount;
      if (wrapper.assetCount == null) {
        currentPath = _currentPath!.copyWith(assetCount: assetCount);
      }
      await getAssetsFromPath(0, currentPath!.path);
    } else {
      isAssetsEmpty = true;
    }
  }
}
