///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2022/3/3 09:55
///
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:photo_manager/photo_manager.dart' show PermissionState;

/// {@template wechat_assets_picker.LoadingIndicatorBuilder}
/// Build the loading indicator with the given [isAssetsEmpty].
/// 根据给定的 [isAssetsEmpty] 构建加载指示器。
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
