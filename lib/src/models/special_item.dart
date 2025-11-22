import 'package:flutter/widgets.dart' show Widget;
import 'package:meta/meta.dart' show immutable;

import '../constants/enums.dart';
import '../constants/typedefs.dart';

/// Allow users to set special items in the picker grid with [position].
/// 允许用户在选择器中添加一个自定义item，并指定其位置。
@immutable
class SpecialItem<Path> {
  const SpecialItem({
    required this.position,
    required this.builder,
  });

  /// Define how the item will be positioned.
  /// 定义如何摆放item。
  final SpecialItemPosition position;

  /// The widget builder for the the special item.
  /// 自定义item构建。
  final SpecialItemBuilder<Path>? builder;

  @override
  String toString() {
    return 'SpecialItem$Path(position: $position, builder: $builder)';
  }
}

/// A finalized [SpecialItem] which contains its position and the built widget.
/// 已被构建的 [SpecialItem]，包含其位置和 widget 信息。
@immutable
final class SpecialItemFinalized {
  const SpecialItemFinalized({
    required this.position,
    required this.item,
  });

  final SpecialItemPosition position;
  final Widget item;

  @override
  String toString() {
    return 'SpecialItemFinalized(position: $position, item: $item)';
  }
}
