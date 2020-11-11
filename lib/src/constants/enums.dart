///
/// [Author] Alex (https://github.com/Alex525)
/// [Date] 2020/7/8 12:32
///

/// Provide some special picker types to integrate
/// un-common pick pattern.
/// 提供一些特殊的选择器类型以整合非常规的选择行为。
enum SpecialPickerType { wechatMoment }

/// Provide an item slot for custom widget insertion.
/// 提供一个自定义位置供特殊item放入资源列表中。
enum SpecialItemPosition {
  /// Not insert to the list.
  /// 不放入列表
  none,

  /// Add as leading of the list.
  /// 在列表前放入
  prepend,

  /// Add as trailing of the list.
  /// 在列表后放入
  append
}
