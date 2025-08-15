// Copyright 2019 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by an Apache license that can be found
// in the LICENSE file.

import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide Path;
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';
import 'package:provider/provider.dart';
import 'package:wechat_picker_library/wechat_picker_library.dart';

import '../constants/constants.dart';
import '../constants/enums.dart';
import '../constants/typedefs.dart';
import '../delegates/asset_grid_drag_selection_coordinator.dart';
import '../delegates/asset_picker_text_delegate.dart';
import '../internals/singleton.dart';
import '../models/path_wrapper.dart';
import '../provider/asset_picker_provider.dart';
import '../widget/asset_picker.dart';
import '../widget/asset_picker_app_bar.dart';
import '../widget/asset_picker_page_route.dart';
import '../widget/asset_picker_viewer.dart';
import '../widget/builder/asset_entity_grid_item_builder.dart';

/// The delegate to build the whole picker's components.
///
/// By extending the delegate, you can customize every components on you own.
/// Delegate requires two generic types:
///  * [Asset] The type of your assets. Defaults to [AssetEntity].
///  * [Path] The type of your paths. Defaults to [AssetPathEntity].
abstract class AssetPickerBuilderDelegate<Asset, Path> {
  AssetPickerBuilderDelegate({
    required this.initialPermission,
    this.gridCount = 4,
    this.pickerTheme,
    this.specialItemPosition = SpecialItemPosition.none,
    this.specialItemBuilder,
    this.loadingIndicatorBuilder,
    this.selectPredicate,
    this.shouldRevertGrid,
    this.limitedPermissionOverlayPredicate,
    this.pathNameBuilder,
    this.assetsChangeCallback,
    this.assetsChangeRefreshPredicate,
    this.viewerUseRootNavigator = false,
    this.viewerPageRouteSettings,
    this.viewerPageRouteBuilder,
    Color? themeColor,
    AssetPickerTextDelegate? textDelegate,
    Locale? locale,
  })  : assert(gridCount > 0, 'gridCount must be greater than 0.'),
        assert(
          pickerTheme == null || themeColor == null,
          'Theme and theme color cannot be set at the same time.',
        ),
        themeColor = pickerTheme?.colorScheme.secondary ??
            themeColor ??
            defaultThemeColorWeChat {
    Singleton.textDelegate =
        textDelegate ?? assetPickerTextDelegateFromLocale(locale);
  }

  /// The [PermissionState] when the picker is called.
  /// 当选择器被拉起时的权限状态
  final PermissionState initialPermission;

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
  ///
  /// 通常情况下微信选择器使用的是暗色（暗色背景）的主题，
  /// 但某些情况下开发者需要亮色或自定义主题。
  final ThemeData? pickerTheme;

  /// Allow users set a special item in the picker with several positions.
  /// 允许用户在选择器中添加一个自定义 item，并指定位置
  final SpecialItemPosition specialItemPosition;

  /// The widget builder for the the special item.
  /// 自定义 item 的构造方法
  final SpecialItemBuilder<Path>? specialItemBuilder;

  /// Indicates the loading status for the builder.
  /// 指示目前加载的状态
  final LoadingIndicatorBuilder? loadingIndicatorBuilder;

  /// {@macro wechat_assets_picker.AssetSelectPredicate}
  final AssetSelectPredicate<Asset>? selectPredicate;

  /// The [ScrollController] for the preview grid.
  final ScrollController gridScrollController = ScrollController();

  /// If path switcher opened.
  /// 是否正在进行路径选择
  final ValueNotifier<bool> isSwitchingPath = ValueNotifier<bool>(false);

  /// The [GlobalKey] for [assetsGridBuilder] to locate the [ScrollView.center].
  /// [assetsGridBuilder] 用于定位 [ScrollView.center] 的 [GlobalKey]
  final GlobalKey gridRevertKey = GlobalKey();

  /// Whether the assets grid should revert.
  /// 判断资源网格是否需要倒序排列
  ///
  /// [Null] means judging by [isAppleOS].
  /// 使用 [Null] 即使用 [isAppleOS] 进行判断。
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

  final bool viewerUseRootNavigator;
  final RouteSettings? viewerPageRouteSettings;
  final AssetPickerViewerPageRouteBuilder<List<Asset>>? viewerPageRouteBuilder;

  /// [ThemeData] for the picker.
  /// 选择器使用的主题
  ThemeData get theme => pickerTheme ?? AssetPicker.themeData(themeColor);

  /// Return a system ui overlay style according to
  /// the brightness of the theme data.
  /// 根据主题返回状态栏的明暗样式
  SystemUiOverlayStyle get overlayStyle {
    if (theme.appBarTheme.systemOverlayStyle != null) {
      return theme.appBarTheme.systemOverlayStyle!;
    }
    return SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarIconBrightness: theme.effectiveBrightness,
      statusBarBrightness: theme.effectiveBrightness.reverse,
    );
  }

  /// The color for interactive texts.
  /// 可交互的文字的颜色
  Color interactiveTextColor(BuildContext context) => Color.lerp(
        context.iconTheme.color?.withOpacity(.7) ?? Colors.white,
        Colors.blueAccent,
        0.4,
      )!;

  /// Whether the current platform is Apple OS.
  /// 当前平台是否苹果系列系统 (iOS & MacOS)
  bool isAppleOS(BuildContext context) => switch (context.theme.platform) {
        TargetPlatform.iOS || TargetPlatform.macOS => true,
        _ => false,
      };

  /// Whether the picker is under the single asset mode.
  /// 选择器是否为单选模式
  bool get isSingleAssetMode;

  /// Whether the delegate should build the special item.
  /// 是否需要构建自定义 item
  bool get shouldBuildSpecialItem =>
      specialItemPosition != SpecialItemPosition.none &&
      specialItemBuilder != null;

  /// Space between assets item widget.
  /// 资源部件之间的间隔
  double get itemSpacing => 2;

  /// Item's height in app bar.
  /// 顶栏内各个组件的统一高度
  double get appBarItemHeight => 32;

  /// Blur radius in Apple OS layout mode.
  /// 苹果系列系统布局方式下的模糊度
  double get appleOSBlurRadius => 10;

  /// Height for the bottom occupied section.
  /// 底部区域占用的高度
  double get bottomSectionHeight =>
      bottomActionBarHeight + permissionLimitedBarHeight;

  /// Height for bottom action bar.
  /// 底部操作栏的高度
  double get bottomActionBarHeight => kToolbarHeight / 1.1;

  /// Height for the permission limited bar.
  /// 权限受限栏的高度
  double get permissionLimitedBarHeight => isPermissionLimited ? 75 : 0;

  @Deprecated('Use permissionNotifier instead. This will be removed in 10.0.0')
  ValueNotifier<PermissionState> get permission => permissionNotifier;

  /// Notifier for the current [PermissionState].
  /// 当前 [PermissionState] 的监听
  late final permissionNotifier = ValueNotifier<PermissionState>(
    initialPermission,
  );

  late final permissionOverlayDisplay = ValueNotifier<bool>(
    limitedPermissionOverlayPredicate?.call(permissionNotifier.value) ??
        (permissionNotifier.value == PermissionState.limited),
  );

  /// Whether the permission is limited currently.
  /// 当前的权限是否为受限
  bool get isPermissionLimited =>
      permissionNotifier.value == PermissionState.limited;

  bool effectiveShouldRevertGrid(BuildContext context) =>
      shouldRevertGrid ?? isAppleOS(context);

  AssetPickerTextDelegate get textDelegate => Singleton.textDelegate;

  AssetPickerTextDelegate get semanticsTextDelegate =>
      Singleton.textDelegate.semanticsTextDelegate;

  /// Keep a `initState` method to sync with [State].
  /// 保留一个 `initState` 方法与 [State] 同步。
  @mustCallSuper
  void initState(AssetPickerState<Asset, Path> state) {}

  /// Keep a `dispose` method to sync with [State].
  /// 保留一个 `dispose` 方法与 [State] 同步。
  @mustCallSuper
  void dispose() {
    Singleton.scrollPosition = null;
    gridScrollController.dispose();
    isSwitchingPath.dispose();
    permissionNotifier.dispose();
    permissionOverlayDisplay.dispose();
  }

  /// The method to select assets. Delegates can implement this method
  /// to involve with predications, callbacks, etc.
  /// 选择资源的方法。自定义的 delegate 可以通过实现该方法，整合判断、回调等操作。
  @protected
  void selectAsset(BuildContext context, Asset asset, int index, bool selected);

  /// Throttle the assets changing calls.
  Completer<void>? onAssetsChangedLock;

  /// Called when assets changed and obtained notifications from the OS.
  /// 系统发出资源变更的通知时调用的方法
  Future<void> onAssetsChanged(MethodCall call, StateSetter setState) async {}

  /// Determine how to browse assets in the viewer.
  /// 定义如何在查看器中浏览资源
  Future<void> viewAsset(BuildContext context, int? index, Asset currentAsset);

  /// Yes, the build method.
  /// 没错，是它是它就是它，我们亲爱的 build 方法~
  Widget build(BuildContext context);

  /// Path entity select widget builder.
  /// 路径选择部件构建
  Widget pathEntitySelector(BuildContext context);

  /// Item widgets for path entity selector.
  /// 路径单独条目选择组件
  Widget pathEntityWidget({
    required BuildContext context,
    required List<PathWrapper<Path>> list,
    required int index,
  });

  /// A backdrop widget behind the [pathEntityListWidget].
  /// 在 [pathEntityListWidget] 后面的遮罩层
  ///
  /// While the picker is switching path, this will displayed.
  /// If the user tapped on it, it'll collapse the list widget.
  ///
  /// 当选择器正在选择路径时，它会出现。用户点击它时，列表会折叠收起。
  Widget pathEntityListBackdrop(BuildContext context);

  /// List widget for path entities.
  /// 路径选择列表组件
  Widget pathEntityListWidget(BuildContext context);

  /// Confirm button.
  /// 确认按钮
  Widget confirmButton(BuildContext context);

  /// Audio asset type indicator.
  /// 音频类型资源指示
  Widget audioIndicator(BuildContext context, Asset asset);

  /// Video asset type indicator.
  /// 视频类型资源指示
  Widget videoIndicator(BuildContext context, Asset asset);

  /// Animated backdrop widget for items.
  /// 部件选中时的动画遮罩部件
  Widget selectedBackdrop(
    BuildContext context,
    int index,
    Asset asset,
  );

  /// Indicator for assets selected status.
  /// 资源是否已选的指示器
  Widget selectIndicator(BuildContext context, int index, Asset asset);

  /// The main grid view builder for assets.
  /// 主要的资源查看网格部件
  Widget assetsGridBuilder(BuildContext context);

  /// Indicates how would the grid found a reusable [RenderObject] through [id].
  /// 为 Grid 布局指示如何找到可复用的 [RenderObject]。
  ///
  /// See also:
  ///  * [SliverChildBuilderDelegate.findChildIndexCallback].
  int? findChildIndexBuilder({
    required String id,
    required List<Asset> assets,
    int placeholderCount = 0,
  }) =>
      null;

  /// The function which return items count for the assets' grid.
  /// 为资源列表提供内容数量计算的方法
  int assetsGridItemCount({
    required BuildContext context,
    required List<Asset> assets,
    int placeholderCount = 0,
  });

  /// Calculates the placeholder count in the assets grid.
  int assetsGridItemPlaceholderCount({
    required BuildContext context,
    required PathWrapper<Path>? pathWrapper,
    required bool onlyOneScreen,
  }) {
    if (onlyOneScreen) {
      return 0;
    }
    final bool gridRevert = effectiveShouldRevertGrid(context);
    int totalCount = pathWrapper?.assetCount ?? 0;
    // If user chose a special item's position, add 1 count.
    if (specialItemPosition != SpecialItemPosition.none) {
      final specialItem = specialItemBuilder?.call(
        context,
        pathWrapper?.path,
        totalCount,
      );
      if (specialItem != null) {
        totalCount += 1;
      }
    }
    final int result;
    if (gridRevert && totalCount % gridCount != 0) {
      // When there are left items that not filled into one row,
      // filled the row with placeholders.
      result = gridCount - totalCount % gridCount;
    } else {
      // Otherwise, we don't need placeholders.
      result = 0;
    }
    return result;
  }

  /// Calculates the grid anchor when reverting items.
  double assetGridAnchor({
    required BuildContext context,
    required BoxConstraints constraints,
    required PathWrapper<Path>? pathWrapper,
  }) {
    int totalCount = pathWrapper?.assetCount ?? 0;
    // If user chose a special item's position, add 1 count.
    if (specialItemPosition != SpecialItemPosition.none) {
      final specialItem = specialItemBuilder?.call(
        context,
        pathWrapper?.path,
        totalCount,
      );
      if (specialItem != null) {
        totalCount += 1;
      }
    }
    // Here we got a magic calculation. [itemSpacing] needs to be divided by
    // [gridCount] since every grid item is squeezed by the [itemSpacing],
    // and it's actual size is reduced with [itemSpacing / gridCount].
    final double dividedSpacing = itemSpacing / gridCount;
    final double topPadding = context.topPadding + appBarPreferredSize!.height;
    // Calculate rows count.
    final int row = (totalCount / gridCount).ceil();
    final double itemSize = constraints.maxWidth / gridCount;
    // Check whether all rows can be placed at the same time.
    final bool gridRevert = effectiveShouldRevertGrid(context);
    final bool onlyOneScreen =
        row * (itemSize + itemSpacing) <= constraints.maxHeight;
    final double anchor;
    if (!gridRevert || onlyOneScreen) {
      anchor = 0.0;
    } else {
      anchor = math.min(
        (row * (itemSize + dividedSpacing) + topPadding - itemSpacing) /
            constraints.maxHeight,
        1.0,
      );
    }
    return anchor;
  }

  /// The item builder for the assets' grid.
  /// 资源列表项的构建
  Widget assetGridItemBuilder(
    BuildContext context,
    int index,
    List<Asset> currentAssets,
  );

  /// The [Semantics] builder for the assets' grid.
  /// 资源列表项的语义构建
  Widget assetGridItemSemanticsBuilder(
    BuildContext context,
    int index,
    Asset asset,
    Widget child,
  );

  /// The item builder for audio type of asset.
  /// 音频资源的部件构建
  Widget audioItemBuilder(
    BuildContext context,
    int index,
    Asset asset,
  );

  /// The item builder for images and video type of asset.
  /// 图片和视频资源的部件构建
  Widget imageAndVideoItemBuilder(
    BuildContext context,
    int index,
    Asset asset,
  );

  /// Preview button to preview selected assets.
  /// 预览已选资源的按钮
  Widget previewButton(BuildContext context);

  /// Custom app bar for the picker.
  /// 选择器自定义的顶栏
  PreferredSizeWidget appBar(BuildContext context);

  /// The preferred size of [appBar].
  /// [appBar] 的首选大小。
  ///
  /// If it's null, typically means the widget hasn't been built yet.
  /// 为空则意味着 widget 未 build。
  Size? appBarPreferredSize;

  /// Layout for Apple OS devices.
  /// 苹果系列设备的选择器布局
  Widget appleOSLayout(BuildContext context);

  /// Layout for Android devices.
  /// Android设备的选择器布局
  Widget androidLayout(BuildContext context);

  /// Loading indicator.
  /// 加载指示器
  ///
  /// Subclasses need to implement this due to the generic type limitation, and
  /// not all delegates use [AssetPickerProvider].
  ///
  /// See also:
  /// - [DefaultAssetPickerBuilderDelegate.loadingIndicator] as an example.
  Widget loadingIndicator(BuildContext context);

  /// GIF image type indicator.
  /// GIF 类型图片指示
  Widget gifIndicator(BuildContext context, Asset asset) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: AlignmentDirectional.bottomCenter,
            end: AlignmentDirectional.topCenter,
            colors: <Color>[
              theme.canvasColor.withAlpha(128),
              Colors.transparent,
            ],
          ),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
          decoration: !isAppleOS(context)
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: theme.iconTheme.color!.withOpacity(0.75),
                )
              : null,
          child: ScaleText(
            textDelegate.gifIndicator,
            style: TextStyle(
              color: theme.textTheme.bodyMedium?.color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            semanticsLabel: semanticsTextDelegate.gifIndicator,
            strutStyle: const StrutStyle(forceStrutHeight: true, height: 1),
          ),
        ),
      ),
    );
  }

  Widget buildLivePhotoIndicator(BuildContext context, Asset asset) {
    return Align(
      alignment: AlignmentDirectional.bottomCenter,
      child: Container(
        width: double.maxFinite,
        height: 26,
        alignment: AlignmentDirectional.bottomStart,
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: AlignmentDirectional.bottomCenter,
            end: AlignmentDirectional.topCenter,
            colors: <Color>[
              theme.canvasColor.withAlpha(80),
              Colors.transparent,
            ],
          ),
        ),
        child: Image.asset(
          'assets/icon/indicator-live-photos.png',
          package: packageName,
          gaplessPlayback: true,
          color: Colors.white,
        ),
      ),
    );
  }

  /// Indicator when the asset cannot be selected.
  /// 当资源无法被选中时的遮罩
  Widget itemBannedIndicator(BuildContext context, Asset asset) {
    return Consumer<AssetPickerProvider<Asset, Path>>(
      builder: (_, AssetPickerProvider<Asset, Path> p, __) {
        if (!p.selectedAssets.contains(asset) && p.selectedMaximumAssets) {
          return Container(
            color: theme.colorScheme.surface.withOpacity(.85),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  /// Indicator when no assets were found from the current path.
  /// 当前目录下无资源的显示
  Widget emptyIndicator(BuildContext context) {
    return ScaleText(
      textDelegate.emptyList,
      maxScaleFactor: 1.5,
      semanticsLabel: semanticsTextDelegate.emptyList,
    );
  }

  /// Item widgets when the thumb data load failed.
  /// 资源缩略数据加载失败时使用的部件
  Widget failedItemBuilder(BuildContext context) {
    return Center(
      child: ScaleText(
        textDelegate.loadFailed,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 18),
        semanticsLabel: semanticsTextDelegate.loadFailed,
      ),
    );
  }

  /// The effective direction for the assets grid.
  /// 网格实际的方向
  ///
  /// By default, the direction will be reversed if it's iOS/macOS.
  /// 默认情况下，在 iOS/macOS 上方向会反向。
  TextDirection effectiveGridDirection(BuildContext context) {
    final TextDirection od = Directionality.of(context);
    if (effectiveShouldRevertGrid(context)) {
      if (od == TextDirection.ltr) {
        return TextDirection.rtl;
      }
      return TextDirection.ltr;
    }
    return od;
  }

  /// The tip widget displays when the access is limited.
  /// 当访问受限时在底部展示的提示
  Widget accessLimitedBottomTip(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Feedback.forTap(context);
        PhotoManager.openSetting();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: permissionLimitedBarHeight,
        color: theme.primaryColor.withOpacity(isAppleOS(context) ? 0.90 : 1),
        child: Row(
          children: <Widget>[
            const SizedBox(width: 5),
            Icon(
              Icons.warning,
              color: Colors.orange[400]!.withOpacity(.8),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: ScaleText(
                textDelegate.accessAllTip,
                style: context.textTheme.bodySmall?.copyWith(
                  fontSize: 14,
                ),
                semanticsLabel: semanticsTextDelegate.accessAllTip,
              ),
            ),
            Icon(
              Icons.keyboard_arrow_right,
              color: context.iconTheme.color?.withOpacity(.5),
            ),
          ],
        ),
      ),
    );
  }

  /// Action bar widget aligned to bottom.
  /// 底部操作栏部件
  Widget bottomActionBar(BuildContext context) {
    final children = <Widget>[
      if (isPermissionLimited) accessLimitedBottomTip(context),
      Container(
        height: bottomActionBarHeight + context.bottomPadding,
        padding: const EdgeInsets.symmetric(horizontal: 20).copyWith(
          bottom: context.bottomPadding,
        ),
        color: theme.bottomAppBarTheme.color?.withOpacity(
          theme.bottomAppBarTheme.color!.opacity *
              (isAppleOS(context) ? .9 : 1),
        ),
        child: Row(
          children: <Widget>[
            previewButton(context),
            if (!isSingleAssetMode) const Spacer(),
            if (!isSingleAssetMode) confirmButton(context),
          ],
        ),
      ),
    ];
    if (children.isEmpty) {
      return const SizedBox.shrink();
    }
    Widget child = Column(
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
    if (isAppleOS(context)) {
      child = ClipRect(
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(
            sigmaX: appleOSBlurRadius,
            sigmaY: appleOSBlurRadius,
          ),
          child: child,
        ),
      );
    }
    return child;
  }

  /// Back button.
  /// 返回按钮
  Widget backButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: IconButton(
        onPressed: () {
          Navigator.maybeOf(context)?.maybePop();
        },
        tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
        icon: const Icon(Icons.close),
      ),
    );
  }

  /// The overlay when the permission is limited on iOS.
  @Deprecated('Use permissionOverlay instead. This will be removed in 10.0.0')
  Widget iOSPermissionOverlay(BuildContext context) {
    return permissionOverlay(context);
  }

  /// The overlay when the permission is limited.
  Widget permissionOverlay(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final EdgeInsets padding = MediaQuery.paddingOf(context);
    final Widget closeButton = Container(
      margin: const EdgeInsetsDirectional.only(start: 16, top: 4),
      alignment: AlignmentDirectional.centerStart,
      child: IconButton(
        onPressed: () {
          Navigator.maybeOf(context)?.maybePop();
        },
        icon: const Icon(Icons.close),
        padding: EdgeInsets.zero,
        constraints: BoxConstraints.tight(const Size.square(32)),
        tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
      ),
    );

    final Widget limitedTips = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ScaleText(
            textDelegate.unableToAccessAll,
            style: const TextStyle(fontSize: 22),
            textAlign: TextAlign.center,
            semanticsLabel: semanticsTextDelegate.unableToAccessAll,
          ),
          SizedBox(height: size.height / 30),
          ScaleText(
            textDelegate.accessAllTip,
            style: const TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
            semanticsLabel: semanticsTextDelegate.accessAllTip,
          ),
        ],
      ),
    );

    final Widget goToSettingsButton = MaterialButton(
      elevation: 0,
      minWidth: size.width / 2,
      height: appBarItemHeight * 1.25,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      color: themeColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      onPressed: PhotoManager.openSetting,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      child: ScaleText(
        textDelegate.goToSystemSettings,
        style: const TextStyle(fontSize: 17),
        semanticsLabel: semanticsTextDelegate.goToSystemSettings,
      ),
    );

    final Widget accessLimitedButton = Semantics(
      label: semanticsTextDelegate.accessLimitedAssets,
      button: true,
      child: GestureDetector(
        onTap: () {
          permissionOverlayDisplay.value = false;
        },
        child: ScaleText(
          textDelegate.accessLimitedAssets,
          style: TextStyle(color: interactiveTextColor(context)),
        ),
      ),
    );

    return ValueListenableBuilder2<PermissionState, bool>(
      firstNotifier: permissionNotifier,
      secondNotifier: permissionOverlayDisplay,
      builder: (_, PermissionState ps, bool isDisplay, __) {
        if (ps.isAuth || !isDisplay) {
          return const SizedBox.shrink();
        }
        return Positioned.fill(
          child: Semantics(
            sortKey: const OrdinalSortKey(0),
            child: Container(
              padding: EdgeInsets.only(top: padding.top),
              color: context.theme.canvasColor,
              child: Column(
                children: <Widget>[
                  closeButton,
                  Expanded(child: limitedTips),
                  goToSettingsButton,
                  SizedBox(height: size.height / 18),
                  accessLimitedButton,
                  SizedBox(
                    height: math.max(padding.bottom, 24.0),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class DefaultAssetPickerBuilderDelegate
    extends AssetPickerBuilderDelegate<AssetEntity, AssetPathEntity> {
  DefaultAssetPickerBuilderDelegate({
    required this.provider,
    required super.initialPermission,
    super.gridCount,
    super.pickerTheme,
    super.specialItemPosition,
    super.specialItemBuilder,
    super.loadingIndicatorBuilder,
    super.selectPredicate,
    super.shouldRevertGrid,
    super.limitedPermissionOverlayPredicate,
    super.pathNameBuilder,
    super.assetsChangeCallback,
    super.assetsChangeRefreshPredicate,
    super.viewerUseRootNavigator,
    super.viewerPageRouteSettings,
    super.viewerPageRouteBuilder,
    super.themeColor,
    super.textDelegate,
    super.locale,
    this.gridThumbnailSize = defaultAssetGridPreviewSize,
    this.previewThumbnailSize,
    this.specialPickerType,
    this.keepScrollOffset = false,
    this.shouldAutoplayPreview = false,
    this.dragToSelect,
  }) {
    // Add the listener if [keepScrollOffset] is true.
    if (keepScrollOffset) {
      gridScrollController.addListener(keepScrollOffsetListener);
    }
  }

  /// [ChangeNotifier] for asset picker.
  /// 资源选择器状态保持
  final DefaultAssetPickerProvider provider;

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

  /// The current special picker type for the picker.
  /// 当前特殊选择类型
  ///
  /// Several types which are special:
  /// * [SpecialPickerType.wechatMoment] When user selected video, no more images
  /// can be selected.
  /// * [SpecialPickerType.noPreview] Disable preview of asset; Clicking on an
  /// asset selects it.
  ///
  /// 这里包含一些特殊选择类型：
  /// * [SpecialPickerType.wechatMoment] 微信朋友圈模式。当用户选择了视频，将不能选择图片。
  /// * [SpecialPickerType.noPreview] 禁用资源预览。多选时单击资产将直接选中，单选时选中并返回。
  final SpecialPickerType? specialPickerType;

  /// Drag select aggregator.
  /// 拖拽选择协调器
  late final AssetGridDragSelectionCoordinator dragSelectCoordinator =
      AssetGridDragSelectionCoordinator(delegate: this);

  /// Whether the picker should save the scroll offset between pushes and pops.
  /// 选择器是否可以从同样的位置开始选择
  final bool keepScrollOffset;

  /// Whether the preview should auto play.
  /// 预览是否自动播放
  final bool shouldAutoplayPreview;

  /// {@macro wechat_assets_picker.constants.AssetPickerConfig.dragToSelect}
  final bool? dragToSelect;

  /// [Duration] when triggering path switching.
  /// 切换路径时的动画时长
  Duration get switchingPathDuration => const Duration(milliseconds: 300);

  /// [Curve] when triggering path switching.
  /// 切换路径时的动画曲线
  Curve get switchingPathCurve => Curves.easeInOutQuad;

  /// Whether the [SpecialPickerType.wechatMoment] is enabled.
  /// 当前是否为微信朋友圈选择模式
  bool get isWeChatMoment =>
      specialPickerType == SpecialPickerType.wechatMoment;

  /// Whether the preview of assets is enabled.
  /// 资源的预览是否启用
  bool get isPreviewEnabled => specialPickerType != SpecialPickerType.noPreview;

  @override
  bool get isSingleAssetMode => provider.maxAssets == 1;

  /// Whether the bottom actions bar should display.
  bool get hasBottomActions => isPreviewEnabled || !isSingleAssetMode;

  /// The tap gesture recognizer for present limited assets.
  TapGestureRecognizer? presentLimitedTapGestureRecognizer;

  /// The listener to track the scroll position of the [gridScrollController]
  /// if [keepScrollOffset] is true.
  /// 当 [keepScrollOffset] 为 true 时，跟踪 [gridScrollController] 位置的监听。
  void keepScrollOffsetListener() {
    if (gridScrollController.hasClients) {
      Singleton.scrollPosition = gridScrollController.position;
    }
  }

  @override
  void initState(AssetPickerState<AssetEntity, AssetPathEntity> state) {
    super.initState(state);
    presentLimitedTapGestureRecognizer = TapGestureRecognizer()
      ..onTap = PhotoManager.presentLimited;
  }

  /// Be aware that the method will do nothing when [keepScrollOffset] is true.
  /// 注意当 [keepScrollOffset] 为 true 时方法不会进行释放。
  @override
  void dispose() {
    // Skip delegate's dispose when it's keeping scroll offset.
    if (keepScrollOffset) {
      return;
    }
    provider.dispose();
    presentLimitedTapGestureRecognizer?.dispose();
    super.dispose();
  }

  @override
  Future<void> selectAsset(
    BuildContext context,
    AssetEntity asset,
    int index,
    bool selected,
  ) async {
    final bool? selectPredicateResult = await selectPredicate?.call(
      context,
      asset,
      selected,
    );
    if (selectPredicateResult == false) {
      return;
    }
    final DefaultAssetPickerProvider provider =
        context.read<DefaultAssetPickerProvider>();
    if (selected) {
      provider.unSelectAsset(asset);
      return;
    }
    if (isSingleAssetMode) {
      provider.selectedAssets.clear();
    }
    provider.selectAsset(asset);
    if (isSingleAssetMode && !isPreviewEnabled) {
      Navigator.maybeOf(context)?.maybePop(provider.selectedAssets);
    }
  }

  @override
  Future<void> onAssetsChanged(MethodCall call, StateSetter setState) async {
    final permission = permissionNotifier.value;

    bool predicate() {
      final path = provider.currentPath?.path;
      if (assetsChangeRefreshPredicate != null) {
        return assetsChangeRefreshPredicate!(permission, call, path);
      }
      return path?.isAll ?? true;
    }

    if (!predicate()) {
      return;
    }

    assetsChangeCallback?.call(permission, call, provider.currentPath?.path);

    final createIds = <String>[];
    final updateIds = <String>[];
    final deleteIds = <String>[];
    int newCount = 0;
    int oldCount = 0;

    // Typically for iOS.
    if (call.arguments case final Map arguments) {
      if (arguments['newCount'] case final int count) {
        newCount = count;
      }
      if (arguments['oldCount'] case final int count) {
        oldCount = count;
      }
      for (final e in (arguments['create'] as List?) ?? []) {
        if (e['id'] case final String id) {
          createIds.add(id);
        }
      }
      for (final e in (arguments['update'] as List?) ?? []) {
        if (e['id'] case final String id) {
          updateIds.add(id);
        }
      }
      for (final e in (arguments['delete'] as List?) ?? []) {
        if (e['id'] case final String id) {
          deleteIds.add(id);
        }
      }
      if (createIds.isEmpty &&
          updateIds.isEmpty &&
          deleteIds.isEmpty &&
          // Updates with limited permission on iOS does not provide any IDs.
          // Counting on length changes is not reliable.
          (newCount == oldCount && permission != PermissionState.limited)) {
        return;
      }
    }
    // Throttle handling.
    if (onAssetsChangedLock case final lock?) {
      return lock.future;
    }
    final lock = Completer<void>();
    onAssetsChangedLock = lock;

    Future<void>(() async {
      // Replace the updated assets if update only.
      if (updateIds.isNotEmpty && createIds.isEmpty && deleteIds.isEmpty) {
        await Future.wait(
          updateIds.map((id) async {
            final i = provider.currentAssets.indexWhere((e) => e.id == id);
            if (i != -1) {
              final asset =
                  await provider.currentAssets[i].obtainForNewProperties();
              provider.currentAssets[i] = asset!;
            }
          }),
        );
        return;
      }

      await provider.getPaths(keepPreviousCount: true);
      provider.currentPath = provider.paths.first;
      final currentWrapper = provider.currentPath;
      if (currentWrapper != null) {
        final newPath = await currentWrapper.path.obtainForNewProperties();
        final assetCount = await newPath.assetCountAsync;
        final newPathWrapper = PathWrapper<AssetPathEntity>(
          path: newPath,
          assetCount: assetCount,
        );
        if (newPath.isAll) {
          await provider.getAssetsFromCurrentPath();
          final entitiesShouldBeRemoved = <AssetEntity>[];
          for (final entity in provider.selectedAssets) {
            if (!provider.currentAssets.contains(entity)) {
              entitiesShouldBeRemoved.add(entity);
            }
          }
          entitiesShouldBeRemoved.forEach(provider.selectedAssets.remove);
        }
        provider
          ..currentPath = newPathWrapper
          ..hasAssetsToDisplay = assetCount != 0
          ..isAssetsEmpty = assetCount == 0
          ..totalAssetsCount = assetCount
          ..getThumbnailFromPath(newPathWrapper);
      }
      isSwitchingPath.value = false;
    }).then(lock.complete).catchError(lock.completeError).whenComplete(() {
      onAssetsChangedLock = null;
    });
  }

  @override
  Future<void> viewAsset(
    BuildContext context,
    int? index,
    AssetEntity currentAsset,
  ) async {
    final p = context.read<DefaultAssetPickerProvider>();
    // - When we reached the maximum select count and the asset is not selected,
    //   do nothing.
    // - When the special type is WeChat Moment, pictures and videos cannot
    //   be selected at the same time. Video select should be banned if any
    //   pictures are selected.
    if ((!p.selectedAssets.contains(currentAsset) && p.selectedMaximumAssets) ||
        (isWeChatMoment &&
            currentAsset.type == AssetType.video &&
            p.selectedAssets.isNotEmpty)) {
      return;
    }
    final revert = effectiveShouldRevertGrid(context);
    // ignore: no_leading_underscores_for_local_identifiers
    final int _debugFlow; // Only for debug process.
    final List<AssetEntity> current;
    final List<AssetEntity>? selected;
    final int effectiveIndex;
    if (isWeChatMoment) {
      if (currentAsset.type == AssetType.video) {
        current = <AssetEntity>[currentAsset];
        selected = null;
        effectiveIndex = 0;
        _debugFlow = 10;
      } else {
        final List<AssetEntity> list;
        if (index == null) {
          list = p.selectedAssets.reversed.toList(growable: false);
        } else {
          list = p.currentAssets;
        }
        current = list.where((e) => e.type == AssetType.image).toList();
        selected = p.selectedAssets;
        final i = current.indexOf(currentAsset);
        effectiveIndex = revert ? current.length - i - 1 : i;
        _debugFlow = switch ((index == null, revert)) {
          (true, true) => 21,
          (true, false) => 20,
          (false, true) => 31,
          (false, false) => 30,
        };
      }
    } else {
      selected = p.selectedAssets;
      final List<AssetEntity> list;
      if (index == null) {
        if (revert) {
          list = p.selectedAssets.reversed.toList(growable: false);
        } else {
          list = p.selectedAssets;
        }
        effectiveIndex = selected.indexOf(currentAsset);
        current = list;
      } else {
        current = p.currentAssets;
        effectiveIndex = revert ? current.length - index - 1 : index;
      }
      _debugFlow = switch ((index == null, revert)) {
        (true, true) => 41,
        (true, false) => 40,
        (false, true) => 51,
        (false, false) => 50,
      };
    }
    if (current.isEmpty) {
      throw StateError('Previewing empty assets is not allowed. $_debugFlow');
    }
    final List<AssetEntity>? result = await AssetPickerViewer.pushToViewer(
      context,
      currentIndex: effectiveIndex,
      previewAssets: current,
      themeData: theme,
      previewThumbnailSize: previewThumbnailSize,
      selectPredicate: selectPredicate,
      selectedAssets: selected,
      selectorProvider: p,
      specialPickerType: specialPickerType,
      maxAssets: p.maxAssets,
      shouldReversePreview: revert,
      shouldAutoplayPreview: shouldAutoplayPreview,
      useRootNavigator: viewerUseRootNavigator,
      pageRouteSettings: viewerPageRouteSettings,
      pageRouteBuilder: viewerPageRouteBuilder,
    );
    if (result != null) {
      Navigator.maybeOf(context)?.maybePop(result);
    }
  }

  @override
  AssetPickerAppBar appBar(BuildContext context) {
    final AssetPickerAppBar appBar = AssetPickerAppBar(
      title: Semantics(
        onTapHint: semanticsTextDelegate.sActionSwitchPathLabel,
        child: pathEntitySelector(context),
      ),
      leading: backButton(context),
      blurRadius: isAppleOS(context) ? appleOSBlurRadius : 0,
    );
    appBarPreferredSize ??= appBar.preferredSize;
    return appBar;
  }

  @override
  Widget androidLayout(BuildContext context) {
    return AssetPickerAppBarWrapper(
      appBar: appBar(context),
      body: Consumer<DefaultAssetPickerProvider>(
        builder: (BuildContext context, DefaultAssetPickerProvider p, _) {
          final bool shouldDisplayAssets =
              p.hasAssetsToDisplay || shouldBuildSpecialItem;
          return AnimatedSwitcher(
            duration: switchingPathDuration,
            child: shouldDisplayAssets
                ? Stack(
                    children: <Widget>[
                      RepaintBoundary(
                        child: Column(
                          children: <Widget>[
                            Expanded(child: assetsGridBuilder(context)),
                            bottomActionBar(context),
                          ],
                        ),
                      ),
                      pathEntityListBackdrop(context),
                      pathEntityListWidget(context),
                    ],
                  )
                : loadingIndicator(context),
          );
        },
      ),
    );
  }

  @override
  Widget appleOSLayout(BuildContext context) {
    Widget gridLayout(BuildContext context) {
      return ValueListenableBuilder<bool>(
        valueListenable: isSwitchingPath,
        builder: (_, bool isSwitchingPath, __) => Semantics(
          excludeSemantics: isSwitchingPath,
          child: RepaintBoundary(
            child: Stack(
              children: <Widget>[
                Positioned.fill(child: assetsGridBuilder(context)),
                Positioned.fill(top: null, child: bottomActionBar(context)),
              ],
            ),
          ),
        ),
      );
    }

    Widget layout(BuildContext context) {
      return Stack(
        children: <Widget>[
          Positioned.fill(
            child: Consumer<DefaultAssetPickerProvider>(
              builder: (_, DefaultAssetPickerProvider p, __) {
                final Widget child;
                final bool shouldDisplayAssets =
                    p.hasAssetsToDisplay || shouldBuildSpecialItem;
                if (shouldDisplayAssets) {
                  child = Stack(
                    children: <Widget>[
                      gridLayout(context),
                      pathEntityListBackdrop(context),
                      pathEntityListWidget(context),
                    ],
                  );
                } else {
                  child = loadingIndicator(context);
                }
                return AnimatedSwitcher(
                  duration: switchingPathDuration,
                  child: child,
                );
              },
            ),
          ),
          appBar(context),
        ],
      );
    }

    return ValueListenableBuilder<bool>(
      valueListenable: permissionOverlayDisplay,
      builder: (_, bool value, Widget? child) {
        if (value) {
          return ExcludeSemantics(child: child);
        }
        return child!;
      },
      child: layout(context),
    );
  }

  @override
  Widget loadingIndicator(BuildContext context) {
    return Selector<DefaultAssetPickerProvider, bool>(
      selector: (_, DefaultAssetPickerProvider p) => p.isAssetsEmpty,
      builder: (BuildContext context, bool isAssetsEmpty, Widget? w) {
        if (loadingIndicatorBuilder != null) {
          return loadingIndicatorBuilder!(context, isAssetsEmpty);
        }
        return Center(child: isAssetsEmpty ? emptyIndicator(context) : w);
      },
      child: PlatformProgressIndicator(
        color: theme.iconTheme.color,
        size: MediaQuery.sizeOf(context).width / gridCount / 3,
      ),
    );
  }

  @override
  Widget assetsGridBuilder(BuildContext context) {
    appBarPreferredSize ??= appBar(context).preferredSize;
    final bool gridRevert = effectiveShouldRevertGrid(context);
    final accessibleNavigation = MediaQuery.accessibleNavigationOf(context);
    return Selector<DefaultAssetPickerProvider, PathWrapper<AssetPathEntity>?>(
      selector: (_, DefaultAssetPickerProvider p) => p.currentPath,
      builder: (context, wrapper, _) {
        // First, we need the count of the assets.
        int totalCount = wrapper?.assetCount ?? 0;
        final Widget? specialItem;
        // If user chose a special item's position, add 1 count.
        if (specialItemPosition != SpecialItemPosition.none) {
          specialItem = specialItemBuilder?.call(
            context,
            wrapper?.path,
            totalCount,
          );
          if (specialItem != null) {
            totalCount += 1;
          }
        } else {
          specialItem = null;
        }
        if (totalCount == 0 && specialItem == null) {
          return loadingIndicator(context);
        }

        // Obtain the text direction from the correct context and apply to
        // the grid item before it gets manipulated by the grid revert.
        final textDirectionCorrection = Directionality.of(context);

        Widget sliverGrid(
          BuildContext context,
          BoxConstraints constraints,
          List<AssetEntity> assets,
          bool onlyOneScreen,
        ) {
          // Then we use the [totalCount] to calculate placeholders we need.
          final placeholderCount = assetsGridItemPlaceholderCount(
            context: context,
            pathWrapper: wrapper,
            onlyOneScreen: onlyOneScreen,
          );
          return SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, int index) {
                if (placeholderCount > 0) {
                  if (index < placeholderCount) {
                    return const SizedBox.shrink();
                  }
                  index -= placeholderCount;
                }

                Widget child = assetGridItemBuilder(
                  context,
                  index,
                  assets,
                  specialItem: specialItem,
                );

                // Enables drag-to-select when:
                // 1. The feature is enabled manually.
                // 2. The accessibility service is not being used.
                // 3. The picker is not in single asset mode.
                if ((dragToSelect ?? !accessibleNavigation) &&
                    !isSingleAssetMode) {
                  child = GestureDetector(
                    excludeFromSemantics: true,
                    onHorizontalDragStart: (d) {
                      dragSelectCoordinator.onSelectionStart(
                        context: context,
                        globalPosition: d.globalPosition,
                        index: index,
                        asset: assets[index],
                      );
                    },
                    onHorizontalDragUpdate: (d) {
                      dragSelectCoordinator.onSelectionUpdate(
                        context: context,
                        globalPosition: d.globalPosition,
                        constraints: constraints,
                      );
                    },
                    onHorizontalDragCancel:
                        dragSelectCoordinator.resetDraggingStatus,
                    onHorizontalDragEnd: (d) {
                      dragSelectCoordinator.onDragEnd(
                        globalPosition: d.globalPosition,
                      );
                    },
                    onLongPressStart: (d) {
                      dragSelectCoordinator.onSelectionStart(
                        context: context,
                        globalPosition: d.globalPosition,
                        index: index,
                        asset: assets[index],
                      );
                    },
                    onLongPressMoveUpdate: (d) {
                      dragSelectCoordinator.onSelectionUpdate(
                        context: context,
                        globalPosition: d.globalPosition,
                        constraints: constraints,
                      );
                    },
                    onLongPressCancel:
                        dragSelectCoordinator.resetDraggingStatus,
                    onLongPressEnd: (d) {
                      dragSelectCoordinator.onDragEnd(
                        globalPosition: d.globalPosition,
                      );
                    },
                    onPanStart: (d) {
                      dragSelectCoordinator.onSelectionStart(
                        context: context,
                        globalPosition: d.globalPosition,
                        index: index,
                        asset: assets[index],
                      );
                    },
                    onPanUpdate: (d) {
                      dragSelectCoordinator.onSelectionUpdate(
                        context: context,
                        globalPosition: d.globalPosition,
                        constraints: constraints,
                      );
                    },
                    onPanCancel: dragSelectCoordinator.resetDraggingStatus,
                    onPanEnd: (d) {
                      dragSelectCoordinator.onDragEnd(
                        globalPosition: d.globalPosition,
                      );
                    },
                    child: child,
                  );
                }

                return MergeSemantics(
                  child: Directionality(
                    textDirection: textDirectionCorrection,
                    child: child,
                  ),
                );
              },
              childCount: assetsGridItemCount(
                context: context,
                assets: assets,
                placeholderCount: placeholderCount,
                specialItem: specialItem,
              ),
              findChildIndexCallback: (Key? key) {
                if (key is ValueKey<String>) {
                  return findChildIndexBuilder(
                    id: key.value,
                    assets: assets,
                    placeholderCount: placeholderCount,
                  );
                }
                return null;
              },
              // Explicitly disable semantic indexes for custom usage.
              addSemanticIndexes: false,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: gridCount,
              mainAxisSpacing: itemSpacing,
              crossAxisSpacing: itemSpacing,
            ),
          );
        }

        return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            // Calculate rows count.
            final int row = (totalCount / gridCount).ceil();
            final double itemSize = constraints.maxWidth / gridCount;
            // Check whether all rows can be placed at the same time.
            final bool onlyOneScreen =
                row * (itemSize + itemSpacing) <= constraints.maxHeight;

            // Use [ScrollView.anchor] to determine where is the first place of
            // the [SliverGrid]. Each row needs [dividedSpacing] to calculate,
            // then minus one times of [itemSpacing] because spacing's count
            // in the cross axis is always less than the rows.
            final double anchor = assetGridAnchor(
              context: context,
              constraints: constraints,
              pathWrapper: wrapper,
            );

            final reverted = gridRevert && !onlyOneScreen;
            return Directionality(
              textDirection: reverted
                  ? effectiveGridDirection(context)
                  : Directionality.of(context),
              child: ColoredBox(
                color: theme.canvasColor,
                child: Selector<DefaultAssetPickerProvider, List<AssetEntity>>(
                  selector: (_, DefaultAssetPickerProvider p) =>
                      p.currentAssets,
                  builder: (BuildContext context, List<AssetEntity> assets, _) {
                    final SliverGap bottomGap = SliverGap.v(
                      context.bottomPadding + bottomSectionHeight,
                    );
                    appBarPreferredSize ??= appBar(context).preferredSize;
                    return CustomScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      controller: gridScrollController,
                      anchor: anchor,
                      center:
                          gridRevert && !onlyOneScreen ? gridRevertKey : null,
                      slivers: <Widget>[
                        if (isAppleOS(context))
                          SliverGap.v(
                            context.topPadding + appBarPreferredSize!.height,
                          ),
                        sliverGrid(context, constraints, assets, onlyOneScreen),
                        // Append the extra bottom padding for Apple OS.
                        if (anchor == 1 && isAppleOS(context)) bottomGap,
                        if (gridRevert && !onlyOneScreen)
                          SliverToBoxAdapter(
                            key: gridRevertKey,
                            child: const SizedBox.shrink(),
                          ),
                        if (!gridRevert && isAppleOS(context)) bottomGap,
                      ],
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  /// There are several conditions within this builder:
  ///  * Return item builder according to the asset's type.
  ///    * [AssetType.audio] -> [audioItemBuilder]
  ///    * [AssetType.image], [AssetType.video] -> [imageAndVideoItemBuilder]
  ///  * Load more assets when the index reached at third line counting
  ///    backwards.
  ///
  /// 资源构建有几个条件：
  ///  * 根据资源类型返回对应类型的构建：
  ///    * [AssetType.audio] -> [audioItemBuilder] 音频类型
  ///    * [AssetType.image], [AssetType.video] -> [imageAndVideoItemBuilder]
  ///      图片和视频类型
  ///  * 在索引到达倒数第三列的时候加载更多资源。
  @override
  Widget assetGridItemBuilder(
    BuildContext context,
    int index,
    List<AssetEntity> currentAssets, {
    Widget? specialItem,
  }) {
    final DefaultAssetPickerProvider p =
        context.read<DefaultAssetPickerProvider>();
    final int length = currentAssets.length;
    final PathWrapper<AssetPathEntity>? currentWrapper = p.currentPath;
    final AssetPathEntity? currentPathEntity = currentWrapper?.path;

    if (specialItem != null) {
      if ((index == 0 && specialItemPosition == SpecialItemPosition.prepend) ||
          (index == length &&
              specialItemPosition == SpecialItemPosition.append)) {
        return specialItem;
      }
    }

    final int currentIndex;
    if (specialItem != null &&
        specialItemPosition == SpecialItemPosition.prepend) {
      currentIndex = index - 1;
    } else {
      currentIndex = index;
    }

    if (currentPathEntity == null) {
      return const SizedBox.shrink();
    }

    if (p.hasMoreToLoad) {
      if ((p.pageSize <= gridCount * 3 && index == length - 1) ||
          index == length - gridCount * 3) {
        p.loadMoreAssets();
      }
    }

    final AssetEntity asset = currentAssets.elementAt(currentIndex);
    final Widget builder = switch (asset.type) {
      AssetType.image ||
      AssetType.video =>
        imageAndVideoItemBuilder(context, currentIndex, asset),
      AssetType.audio => audioItemBuilder(context, currentIndex, asset),
      AssetType.other => const SizedBox.shrink(),
    };
    final Widget content = Stack(
      key: ValueKey<String>(asset.id),
      children: <Widget>[
        builder,
        selectedBackdrop(context, currentIndex, asset),
        if (!isWeChatMoment || asset.type != AssetType.video)
          selectIndicator(context, currentIndex, asset),
        itemBannedIndicator(context, asset),
      ],
    );
    return assetGridItemSemanticsBuilder(context, index, asset, content);
  }

  int semanticIndex(int index) {
    if (specialItemPosition != SpecialItemPosition.prepend) {
      return index + 1;
    }
    return index;
  }

  @override
  Widget assetGridItemSemanticsBuilder(
    BuildContext context,
    int index,
    AssetEntity asset,
    Widget child,
  ) {
    return ValueListenableBuilder<bool>(
      valueListenable: isSwitchingPath,
      builder: (_, bool isSwitchingPath, Widget? child) {
        return Consumer<DefaultAssetPickerProvider>(
          builder: (_, DefaultAssetPickerProvider p, __) {
            final bool isBanned = (!p.selectedAssets.contains(asset) &&
                    p.selectedMaximumAssets) ||
                (isWeChatMoment &&
                    asset.type == AssetType.video &&
                    p.selectedAssets.isNotEmpty);
            final bool isSelected = p.selectedDescriptions.contains(
              asset.toString(),
            );
            final int selectedIndex = p.selectedAssets.indexOf(asset) + 1;
            final labels = <String>[
              '${semanticsTextDelegate.semanticTypeLabel(asset.type)}'
                  '${semanticIndex(index)}',
              asset.createDateTime.toString().replaceAll('.000', ''),
              if (asset.type == AssetType.audio ||
                  asset.type == AssetType.video)
                '${semanticsTextDelegate.sNameDurationLabel}: '
                    '${semanticsTextDelegate.durationIndicatorBuilder(asset.videoDuration)}',
              if (asset.title case final title? when title.isNotEmpty) title,
            ];
            return Semantics(
              key: ValueKey('${asset.id}-semantics'),
              button: false,
              enabled: !isBanned,
              excludeSemantics: true,
              focusable: !isSwitchingPath,
              label: labels.join(', '),
              hidden: isSwitchingPath,
              image: asset.type == AssetType.image ||
                  asset.type == AssetType.video,
              onTap: () {
                selectAsset(context, asset, index, isSelected);
              },
              onTapHint: semanticsTextDelegate.sActionSelectHint,
              onLongPress: isPreviewEnabled
                  ? () {
                      viewAsset(context, index, asset);
                    }
                  : null,
              onLongPressHint: semanticsTextDelegate.sActionPreviewHint,
              selected: isSelected,
              sortKey: OrdinalSortKey(
                semanticIndex(index).toDouble(),
                name: 'GridItem',
              ),
              value: selectedIndex > 0 ? '$selectedIndex' : null,
              child: GestureDetector(
                // Regression https://github.com/flutter/flutter/issues/35112.
                onLongPress: isPreviewEnabled &&
                        MediaQuery.accessibleNavigationOf(context)
                    ? () {
                        viewAsset(context, index, asset);
                      }
                    : null,
                child: IndexedSemantics(
                  index: semanticIndex(index),
                  child: child,
                ),
              ),
            );
          },
        );
      },
      child: child,
    );
  }

  @override
  int findChildIndexBuilder({
    required String id,
    required List<AssetEntity> assets,
    int placeholderCount = 0,
  }) {
    int index = assets.indexWhere((AssetEntity e) => e.id == id);
    if (specialItemPosition == SpecialItemPosition.prepend) {
      index += 1;
    }
    index += placeholderCount;
    return index;
  }

  @override
  int assetsGridItemCount({
    required BuildContext context,
    required List<AssetEntity> assets,
    int placeholderCount = 0,
    Widget? specialItem,
  }) {
    final PathWrapper<AssetPathEntity>? currentWrapper = context
        .select<DefaultAssetPickerProvider, PathWrapper<AssetPathEntity>?>(
      (DefaultAssetPickerProvider p) => p.currentPath,
    );
    final AssetPathEntity? currentPathEntity = currentWrapper?.path;
    final int length = assets.length + placeholderCount;

    // Return 1 if the [specialItem] build something.
    if (currentPathEntity == null && specialItem != null) {
      return placeholderCount + 1;
    }

    // Return actual length if the current path is all.
    // 如果当前目录是全部内容，则返回实际的内容数量。
    if (currentPathEntity?.isAll != true && specialItem == null) {
      return length;
    }
    return switch (specialItemPosition) {
      SpecialItemPosition.none => length,
      SpecialItemPosition.prepend || SpecialItemPosition.append => length + 1,
    };
  }

  @override
  Widget audioIndicator(BuildContext context, AssetEntity asset) {
    return Container(
      width: double.maxFinite,
      alignment: AlignmentDirectional.bottomStart,
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: AlignmentDirectional.bottomCenter,
          end: AlignmentDirectional.topCenter,
          colors: <Color>[theme.splashColor, Colors.transparent],
        ),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.only(start: 4),
        child: ScaleText(
          textDelegate.durationIndicatorBuilder(
            Duration(seconds: asset.duration),
          ),
          style: const TextStyle(fontSize: 16),
          semanticsLabel: '${semanticsTextDelegate.sNameDurationLabel}: '
              '${semanticsTextDelegate.durationIndicatorBuilder(
            Duration(seconds: asset.duration),
          )}',
        ),
      ),
    );
  }

  @override
  Widget audioItemBuilder(BuildContext context, int index, AssetEntity asset) {
    return Stack(
      children: <Widget>[
        Container(
          width: double.maxFinite,
          alignment: AlignmentDirectional.topStart,
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: AlignmentDirectional.topCenter,
              end: AlignmentDirectional.bottomCenter,
              colors: <Color>[theme.splashColor, Colors.transparent],
            ),
          ),
          child: Padding(
            padding: const EdgeInsetsDirectional.only(start: 4, end: 30),
            child: ScaleText(
              asset.title ?? '',
              style: const TextStyle(fontSize: 16),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        const Align(
          alignment: AlignmentDirectional(0.9, 0.8),
          child: Icon(Icons.audiotrack),
        ),
        audioIndicator(context, asset),
      ],
    );
  }

  /// It'll pop with [AssetPickerProvider.selectedAssets]
  /// when there are any assets were chosen.
  /// 当有资源已选时，点击按钮将把已选资源通过路由返回。
  @override
  Widget confirmButton(BuildContext context) {
    return Consumer<DefaultAssetPickerProvider>(
      builder: (_, DefaultAssetPickerProvider p, __) {
        final bool isSelectedNotEmpty = p.isSelectedNotEmpty;
        final bool shouldAllowConfirm =
            isSelectedNotEmpty || p.previousSelectedAssets.isNotEmpty;
        return MaterialButton(
          minWidth: shouldAllowConfirm ? 48 : 20,
          height: appBarItemHeight,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          color: theme.colorScheme.secondary,
          disabledColor: theme.splashColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3),
          ),
          onPressed: shouldAllowConfirm
              ? () {
                  Navigator.maybeOf(context)?.maybePop(p.selectedAssets);
                }
              : null,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          child: ScaleText(
            isSelectedNotEmpty && !isSingleAssetMode
                ? '${textDelegate.confirm}'
                    ' (${p.selectedAssets.length}/${p.maxAssets})'
                : textDelegate.confirm,
            style: TextStyle(
              color: shouldAllowConfirm
                  ? theme.textTheme.bodyLarge?.color
                  : theme.textTheme.bodySmall?.color,
              fontSize: 17,
              fontWeight: FontWeight.normal,
            ),
            semanticsLabel: isSelectedNotEmpty && !isSingleAssetMode
                ? '${semanticsTextDelegate.confirm}'
                    ' (${p.selectedAssets.length}/${p.maxAssets})'
                : semanticsTextDelegate.confirm,
          ),
        );
      },
    );
  }

  @override
  Widget imageAndVideoItemBuilder(
    BuildContext context,
    int index,
    AssetEntity asset,
  ) {
    return LocallyAvailableBuilder(
      asset: asset,
      isOriginal: false,
      withSubtype: false,
      thumbnailOption: ThumbnailOption(size: gridThumbnailSize),
      builder: (context, asset) {
        final imageProvider = AssetEntityImageProvider(
          asset,
          isOriginal: false,
          thumbnailSize: gridThumbnailSize,
        );
        return Stack(
          fit: StackFit.expand,
          children: <Widget>[
            RepaintBoundary(
              child: AssetEntityGridItemBuilder(
                image: imageProvider,
                failedItemBuilder: failedItemBuilder,
              ),
            ),
            FutureBuilder(
              future: imageProvider.imageFileType,
              builder: (context, snapshot) {
                if (snapshot.data case final type?
                    when type == ImageFileType.gif) {
                  return gifIndicator(context, asset);
                }
                return const SizedBox.shrink();
              },
            ),
            if (asset.type == AssetType.video) // 如果为视频则显示标识
              videoIndicator(context, asset),
            if (asset.isLivePhoto) buildLivePhotoIndicator(context, asset),
          ],
        );
      },
      progressBuilder: (context, state, progress) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            state == PMRequestState.failed
                ? Icons.cloud_off
                : Icons.cloud_download_outlined,
            color: context.iconTheme.color?.withOpacity(.4),
            size: 24.0,
          ),
          if (state != PMRequestState.success && state != PMRequestState.failed)
            ScaleText(
              ' ${((progress ?? 0) * 100).toInt()}%',
              style: TextStyle(
                color: context.textTheme.bodyMedium?.color?.withOpacity(.4),
                fontSize: 12.0,
              ),
            ),
        ],
      ),
    );
  }

  /// While the picker is switching path, this will displayed.
  /// If the user tapped on it, it'll collapse the list widget.
  ///
  /// 当选择器正在选择路径时，它会出现。用户点击它时，列表会折叠收起。
  @override
  Widget pathEntityListBackdrop(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isSwitchingPath,
      builder: (_, bool isSwitchingPath, __) => Positioned.fill(
        child: IgnorePointer(
          ignoring: !isSwitchingPath,
          child: ExcludeSemantics(
            child: GestureDetector(
              onTap: () {
                this.isSwitchingPath.value = false;
              },
              child: AnimatedOpacity(
                duration: switchingPathDuration,
                opacity: isSwitchingPath ? .75 : 0,
                child: const ColoredBox(color: Colors.black),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget pathEntityListWidget(BuildContext context) {
    appBarPreferredSize ??= appBar(context).preferredSize;
    return Positioned.fill(
      top: isAppleOS(context)
          ? context.topPadding + appBarPreferredSize!.height
          : 0,
      bottom: null,
      child: ValueListenableBuilder<bool>(
        valueListenable: isSwitchingPath,
        builder: (_, bool isSwitchingPath, Widget? child) => Semantics(
          hidden: isSwitchingPath ? null : true,
          child: AnimatedAlign(
            duration: switchingPathDuration,
            curve: switchingPathCurve,
            alignment: Alignment.bottomCenter,
            heightFactor: isSwitchingPath ? 1 : 0,
            child: AnimatedOpacity(
              duration: switchingPathDuration,
              curve: switchingPathCurve,
              opacity: !isAppleOS(context) || isSwitchingPath ? 1 : 0,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(10),
                ),
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.sizeOf(context).height *
                        (isAppleOS(context) ? .6 : .8),
                  ),
                  color: theme.colorScheme.surface,
                  child: child,
                ),
              ),
            ),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ValueListenableBuilder<PermissionState>(
              valueListenable: permissionNotifier,
              builder: (_, PermissionState ps, Widget? child) => Semantics(
                label: '${semanticsTextDelegate.viewingLimitedAssetsTip}, '
                    '${semanticsTextDelegate.changeAccessibleLimitedAssets}',
                button: true,
                onTap: PhotoManager.presentLimited,
                hidden: !isPermissionLimited,
                focusable: isPermissionLimited,
                excludeSemantics: true,
                child: isPermissionLimited ? child : const SizedBox.shrink(),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Text.rich(
                  TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: textDelegate.viewingLimitedAssetsTip,
                      ),
                      TextSpan(
                        text: ' '
                            '${textDelegate.changeAccessibleLimitedAssets}',
                        style: TextStyle(color: interactiveTextColor(context)),
                        recognizer: presentLimitedTapGestureRecognizer,
                      ),
                    ],
                  ),
                  style: context.textTheme.bodySmall?.copyWith(fontSize: 14),
                ),
              ),
            ),
            Flexible(
              child: Selector<DefaultAssetPickerProvider,
                  List<PathWrapper<AssetPathEntity>>>(
                selector: (_, DefaultAssetPickerProvider p) => p.paths,
                builder: (_, List<PathWrapper<AssetPathEntity>> paths, __) {
                  final List<PathWrapper<AssetPathEntity>> filtered = paths
                      .where(
                        (PathWrapper<AssetPathEntity> p) => p.assetCount != 0,
                      )
                      .toList();
                  return ListView.separated(
                    padding: const EdgeInsetsDirectional.only(top: 1),
                    shrinkWrap: true,
                    itemCount: filtered.length,
                    itemBuilder: (BuildContext c, int i) => pathEntityWidget(
                      context: c,
                      list: filtered,
                      index: i,
                    ),
                    separatorBuilder: (_, __) => Container(
                      margin: const EdgeInsetsDirectional.only(start: 60),
                      height: 1,
                      color: theme.canvasColor,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget pathEntitySelector(BuildContext context) {
    Widget pathText(
      BuildContext context,
      String text,
      String semanticsText,
    ) {
      return Flexible(
        child: ScaleText(
          text,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.normal,
          ),
          maxLines: 1,
          overflow: TextOverflow.fade,
          maxScaleFactor: 1.2,
          semanticsLabel: semanticsText,
        ),
      );
    }

    return UnconstrainedBox(
      child: GestureDetector(
        onTap: () {
          if (isPermissionLimited && provider.isAssetsEmpty) {
            PhotoManager.presentLimited();
            return;
          }
          if (provider.currentPath == null) {
            return;
          }
          isSwitchingPath.value = !isSwitchingPath.value;
        },
        child: Container(
          height: appBarItemHeight,
          constraints: BoxConstraints(
            maxWidth: MediaQuery.sizeOf(context).width * 0.5,
          ),
          padding: const EdgeInsetsDirectional.only(start: 12, end: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            color: theme.focusColor,
          ),
          child: Selector<DefaultAssetPickerProvider,
              PathWrapper<AssetPathEntity>?>(
            selector: (_, DefaultAssetPickerProvider p) => p.currentPath,
            builder: (_, PathWrapper<AssetPathEntity>? p, Widget? w) {
              final AssetPathEntity? path = p?.path;
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (path == null && isPermissionLimited)
                    pathText(
                      context,
                      textDelegate.changeAccessibleLimitedAssets,
                      semanticsTextDelegate.changeAccessibleLimitedAssets,
                    ),
                  if (path != null)
                    pathText(
                      context,
                      isPermissionLimited && path.isAll
                          ? textDelegate.accessiblePathName
                          : pathNameBuilder?.call(path) ?? path.name,
                      isPermissionLimited && path.isAll
                          ? semanticsTextDelegate.accessiblePathName
                          : pathNameBuilder?.call(path) ?? path.name,
                    ),
                  w!,
                ],
              );
            },
            child: Padding(
              padding: const EdgeInsetsDirectional.only(start: 5),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.iconTheme.color!.withOpacity(0.5),
                ),
                child: ValueListenableBuilder<bool>(
                  valueListenable: isSwitchingPath,
                  builder: (_, bool isSwitchingPath, Widget? w) {
                    return Transform.rotate(
                      angle: isSwitchingPath ? math.pi : 0,
                      child: w,
                    );
                  },
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    size: 20,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget pathEntityWidget({
    required BuildContext context,
    required List<PathWrapper<AssetPathEntity>> list,
    required int index,
  }) {
    final PathWrapper<AssetPathEntity> wrapper = list[index];
    final AssetPathEntity pathEntity = wrapper.path;
    final Uint8List? data = wrapper.thumbnailData;

    Widget builder() {
      if (data != null) {
        return Image.memory(data, fit: BoxFit.cover);
      }
      if (pathEntity.type.containsAudio()) {
        return ColoredBox(
          color: theme.colorScheme.primary.withOpacity(0.12),
          child: const Center(child: Icon(Icons.audiotrack)),
        );
      }
      return ColoredBox(color: theme.colorScheme.primary.withOpacity(0.12));
    }

    final String pathName =
        pathNameBuilder?.call(pathEntity) ?? pathEntity.name;
    final String name = isPermissionLimited && pathEntity.isAll
        ? textDelegate.accessiblePathName
        : pathName;
    final String semanticsName = isPermissionLimited && pathEntity.isAll
        ? semanticsTextDelegate.accessiblePathName
        : pathName;
    final String? semanticsCount = wrapper.assetCount?.toString();
    final StringBuffer labelBuffer = StringBuffer(
      '$semanticsName, ${semanticsTextDelegate.sUnitAssetCountLabel}',
    );
    if (semanticsCount != null) {
      labelBuffer.write(': $semanticsCount');
    }
    return Selector<DefaultAssetPickerProvider, PathWrapper<AssetPathEntity>?>(
      selector: (_, DefaultAssetPickerProvider p) => p.currentPath,
      builder: (_, PathWrapper<AssetPathEntity>? currentWrapper, __) {
        final bool isSelected = currentWrapper?.path == pathEntity;
        return Semantics(
          label: labelBuffer.toString(),
          selected: isSelected,
          onTapHint: semanticsTextDelegate.sActionSwitchPathLabel,
          button: false,
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              splashFactory: InkSplash.splashFactory,
              onTap: () {
                Feedback.forTap(context);
                context.read<DefaultAssetPickerProvider>().switchPath(wrapper);
                isSwitchingPath.value = false;
                gridScrollController.jumpTo(0);
              },
              child: SizedBox(
                height: isAppleOS(context) ? 64 : 52,
                child: Row(
                  children: <Widget>[
                    RepaintBoundary(
                      child: AspectRatio(aspectRatio: 1, child: builder()),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsetsDirectional.only(
                          start: 15,
                          end: 20,
                        ),
                        child: ExcludeSemantics(
                          child: ScaleText.rich(
                            [
                              TextSpan(text: name),
                              if (semanticsCount != null)
                                TextSpan(text: ' ($semanticsCount)'),
                            ],
                            style: const TextStyle(fontSize: 17),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                    if (isSelected)
                      AspectRatio(
                        aspectRatio: 1,
                        child: Icon(Icons.check, color: themeColor, size: 26),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget previewButton(BuildContext context) {
    return Consumer<DefaultAssetPickerProvider>(
      builder: (_, DefaultAssetPickerProvider p, Widget? child) {
        return ValueListenableBuilder<bool>(
          valueListenable: isSwitchingPath,
          builder: (_, bool isSwitchingPath, __) => Semantics(
            enabled: p.isSelectedNotEmpty,
            focusable: !isSwitchingPath,
            hidden: isSwitchingPath,
            onTapHint: semanticsTextDelegate.sActionPreviewHint,
            child: child,
          ),
        );
      },
      child: Consumer<DefaultAssetPickerProvider>(
        builder: (context, DefaultAssetPickerProvider p, __) => GestureDetector(
          onTap: p.isSelectedNotEmpty
              ? () {
                  viewAsset(context, null, p.selectedAssets.first);
                }
              : null,
          child: Selector<DefaultAssetPickerProvider, String>(
            selector: (_, DefaultAssetPickerProvider p) =>
                p.selectedDescriptions,
            builder: (BuildContext c, __, ___) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: ScaleText(
                '${textDelegate.preview}'
                '${p.isSelectedNotEmpty ? ' (${p.selectedAssets.length})' : ''}',
                style: TextStyle(
                  color: p.isSelectedNotEmpty
                      ? null
                      : c.textTheme.bodySmall?.color,
                  fontSize: 17,
                ),
                maxScaleFactor: 1.2,
                semanticsLabel: '${semanticsTextDelegate.preview}'
                    '${p.isSelectedNotEmpty ? ' (${p.selectedAssets.length})' : ''}',
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget itemBannedIndicator(BuildContext context, AssetEntity asset) {
    return Consumer<DefaultAssetPickerProvider>(
      builder: (_, DefaultAssetPickerProvider p, __) {
        final bool isDisabled =
            (!p.selectedAssets.contains(asset) && p.selectedMaximumAssets) ||
                (isWeChatMoment &&
                    asset.type == AssetType.video &&
                    p.selectedAssets.isNotEmpty);
        if (isDisabled) {
          return Container(
            color: theme.colorScheme.surface.withOpacity(.85),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  @override
  Widget selectIndicator(BuildContext context, int index, AssetEntity asset) {
    final double indicatorSize =
        MediaQuery.sizeOf(context).width / gridCount / 3;
    final Duration duration = switchingPathDuration * 0.75;
    return Selector<DefaultAssetPickerProvider, String>(
      selector: (_, DefaultAssetPickerProvider p) => p.selectedDescriptions,
      builder: (BuildContext context, String descriptions, __) {
        final bool selected = descriptions.contains(asset.toString());
        final Widget innerSelector = AnimatedContainer(
          duration: duration,
          width: indicatorSize / (isAppleOS(context) ? 1.25 : 1.5),
          height: indicatorSize / (isAppleOS(context) ? 1.25 : 1.5),
          padding: EdgeInsets.all(indicatorSize / 10),
          decoration: BoxDecoration(
            border: !selected
                ? Border.all(
                    color: context.theme.unselectedWidgetColor,
                    width: indicatorSize / 25,
                  )
                : null,
            color: selected ? themeColor : null,
            shape: BoxShape.circle,
          ),
          child: FittedBox(
            child: AnimatedSwitcher(
              duration: duration,
              reverseDuration: duration,
              child:
                  selected ? const Icon(Icons.check) : const SizedBox.shrink(),
            ),
          ),
        );
        final Widget selectorWidget = GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            selectAsset(context, asset, index, selected);
          },
          child: Container(
            margin: EdgeInsets.all(indicatorSize / 4),
            width: isPreviewEnabled ? indicatorSize : null,
            height: isPreviewEnabled ? indicatorSize : null,
            alignment: AlignmentDirectional.topEnd,
            child: (!isPreviewEnabled && isSingleAssetMode && !selected)
                ? const SizedBox.shrink()
                : innerSelector,
          ),
        );
        if (isPreviewEnabled) {
          return PositionedDirectional(
            top: 0,
            end: 0,
            child: selectorWidget,
          );
        }
        return selectorWidget;
      },
    );
  }

  @override
  Widget selectedBackdrop(BuildContext context, int index, AssetEntity asset) {
    final double indicatorSize =
        MediaQuery.sizeOf(context).width / gridCount / 3;
    return Positioned.fill(
      child: GestureDetector(
        onTap: isPreviewEnabled
            ? () {
                viewAsset(context, index, asset);
              }
            : null,
        child: Consumer<DefaultAssetPickerProvider>(
          builder: (_, DefaultAssetPickerProvider p, __) {
            final int index = p.selectedAssets.indexOf(asset);
            final bool selected = index != -1;
            return AnimatedContainer(
              duration: switchingPathDuration,
              padding: EdgeInsets.all(indicatorSize * .35),
              color: selected
                  ? theme.colorScheme.primary.withOpacity(.45)
                  : theme.colorScheme.surface.withOpacity(.1),
              child: selected && !isSingleAssetMode
                  ? Align(
                      alignment: AlignmentDirectional.topStart,
                      child: SizedBox(
                        height: indicatorSize / 2.5,
                        child: FittedBox(
                          alignment: AlignmentDirectional.topStart,
                          fit: BoxFit.cover,
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              color: theme.textTheme.bodyLarge?.color
                                  ?.withOpacity(.75),
                              fontWeight: FontWeight.w600,
                              height: 1,
                            ),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            );
          },
        ),
      ),
    );
  }

  /// Videos often contains various of color in the cover,
  /// so in order to keep the content visible in most cases,
  /// the color of the indicator has been set to [Colors.white].
  ///
  /// 视频封面通常包含各种颜色，为了保证内容在一般情况下可见，此处
  /// 将指示器的图标和文字设置为 [Colors.white]。
  @override
  Widget videoIndicator(BuildContext context, AssetEntity asset) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.maxFinite,
        height: 26,
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: AlignmentDirectional.bottomCenter,
            end: AlignmentDirectional.topCenter,
            colors: <Color>[theme.splashColor, Colors.transparent],
          ),
        ),
        child: Row(
          children: <Widget>[
            const Icon(Icons.videocam, size: 22, color: Colors.white),
            Expanded(
              child: Padding(
                padding: const EdgeInsetsDirectional.only(start: 4),
                child: ScaleText(
                  textDelegate.durationIndicatorBuilder(
                    Duration(seconds: asset.duration),
                  ),
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                  strutStyle: const StrutStyle(
                    forceStrutHeight: true,
                    height: 1.4,
                  ),
                  maxLines: 1,
                  maxScaleFactor: 1.2,
                  semanticsLabel:
                      semanticsTextDelegate.durationIndicatorBuilder(
                    Duration(seconds: asset.duration),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget accessLimitedBottomTip(BuildContext context) {
    final double bottomPadding;
    if (hasBottomActions) {
      bottomPadding = 0;
    } else {
      bottomPadding = MediaQuery.paddingOf(context).bottom;
    }
    return GestureDetector(
      onTap: () {
        Feedback.forTap(context);
        PhotoManager.openSetting();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10)
            .add(EdgeInsets.only(bottom: bottomPadding)),
        height: permissionLimitedBarHeight + bottomPadding,
        color: theme.primaryColor.withOpacity(isAppleOS(context) ? 0.90 : 1),
        child: Row(
          children: <Widget>[
            const SizedBox(width: 5),
            Icon(
              Icons.warning,
              color: Colors.orange[400]!.withOpacity(.8),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: ScaleText(
                textDelegate.accessAllTip,
                style: context.textTheme.bodySmall?.copyWith(
                  fontSize: 14,
                ),
                semanticsLabel: semanticsTextDelegate.accessAllTip,
              ),
            ),
            Icon(
              Icons.keyboard_arrow_right,
              color: context.iconTheme.color?.withOpacity(.5),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget bottomActionBar(BuildContext context) {
    final children = <Widget>[
      if (isPermissionLimited) accessLimitedBottomTip(context),
      if (hasBottomActions)
        Container(
          height: bottomActionBarHeight + context.bottomPadding,
          padding: const EdgeInsets.symmetric(horizontal: 20).copyWith(
            bottom: context.bottomPadding,
          ),
          color: theme.bottomAppBarTheme.color?.withOpacity(
            theme.bottomAppBarTheme.color!.opacity *
                (isAppleOS(context) ? .9 : 1),
          ),
          child: Row(
            children: <Widget>[
              if (isPreviewEnabled) previewButton(context),
              if (isPreviewEnabled || !isSingleAssetMode) const Spacer(),
              if (isPreviewEnabled || !isSingleAssetMode)
                confirmButton(context),
            ],
          ),
        ),
    ];
    if (children.isEmpty) {
      return const SizedBox.shrink();
    }
    Widget child = Column(
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
    if (isAppleOS(context)) {
      child = ClipRect(
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(
            sigmaX: appleOSBlurRadius,
            sigmaY: appleOSBlurRadius,
          ),
          child: child,
        ),
      );
    }
    return child;
  }

  @override
  Widget build(BuildContext context) {
    // Schedule the scroll position's restoration callback if this feature
    // is enabled and offsets are different.
    if (keepScrollOffset && Singleton.scrollPosition != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Update only if the controller has clients.
        if (gridScrollController.hasClients) {
          gridScrollController.jumpTo(Singleton.scrollPosition!.pixels);
        }
      });
    }
    return Theme(
      data: theme,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: overlayStyle,
        child: CNP<DefaultAssetPickerProvider>.value(
          value: provider,
          builder: (BuildContext context, _) => Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            body: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                if (isAppleOS(context))
                  appleOSLayout(context)
                else
                  androidLayout(context),
                permissionOverlay(context),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
