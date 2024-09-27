import 'package:flutter/material.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

/// Allow users to set a special item in the picker grid with specified [position].
/// 允许用户在选择器中添加一个自定义item，并指定其位置。
@immutable
class SpecialItem<Path> {
  const SpecialItem({
    required this.builder,
    required this.position,
  });

  /// The widget builder for the the special item.
  /// 自定义item构建。
  final SpecialItemBuilder<Path>? builder;

  /// Define how the item will be positioned.
  /// 定义如何摆放item。
  final SpecialItemPosition position;
}
