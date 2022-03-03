///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2022/3/3 09:55
///
import 'dart:async';

import 'package:flutter/widgets.dart';

typedef LoadingIndicatorBuilder = Widget Function(
  BuildContext context,
  bool isAssetsEmpty,
);

/// {@template wechat_assets_picker.AssetSelectPredicate}
/// Predicate whether an asset can be selected or unselected.
/// 判断资源可否被选择
/// {@endtemplate}
typedef AssetSelectPredicate<Asset> = FutureOr<bool> Function(
  BuildContext context,
  Asset asset,
  bool isSelected,
);

/// {@template wechat_asset_picker.SpecialItemBuilder}
/// Build the special item according the given path and assets length.
/// 根据给定的目录和资源数量构建特殊 item
/// {@endtemplate}
typedef SpecialItemBuilder<Path> = Widget? Function(
  BuildContext context,
  Path? path,
  int length,
);
