// Copyright 2019 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by an Apache license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

import '../constants/typedefs.dart';
import '../delegates/asset_picker_text_delegate.dart';
import '../delegates/sort_path_delegate.dart';
import 'constants.dart';
import 'enums.dart';

class AssetPickerConfig {
  const AssetPickerConfig({
    this.selectedAssets,
    this.maxAssets = defaultMaxAssetsCount,
    this.pageSize = defaultAssetsPerPage,
    this.gridThumbnailSize = defaultAssetGridPreviewSize,
    this.pathThumbnailSize = defaultPathThumbnailSize,
    this.previewThumbnailSize,
    this.requestType = RequestType.common,
    this.specialPickerType,
    this.keepScrollOffset = false,
    this.sortPathDelegate,
    this.sortPathsByModifiedDate = false,
    this.filterOptions,
    this.gridCount = 4,
    this.themeColor,
    this.pickerTheme,
    this.textDelegate,
    this.specialItemPosition = SpecialItemPosition.none,
    this.specialItemBuilder,
    this.loadingIndicatorBuilder,
    this.selectPredicate,
    this.shouldRevertGrid,
    this.limitedPermissionOverlayPredicate,
    this.pathNameBuilder,
    this.assetsChangeCallback,
    this.assetsChangeRefreshPredicate,
    this.shouldAutoplayPreview = false,
    this.dragToSelect,
  })  : assert(
          pickerTheme == null || themeColor == null,
          'pickerTheme and themeColor cannot be set at the same time.',
        ),
        assert(maxAssets > 0, 'maxAssets must be greater than 0.'),
        assert(pageSize > 0, 'pageSize must be greater than 0.'),
        assert(gridCount > 0, 'gridCount must be greater than 0.'),
        assert(
          pageSize % gridCount == 0,
          'pageSize must be a multiple of gridCount.',
        ),
        assert(
          specialPickerType != SpecialPickerType.wechatMoment ||
              requestType == RequestType.common,
          'SpecialPickerType.wechatMoment and requestType '
          'cannot be set at the same time.',
        ),
        assert(
          (specialItemBuilder == null &&
                  identical(specialItemPosition, SpecialItemPosition.none)) ||
              (specialItemBuilder != null &&
                  !identical(specialItemPosition, SpecialItemPosition.none)),
          'Custom item did not set properly.',
        );

  /// Selected assets.
  /// 已选中的资源
  final List<AssetEntity>? selectedAssets;

  /// Maximum count for asset selection.
  /// 资源选择的最大数量
  final int maxAssets;

  /// Assets should be loaded per page.
  /// 资源选择的最大数量
  ///
  /// Use `null` to display all assets into a single grid.
  final int pageSize;

  /// Thumbnail size in the grid.
  /// 预览时网络的缩略图大小
  ///
  /// This only works on images and videos since other types does not have to
  /// request for the thumbnail data. The preview can speed up by reducing it.
  /// 该参数仅生效于图片和视频类型的资源，因为其他资源不需要请求缩略图数据。
  /// 预览图片的速度可以通过适当降低它的数值来提升。
  ///
  /// This cannot be `null` or a large value since you shouldn't use the
  /// original data for the grid.
  /// 该值不能为空或者非常大，因为在网格中使用原数据不是一个好的决定。
  final ThumbnailSize gridThumbnailSize;

  /// Thumbnail size for path selector.
  /// 路径选择器中缩略图的大小
  final ThumbnailSize pathThumbnailSize;

  /// Preview thumbnail size in the viewer.
  /// 预览时图片的缩略图大小
  ///
  /// This only works on images and videos since other types does not have to
  /// request for the thumbnail data. The preview can speed up by reducing it.
  /// 该参数仅生效于图片和视频类型的资源，因为其他资源不需要请求缩略图数据。
  /// 预览图片的速度可以通过适当降低它的数值来提升。
  ///
  /// Default is `null`, which will request the origin data.
  /// 默认为空，即读取原图。
  final ThumbnailSize? previewThumbnailSize;

  /// Request assets type.
  /// 请求的资源类型
  final RequestType requestType;

  /// The current special picker type for the picker.
  /// 当前特殊选择类型
  ///
  /// Several types which are special:
  /// * [SpecialPickerType.wechatMoment] When user selected video,
  ///   no more images can be selected.
  /// * [SpecialPickerType.noPreview] Disable preview of asset;
  ///   Clicking on an asset selects it.
  ///
  /// 这里包含一些特殊选择类型：
  /// * [SpecialPickerType.wechatMoment] 微信朋友圈模式。
  ///   当用户选择了视频，将不能选择图片。
  /// * [SpecialPickerType.noPreview] 禁用资源预览。
  ///   多选时单击资产将直接选中，单选时选中并返回。
  final SpecialPickerType? specialPickerType;

  /// Whether the picker should save the scroll offset between pushes and pops.
  /// 选择器是否可以从同样的位置开始选择
  final bool keepScrollOffset;

  /// @{macro wechat_assets_picker.delegates.SortPathDelegate}
  final SortPathDelegate<AssetPathEntity>? sortPathDelegate;

  /// {@template wechat_assets_picker.constants.AssetPickerConfig.sortPathsByModifiedDate}
  /// Whether to allow sort delegates to sort paths with
  /// [FilterOptionGroup.containsPathModified].
  /// 是否结合 [FilterOptionGroup.containsPathModified] 进行路径排序
  /// {@endtemplate}
  final bool sortPathsByModifiedDate;

  /// Filter options for the picker.
  /// 选择器的筛选条件
  ///
  /// Will be merged into the base configuration.
  /// 将会与基础条件进行合并。
  final PMFilter? filterOptions;

  /// Assets count for the picker.
  /// 资源网格数
  final int gridCount;

  /// Main color for the picker.
  /// 选择器的主题色
  final Color? themeColor;

  /// Theme for the picker.
  /// 选择器的主题
  ///
  /// Usually the WeChat uses the dark version (dark background color)
  /// for the picker. However, some others want a light or a custom version.
  /// 通常情况下微信选择器使用的是暗色（暗色背景）的主题，
  /// 但某些情况下开发者需要亮色或自定义主题。
  final ThemeData? pickerTheme;

  final AssetPickerTextDelegate? textDelegate;

  /// Allow users set a special item in the picker with several positions.
  /// 允许用户在选择器中添加一个自定义item，并指定位置
  final SpecialItemPosition specialItemPosition;

  /// The widget builder for the the special item.
  /// 自定义item的构造方法
  final SpecialItemBuilder<AssetPathEntity>? specialItemBuilder;

  /// Indicates the loading status for the builder.
  /// 指示目前加载的状态
  final LoadingIndicatorBuilder? loadingIndicatorBuilder;

  /// {@macro wechat_assets_picker.AssetSelectPredicate}
  final AssetSelectPredicate<AssetEntity>? selectPredicate;

  /// Whether the assets grid should revert.
  /// 判断资源网格是否需要倒序排列
  ///
  /// [Null] means judging by Apple OS.
  /// 使用 [Null] 即使用是否为 Apple 系统进行判断。
  final bool? shouldRevertGrid;

  /// {@macro wechat_assets_picker.LimitedPermissionOverlayPredicate}
  final LimitedPermissionOverlayPredicate? limitedPermissionOverlayPredicate;

  /// {@macro wechat_assets_picker.PathNameBuilder}
  final PathNameBuilder<AssetPathEntity>? pathNameBuilder;

  /// {@macro wechat_assets_picker.AssetsChangeCallback}
  final AssetsChangeCallback<AssetPathEntity>? assetsChangeCallback;

  /// {@macro wechat_assets_picker.AssetsChangeRefreshPredicate}
  final AssetsChangeRefreshPredicate<AssetPathEntity>?
      assetsChangeRefreshPredicate;

  /// Whether the preview should auto play.
  /// 预览是否自动播放
  final bool shouldAutoplayPreview;

  /// {@template wechat_assets_picker.constants.AssetPickerConfig.dragToSelect}
  /// Whether assets selection can be done with drag gestures.
  /// 是否开启拖拽选择
  ///
  /// The feature enables by default if no accessibility service is being used.
  /// 在未使用辅助功能的情况下会默认启用该功能。
  ///
  /// The feature is not available when `maxAssets` is `1`.
  /// 当 `maxAssets` 为 `1` 时，该功能不可用。
  /// {@endtemplate}
  final bool? dragToSelect;
}
