// Copyright 2019 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by an Apache license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:photo_manager/photo_manager.dart' show PermissionState;
import 'package:provider/provider.dart';

/// Mirroring [ChangeNotifierProvider].
typedef CNP<T extends ChangeNotifier?> = ChangeNotifierProvider<T>;

/// {@template wechat_assets_picker.LoadingIndicatorBuilder}
/// Build the loading indicator with the given `isAssetsEmpty`.
/// 根据给定的 `isAssetsEmpty` 构建加载指示器。
/// {@endtemplate}
typedef LoadingIndicatorBuilder = Widget Function(
  BuildContext context,
  bool isAssetsEmpty,
);

/// {@template wechat_asset_picker.SpecialItemBuilder}
/// Build the special item with the given path and assets length.
/// 根据给定的目录和资源数量构建特殊 item。
/// {@endtemplate}
typedef SpecialItemBuilder<Path> = Widget? Function(
  BuildContext context,
  Path? path,
  int length,
);

/// {@template wechat_assets_picker.AssetSelectPredicate}
/// Predicate whether an asset can be selected or unselected.
/// 判断资源可否被选择。
/// {@endtemplate}
typedef AssetSelectPredicate<Asset> = FutureOr<bool> Function(
  BuildContext context,
  Asset asset,
  bool isSelected,
);

/// {@template wechat_assets_picker.LimitedPermissionOverlayPredicate}
/// Predicate whether the limited permission overlay should be displayed.
/// 判断有限的权限情况下是否展示提示页面。
/// {@endtemplate}
typedef LimitedPermissionOverlayPredicate = bool Function(
  PermissionState permissionState,
);

/// {@template wechat_assets_picker.PathNameBuilder}
/// Build customized path name.
/// 构建自定义路径名称。
/// {@endtemplate}
typedef PathNameBuilder<Path> = String Function(Path path);

/// {@template wechat_assets_picker.AssetsChangeCallback}
/// The callback that will be called when the system notifies assets changes.
/// 当系统通知资源变化时将调用的回调。
/// {@endtemplate}
typedef AssetsChangeCallback<Path> = void Function(
  PermissionState permission,
  MethodCall call,
  Path? path,
);

/// {@template wechat_assets_picker.AssetsChangeRefreshPredicate}
/// Whether assets changing should call refresh with the given `call`
/// and the current selected `path`.
/// 判断资源变化是否根据 `call` 和当前选中的 `path` 进行更新。
/// {@endtemplate}
typedef AssetsChangeRefreshPredicate<Path> = bool Function(
  PermissionState permission,
  MethodCall call,
  Path? path,
);
