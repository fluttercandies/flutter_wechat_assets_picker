// Copyright 2019 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by an Apache license that can be found
// in the LICENSE file.

import 'dart:async' show Completer;
import 'dart:io' as io show Platform;
import 'dart:math' as math show max;
import 'dart:typed_data' show Uint8List;

import 'package:flutter/material.dart' hide Path;
import 'package:photo_manager/photo_manager.dart';

import '../constants/constants.dart';
import '../delegates/sort_path_delegate.dart';
import '../internals/singleton.dart';
import '../models/path_wrapper.dart';

/// Helps the assets picker to manage [Path]s and [Asset]s.
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
  })  : assert(maxAssets > 0, 'maxAssets must be greater than 0.'),
        assert(pageSize > 0, 'pageSize must be greater than 0.'),
        previousSelectedAssets =
            selectedAssets?.toList(growable: false) ?? List<Asset>.empty(),
        _selectedAssets =
            selectedAssets?.toList() ?? List<Asset>.empty(growable: true);

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

  /// Selected assets before the picker starts picking.
  /// 选择器开始选择前已选中的资源
  final List<Asset> previousSelectedAssets;

  /// Clear all fields when dispose.
  /// 销毁时重置所有内容
  @override
  void dispose() {
    _isAssetsEmpty = false;
    _paths.clear();
    _currentPath = null;
    _currentAssets.clear();
    _mounted = false;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (_mounted) {
      super.notifyListeners();
    }
  }

  /// Whether the provider is mounted. Set to `false` if disposed.
  bool get mounted => _mounted;
  bool _mounted = true;

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

  bool? _hasMoreToLoad;

  /// Whether more assets are waiting for a load.
  /// 是否还有更多资源可以加载
  bool get hasMoreToLoad {
    if (_hasMoreToLoad case final bool value) {
      return value;
    }
    if (_totalAssetsCount case final int count) {
      return _currentAssets.length < count;
    }
    return true;
  }

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

  /// List for all path entity wrapped by [PathWrapper].
  /// 所有资源路径的列表，以 [PathWrapper] 包装
  List<PathWrapper<Path>> get paths => _paths;
  List<PathWrapper<Path>> _paths = <PathWrapper<Path>>[];

  set paths(List<PathWrapper<Path>> value) {
    if (value != _paths) {
      _paths = value;
      notifyListeners();
    }
  }

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
  late List<Asset> _selectedAssets;

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

/// The default implementation of the [AssetPickerProvider] for the picker.
/// The `Asset` is [AssetEntity], and the `Path` is [AssetPathEntity].
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
    init(initializeDelayDuration);
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
  final PMFilter? filterOptions;

  /// Initialize the provider.
  void init(Duration initializeDelayDuration) {
    Singleton.sortPathDelegate = sortPathDelegate ?? SortPathDelegate.common;
    // Call [getAssetList] with route duration when constructing.
    Future<void>.delayed(initializeDelayDuration, () async {
      if (!_mounted) {
        return;
      }

      await getPaths(onlyAll: true);

      if (!_mounted) {
        return;
      }

      await getPaths(onlyAll: false);
    });
  }

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
  Future<void> getPaths({
    bool onlyAll = false,
    bool keepPreviousCount = false,
  }) async {
    final PMFilter? options;
    final fog = filterOptions;
    if (fog is FilterOptionGroup) {
      options = FilterOptionGroup(
        imageOption: const FilterOption(
          sizeConstraint: SizeConstraint(ignoreSize: true),
        ),
        audioOption: const FilterOption(
          // Enable title for audios to get proper display.
          needTitle: true,
          sizeConstraint: SizeConstraint(ignoreSize: true),
        ),
        containsPathModified: sortPathsByModifiedDate,
        createTimeCond: DateTimeCond.def().copyWith(ignore: true),
        updateTimeCond: DateTimeCond.def().copyWith(ignore: true),
      )..merge(fog);
    } else if (fog == null && io.Platform.isAndroid) {
      options = AdvancedCustomFilter(
        orderBy: [OrderByItem.desc(CustomColumns.android.modifiedDate)],
      );
    } else {
      options = fog;
    }

    final list = await PhotoManager.getAssetPathList(
      type: requestType,
      filterOption: options,
      onlyAll: onlyAll,
    );

    _paths = list.map((p) {
      final int? assetCount;
      if (keepPreviousCount) {
        assetCount =
            _paths.where((e) => e.path.id == p.id).firstOrNull?.assetCount;
      } else {
        assetCount = null;
      }
      return PathWrapper<AssetPathEntity>(path: p, assetCount: assetCount);
    }).toList();
    // Sort path using sort path delegate.
    Singleton.sortPathDelegate.sort(_paths);
    // Populate fields to paths without awaiting.
    for (final path in _paths) {
      Future(() async {
        await getAssetCountFromPath(path);
        await getThumbnailFromPath(path);
      });
    }

    // Set first path entity as current path entity.
    if (_paths.isNotEmpty) {
      _currentPath ??= _paths.first;
    }

    if (onlyAll) {
      await getAssetsFromCurrentPath();
    }
  }

  Completer<void>? _getAssetsFromPathCompleter;

  @override
  Future<void> getAssetsFromPath([int? page, AssetPathEntity? path]) {
    Future<void> run() async {
      final currentPage = page ?? currentAssetsListPage;
      final currentPath = path ?? this.currentPath!.path;
      final list = await currentPath.getAssetListPaged(
        page: currentPage,
        size: pageSize,
      );
      if (currentPage == 0) {
        _currentAssets.clear();
        _hasMoreToLoad = null;
      } else if (list.isEmpty) {
        _hasMoreToLoad = false;
      }
      _currentAssets.addAll(list);
      _hasAssetsToDisplay = _currentAssets.isNotEmpty;
      _isAssetsEmpty = _currentAssets.isEmpty;
      notifyListeners();
    }

    if (_getAssetsFromPathCompleter == null) {
      final completer = Completer<void>();
      _getAssetsFromPathCompleter = completer;
      run().then((r) {
        completer.complete();
      }).catchError((Object e, StackTrace s) {
        completer.completeError(e, s);
      }).whenComplete(() {
        _getAssetsFromPathCompleter = null;
      });
    }
    return _getAssetsFromPathCompleter!.future;
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
    try {
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
        _paths[index] = _paths[index].copyWith(
          assetCount: assetCount,
          thumbnailData: data,
        );
        notifyListeners();
      }
      return data;
    } catch (e, s) {
      FlutterError.presentError(
        FlutterErrorDetails(
          exception: e,
          stack: s,
          library: packageName,
          silent: true,
        ),
      );
      return null;
    }
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
    if (_paths.isEmpty && _currentPath != null) {
      throw StateError('The current path is not synced with the empty paths.');
    }
    if (_paths.isNotEmpty && _currentPath == null) {
      throw StateError('The empty path is not synced with the current paths.');
    }
    if (_paths.isEmpty || _currentPath == null) {
      isAssetsEmpty = true;
      return;
    }
    await getAssetsFromPath(0, currentPath!.path);
  }
}
