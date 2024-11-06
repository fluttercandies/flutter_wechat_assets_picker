// Copyright 2019 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by an Apache license that can be found
// in the LICENSE file.

/// Provide some special picker types to integrate
/// un-common pick pattern.
/// 提供一些特殊的选择器类型以整合非常规的选择行为。
enum SpecialPickerType {
  /// WeChat Moments mode.
  /// 微信朋友圈模式
  ///
  /// The user can only select *one video* or *multiple images* at the same time,
  /// and those two asset types cannot be selected at the same time.
  /// 用户只可以选择 **一个视频** 或 **多个图片**，并且两种类型互斥。
  wechatMoment,

  /// Disable preview of assets.
  /// 禁用资源预览
  ///
  /// There is no preview mode when clicking grid items.
  /// In multiple select mode, any click (either on the select indicator or on
  /// the asset itself) will select the asset.
  /// In single select mode, any click directly selects the asset and returns.
  /// 用户在点击网格的 item 时无法进入预览。
  /// 在多选模式下无论点击选择指示还是 item 都将触发选择，
  /// 而在单选模式下将直接返回点击的资源。
  noPreview,

  /// Disable selection of assets.
  /// No selection related widgets are shown, and assets can only be shown,
  /// and allowing actions to be performed on assets by the user.
  ///
  /// 禁用资产选择。
  /// 不显示与选择相关的小部件，只能显示资产，
  /// 并允许用户对资产执行操作。
  noSelection,
}

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
  append,
}
