// Copyright 2019 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by an Apache license that can be found
// in the LICENSE file.

import 'package:photo_manager/photo_manager.dart';

import '../models/path_wrapper.dart';

/// @{template wechat_assets_picker.delegates.SortPathDelegate}
/// Delegate to sort asset path entities.
/// 用于资源路径排序的实现
/// @{endtemplate}
///
/// Define [sort] to sort the asset path list.
/// Usually integrate with [List.sort].
/// 通过定义 [sort] 方法对资源路径列表进行排序。通常使用 [List.sort]。
abstract class SortPathDelegate<Path> {
  const SortPathDelegate();

  void sort(List<PathWrapper<Path>> list);

  static const SortPathDelegate<AssetPathEntity> common =
      CommonSortPathDelegate();
}

/// Common sort path delegate.
/// 常用的路径排序实现
///
/// This delegate will bring "Recent" (All photos), "Camera", "Screenshot(?s)"
/// to the front of the paths list.
/// 该实现会把“最近”、“相机”、“截图”排到列表头部。
class CommonSortPathDelegate extends SortPathDelegate<AssetPathEntity> {
  const CommonSortPathDelegate();

  @override
  void sort(List<PathWrapper<AssetPathEntity>> list) {
    if (list.any(
      (PathWrapper<AssetPathEntity> e) => e.path.lastModified != null,
    )) {
      list.sort(
        (PathWrapper<AssetPathEntity> a, PathWrapper<AssetPathEntity> b) {
          if (a.path.lastModified == null || b.path.lastModified == null) {
            return 0;
          }
          if (b.path.lastModified!.isAfter(a.path.lastModified!)) {
            return 1;
          }
          return -1;
        },
      );
    }
    list.sort(
      (PathWrapper<AssetPathEntity> a, PathWrapper<AssetPathEntity> b) {
        if (a.path.isAll) {
          return -1;
        }
        if (b.path.isAll) {
          return 1;
        }
        if (_isCamera(a.path)) {
          return -1;
        }
        if (_isCamera(b.path)) {
          return 1;
        }
        if (_isScreenShot(a.path)) {
          return -1;
        }
        if (_isScreenShot(b.path)) {
          return 1;
        }
        return 0;
      },
    );
  }

  int otherSort(AssetPathEntity path1, AssetPathEntity path2) {
    return path1.name.compareTo(path2.name);
  }

  bool _isCamera(AssetPathEntity entity) {
    return entity.name == 'Camera';
  }

  bool _isScreenShot(AssetPathEntity entity) {
    return entity.name == 'Screenshots' || entity.name == 'Screenshot';
  }
}
