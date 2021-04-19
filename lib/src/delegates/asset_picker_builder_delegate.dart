///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2020-10-29 21:50
///
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:extended_image/extended_image.dart';

import '../constants/constants.dart';

typedef IndicatorBuilder = Widget Function(
  BuildContext context,
  bool isAssetsEmpty,
);

/// The delegate to build the whole picker's components.
///
/// By extending the delegate, you can customize every components on you own.
/// Delegate requires two generic types:
///  * [A] "Asset": The type of your assets. Defaults to [AssetEntity].
///  * [P] "Path": The type of your paths. Defaults to [AssetPathEntity].
abstract class AssetPickerBuilderDelegate<A, P> {
  AssetPickerBuilderDelegate({
    required this.provider,
    this.gridCount = 4,
    Color? themeColor,
    AssetsPickerTextDelegate? textDelegate,
    this.pickerTheme,
    this.specialItemPosition = SpecialItemPosition.none,
    this.specialItemBuilder,
    this.loadingIndicatorBuilder,
    this.allowSpecialItemWhenEmpty = false,
  })  : assert(
          pickerTheme == null || themeColor == null,
          'Theme and theme color cannot be set at the same time.',
        ),
        themeColor =
            pickerTheme?.colorScheme.secondary ?? themeColor ?? C.themeColor {
    Constants.textDelegate = textDelegate ?? DefaultAssetsPickerTextDelegate();
  }

  /// [ChangeNotifier] for asset picker.
  /// 资源选择器状态保持
  final AssetPickerProvider<A, P> provider;

  /// Assets count for the picker.
  /// 资源网格数
  final int gridCount;

  /// Main color for the picker.
  /// 选择器的主题色
  final Color themeColor;

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
  /// 允许用户在选择器中添加一个自定义item，并指定位置
  final SpecialItemPosition specialItemPosition;

  /// The widget builder for the the special item.
  /// 自定义item的构造方法
  final WidgetBuilder? specialItemBuilder;

  /// Indicates the loading status for the builder.
  /// 指示目前加载的状态
  final IndicatorBuilder? loadingIndicatorBuilder;

  /// Whether the special item will display or not when assets is empty.
  /// 当没有资源时是否显示自定义item
  final bool allowSpecialItemWhenEmpty;

  /// The [ScrollController] for the preview grid.
  final ScrollController gridScrollController = ScrollController();

  /// [ThemeData] for the picker.
  /// 选择器使用的主题
  ThemeData get theme => pickerTheme ?? AssetPicker.themeData(themeColor);

  /// Return a system ui overlay style according to
  /// the brightness of the theme data.
  /// 根据主题返回状态栏的明暗样式
  SystemUiOverlayStyle get overlayStyle => theme.brightness == Brightness.light
      ? SystemUiOverlayStyle.dark
      : SystemUiOverlayStyle.light;

  /// Whether the current platform is Apple OS.
  /// 当前平台是否苹果系列系统 (iOS & MacOS)
  bool get isAppleOS => Platform.isIOS || Platform.isMacOS;

  /// Whether the picker is under the single asset mode.
  /// 选择器是否为单选模式
  bool get isSingleAssetMode => provider.maxAssets == 1;

  /// Space between assets item widget.
  /// 资源部件之间的间隔
  double get itemSpacing => 2.0;

  /// Item's height in app bar.
  /// 顶栏内各个组件的统一高度
  double get appBarItemHeight => 32.0;

  /// Blur radius in Apple OS layout mode.
  /// 苹果系列系统布局方式下的模糊度
  double get appleOSBlurRadius => 15.0;

  /// Height for bottom action bar.
  /// 底部操作栏的高度
  double get bottomActionBarHeight => kToolbarHeight / 1.1;

  /// Path entity select widget builder.
  /// 路径选择部件构建
  Widget pathEntitySelector(BuildContext context);

  /// Item widgets for path entity selector.
  /// 路径单独条目选择组件
  Widget pathEntityWidget({
    required BuildContext context,
    required Map<P, Uint8List?> list,
    required int index,
    bool isAudio = false,
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

  /// GIF image type indicator.
  /// GIF类型图片指示
  Widget gifIndicator(BuildContext context, A asset) {
    return PositionedDirectional(
      start: 0,
      bottom: 0,
      child: Container(
        padding: const EdgeInsets.all(6.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: AlignmentDirectional.bottomCenter,
            end: AlignmentDirectional.topCenter,
            colors: <Color>[theme.dividerColor, Colors.transparent],
          ),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
          decoration: !isAppleOS
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(2.0),
                  color: theme.iconTheme.color!.withOpacity(0.75),
                )
              : null,
          child: Text(
            Constants.textDelegate.gifIndicator,
            style: TextStyle(
              color: isAppleOS
                  ? theme.textTheme.bodyText2?.color
                  : theme.primaryColor,
              fontSize: isAppleOS ? 14.0 : 12.0,
              fontWeight: isAppleOS ? FontWeight.w500 : FontWeight.normal,
            ),
            strutStyle: const StrutStyle(
              forceStrutHeight: true,
              height: 1.0,
            ),
          ),
        ),
      ),
    );
  }

  /// Audio asset type indicator.
  /// 音频类型资源指示
  Widget audioIndicator(BuildContext context, A asset);

  /// Video asset type indicator.
  /// 视频类型资源指示
  Widget videoIndicator(BuildContext context, A asset);

  /// Animated backdrop widget for items.
  /// 部件选中时的动画遮罩部件
  Widget selectedBackdrop(
    BuildContext context,
    int index,
    A asset,
  );

  /// Indicator for assets selected status.
  /// 资源是否已选的指示器
  Widget selectIndicator(BuildContext context, A asset);

  /// Loading indicator.
  /// 加载指示器
  Widget loadingIndicator(BuildContext context) {
    return Center(
      child: Selector<AssetPickerProvider<A, P>, bool>(
        selector: (_, AssetPickerProvider<A, P> provider) =>
            provider.isAssetsEmpty,
        builder: (BuildContext c, bool isAssetsEmpty, Widget? w) {
          if (loadingIndicatorBuilder != null) {
            return loadingIndicatorBuilder!(c, isAssetsEmpty);
          }
          if (isAssetsEmpty) {
            return const Text('Nothing here.');
          } else {
            return w!;
          }
        },
        child: PlatformProgressIndicator(
          color: theme.iconTheme.color,
          size: Screens.width / gridCount / 3,
        ),
      ),
    );
  }

  /// Item widgets when the thumb data load failed.
  /// 资源缩略数据加载失败时使用的部件
  Widget failedItemBuilder(BuildContext context) {
    return Center(
      child: Text(
        Constants.textDelegate.loadFailed,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 18.0),
      ),
    );
  }

  /// The main grid view builder for assets.
  /// 主要的资源查看网格部件
  Widget assetsGridBuilder(BuildContext context) {
    return ColoredBox(
      color: theme.canvasColor,
      child: Selector<AssetPickerProvider<A, P>, List<A>>(
        selector: (_, AssetPickerProvider<A, P> provider) =>
            provider.currentAssets,
        builder: (_, List<A> currentAssets, __) => GridView.builder(
          controller: gridScrollController,
          padding: isAppleOS
              ? EdgeInsets.only(
                  top: Screens.topSafeHeight + kToolbarHeight,
                  bottom: bottomActionBarHeight,
                )
              : EdgeInsets.zero,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: gridCount,
            mainAxisSpacing: itemSpacing,
            crossAxisSpacing: itemSpacing,
          ),
          itemCount: assetsGridItemCount(_, currentAssets),
          itemBuilder: (BuildContext c, int index) => assetGridItemBuilder(
            c,
            index,
            currentAssets,
          ),
        ),
      ),
    );
  }

  /// The function which return items count for the assets' grid.
  /// 为资源列表提供内容数量计算的方法
  int assetsGridItemCount(BuildContext context, List<A> currentAssets);

  /// The item builder for the assets' grid.
  /// 资源列表项的构建
  Widget assetGridItemBuilder(
    BuildContext context,
    int index,
    List<A> currentAssets,
  );

  /// The item builder for audio type of asset.
  /// 音频资源的部件构建
  Widget audioItemBuilder(
    BuildContext context,
    int index,
    A asset,
  );

  /// The item builder for images and video type of asset.
  /// 图片和视频资源的部件构建
  Widget imageAndVideoItemBuilder(
    BuildContext context,
    int index,
    A asset,
  );

  /// Preview button to preview selected assets.
  /// 预览已选资源的按钮
  Widget previewButton(BuildContext context);

  /// Action bar widget aligned to bottom.
  /// 底部操作栏部件
  Widget bottomActionBar(BuildContext context) {
    Widget child = Container(
      width: Screens.width,
      height: bottomActionBarHeight + Screens.bottomSafeHeight,
      padding: EdgeInsets.only(
        left: 20.0,
        right: 20.0,
        bottom: Screens.bottomSafeHeight,
      ),
      color: theme.primaryColor.withOpacity(isAppleOS ? 0.90 : 1.0),
      child: Row(children: <Widget>[
        if (!isSingleAssetMode || !isAppleOS) previewButton(context),
        if (isAppleOS) const Spacer(),
        if (isAppleOS) confirmButton(context),
      ]),
    );
    if (isAppleOS) {
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
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: () {
        if (isAppleOS) {
          return GestureDetector(
            onTap: Navigator.of(context).maybePop,
            child: Container(
              margin: isAppleOS
                  ? const EdgeInsets.symmetric(horizontal: 20.0)
                  : null,
              child: IntrinsicWidth(
                child: Center(
                  child: Text(
                    Constants.textDelegate.cancel,
                    style: const TextStyle(fontSize: 18.0),
                  ),
                ),
              ),
            ),
          );
        } else {
          return IconButton(
            onPressed: Navigator.of(context).maybePop,
            icon: const Icon(Icons.close),
          );
        }
      }(),
    );
  }

  /// Custom app bar for the picker.
  /// 选择器自定义的顶栏
  PreferredSizeWidget appBar(BuildContext context);

  /// Layout for Apple OS devices.
  /// 苹果系列设备的选择器布局
  Widget appleOSLayout(BuildContext context);

  /// Layout for Android devices.
  /// Android设备的选择器布局
  Widget androidLayout(BuildContext context);

  /// Yes, the build method.
  /// 没错，是它是它就是它，我们亲爱的 build 方法~
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlayStyle,
      child: Theme(
        data: theme,
        child: ChangeNotifierProvider<AssetPickerProvider<A, P>>.value(
          value: provider,
          child: Material(
            color: theme.canvasColor,
            child: isAppleOS ? appleOSLayout(context) : androidLayout(context),
          ),
        ),
      ),
    );
  }
}

class DefaultAssetPickerBuilderDelegate
    extends AssetPickerBuilderDelegate<AssetEntity, AssetPathEntity> {
  DefaultAssetPickerBuilderDelegate({
    required DefaultAssetPickerProvider provider,
    int gridCount = 4,
    Color? themeColor,
    AssetsPickerTextDelegate? textDelegate,
    ThemeData? pickerTheme,
    SpecialItemPosition specialItemPosition = SpecialItemPosition.none,
    WidgetBuilder? specialItemBuilder,
    IndicatorBuilder? loadingIndicatorBuilder,
    bool allowSpecialItemWhenEmpty = false,
    this.previewThumbSize,
    this.specialPickerType,
  })  : assert(
          pickerTheme == null || themeColor == null,
          'Theme and theme color cannot be set at the same time.',
        ),
        super(
          provider: provider,
          gridCount: gridCount,
          themeColor: themeColor,
          textDelegate: textDelegate,
          pickerTheme: pickerTheme,
          specialItemPosition: specialItemPosition,
          specialItemBuilder: specialItemBuilder,
          loadingIndicatorBuilder: loadingIndicatorBuilder,
          allowSpecialItemWhenEmpty: allowSpecialItemWhenEmpty,
        );

  /// Preview thumbnail size in the viewer.
  /// 预览时图片的缩略图大小
  ///
  /// This only works on images since other types does not have request
  /// for thumb data. The speed of preview can be raised by reducing it.
  ///
  /// 该参数仅生效于图片类型的资源，因为其他资源不需要请求缩略图数据。
  /// 预览图片的速度可以通过适当降低它的数值来提升。
  ///
  /// Default is `null`, which will request the origin data.
  /// 默认为空，即读取原图。
  final List<int>? previewThumbSize;

  /// The current special picker type for the picker.
  /// 当前特殊选择类型
  ///
  /// There're several types which are special:
  /// * [SpecialPickerType.wechatMoment] When user selected video, no more images
  /// can be selected.
  ///
  /// 这里包含一些特殊选择类型：
  /// * [SpecialPickerType.wechatMoment] 微信朋友圈模式。当用户选择了视频，将不能选择图片。
  final SpecialPickerType? specialPickerType;

  /// [Duration] when triggering path switching.
  /// 切换路径时的动画时长
  Duration get switchingPathDuration => kThemeAnimationDuration * 1.5;

  /// [Curve] when triggering path switching.
  /// 切换路径时的动画曲线
  Curve get switchingPathCurve => Curves.easeInOut;

  @override
  Widget androidLayout(BuildContext context) {
    return FixedAppBarWrapper(
      appBar: appBar(context),
      body: Selector<DefaultAssetPickerProvider, bool>(
        selector: (_, DefaultAssetPickerProvider provider) =>
            provider.hasAssetsToDisplay,
        builder: (_, bool hasAssetsToDisplay, __) {
          final bool shouldDisplayAssets = hasAssetsToDisplay ||
              (allowSpecialItemWhenEmpty &&
                  specialItemPosition != SpecialItemPosition.none);
          return AnimatedSwitcher(
            duration: switchingPathDuration,
            child: shouldDisplayAssets
                ? Stack(
                    children: <Widget>[
                      RepaintBoundary(
                        child: Column(
                          children: <Widget>[
                            Expanded(child: assetsGridBuilder(context)),
                            if (!isSingleAssetMode) bottomActionBar(context),
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
  PreferredSizeWidget appBar(BuildContext context) {
    return FixedAppBar(
      backgroundColor: theme.appBarTheme.color,
      centerTitle: isAppleOS,
      title: pathEntitySelector(context),
      leading: backButton(context),
      actions: !isAppleOS ? <Widget>[confirmButton(context)] : null,
      actionsPadding: const EdgeInsets.only(right: 14.0),
      blurRadius: isAppleOS ? appleOSBlurRadius : 0.0,
    );
  }

  @override
  Widget appleOSLayout(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: Selector<DefaultAssetPickerProvider, bool>(
            selector: (_, DefaultAssetPickerProvider p) => p.hasAssetsToDisplay,
            builder: (_, bool hasAssetsToDisplay, __) => AnimatedSwitcher(
              duration: switchingPathDuration,
              child: hasAssetsToDisplay
                  ? Stack(
                      children: <Widget>[
                        RepaintBoundary(
                          child: Stack(
                            children: <Widget>[
                              Positioned.fill(
                                child: assetsGridBuilder(context),
                              ),
                              if (!isSingleAssetMode || isAppleOS)
                                PositionedDirectional(
                                  bottom: 0.0,
                                  child: bottomActionBar(context),
                                ),
                            ],
                          ),
                        ),
                        pathEntityListBackdrop(context),
                        pathEntityListWidget(context),
                      ],
                    )
                  : loadingIndicator(context),
            ),
          ),
        ),
        appBar(context),
      ],
    );
  }

  /// There're several conditions within this builder:
  ///  * Return [specialItemBuilder] while the current path is all and
  ///    [specialItemPosition] is not equal to [SpecialItemPosition.none].
  ///  * Return item builder according to the asset's type.
  ///    * [AssetType.audio] -> [audioItemBuilder]
  ///    * [AssetType.image], [AssetType.video] -> [imageAndVideoItemBuilder]
  ///  * Load more assets when the index reached at third line counting
  ///    backwards.
  ///
  /// 资源构建有几个条件：
  ///  * 当前路径是全部资源且 [specialItemPosition] 不等于
  ///    [SpecialItemPosition.none] 时，将会通过 [specialItemBuilder] 构建内容。
  ///  * 根据资源类型返回对应类型的构建：
  ///    * [AssetType.audio] -> [audioItemBuilder] 音频类型
  ///    * [AssetType.image], [AssetType.video] -> [imageAndVideoItemBuilder]
  ///      图片和视频类型
  ///  * 在索引到达倒数第三列的时候加载更多资源。
  @override
  Widget assetGridItemBuilder(
    BuildContext context,
    int index,
    List<AssetEntity> currentAssets,
  ) {
    final AssetPathEntity? currentPathEntity =
        context.read<DefaultAssetPickerProvider>().currentPathEntity;

    int currentIndex;
    switch (specialItemPosition) {
      case SpecialItemPosition.none:
      case SpecialItemPosition.append:
        currentIndex = index;
        break;
      case SpecialItemPosition.prepend:
        currentIndex = index - 1;
        break;
    }

    // Directly return the special item when it's empty.
    if (currentPathEntity == null) {
      if (allowSpecialItemWhenEmpty &&
          specialItemPosition != SpecialItemPosition.none) {
        return specialItemBuilder!(context);
      }
      return const SizedBox.shrink();
    }

    if (currentPathEntity.isAll &&
        specialItemPosition != SpecialItemPosition.none) {
      if ((index == 0 && specialItemPosition == SpecialItemPosition.prepend) ||
          (index == currentAssets.length &&
              specialItemPosition == SpecialItemPosition.append)) {
        return specialItemBuilder!(context);
      }
    }

    if (!currentPathEntity.isAll) {
      currentIndex = index;
    }

    if (index == currentAssets.length - gridCount * 3 &&
        context.read<DefaultAssetPickerProvider>().hasMoreToLoad) {
      provider.loadMoreAssets();
    }

    final AssetEntity asset = currentAssets.elementAt(currentIndex);
    Widget builder;
    switch (asset.type) {
      case AssetType.audio:
        builder = audioItemBuilder(context, currentIndex, asset);
        break;
      case AssetType.image:
      case AssetType.video:
        builder = imageAndVideoItemBuilder(context, currentIndex, asset);
        break;
      case AssetType.other:
        builder = const SizedBox.shrink();
        break;
    }
    return Stack(
      children: <Widget>[
        builder,
        if (specialPickerType != SpecialPickerType.wechatMoment ||
            asset.type != AssetType.video)
          selectIndicator(context, asset),
      ],
    );
  }

  @override
  int assetsGridItemCount(
    BuildContext context,
    List<AssetEntity> currentAssets,
  ) {
    final AssetPathEntity? currentPathEntity =
        context.read<DefaultAssetPickerProvider>().currentPathEntity;

    if (currentPathEntity == null &&
        specialItemPosition != SpecialItemPosition.none) {
      return 1;
    }

    /// Return actual length if current path is all.
    /// 如果当前目录是全部内容，则返回实际的内容数量。
    if (!currentPathEntity!.isAll) {
      return currentAssets.length;
    }
    int length;
    switch (specialItemPosition) {
      case SpecialItemPosition.none:
        length = currentAssets.length;
        break;
      case SpecialItemPosition.prepend:
      case SpecialItemPosition.append:
        length = currentAssets.length + 1;
        break;
    }
    return length;
  }

  @override
  Widget audioIndicator(BuildContext context, AssetEntity asset) {
    return Container(
      width: double.maxFinite,
      alignment: AlignmentDirectional.bottomStart,
      padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 8.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: AlignmentDirectional.bottomCenter,
          end: AlignmentDirectional.topCenter,
          colors: <Color>[theme.dividerColor, Colors.transparent],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 4.0),
        child: Text(
          Constants.textDelegate.durationIndicatorBuilder(
            Duration(seconds: asset.duration),
          ),
          style: const TextStyle(fontSize: 16.0),
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
          padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 8.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: AlignmentDirectional.topCenter,
              end: AlignmentDirectional.bottomCenter,
              colors: <Color>[theme.dividerColor, Colors.transparent],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 4.0, right: 30.0),
            child: Text(
              asset.title ?? '',
              style: const TextStyle(fontSize: 16.0),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        const Center(child: Icon(Icons.audiotrack)),
        selectedBackdrop(context, index, asset),
        audioIndicator(context, asset),
      ],
    );
  }

  /// It'll pop with [AssetPickerProvider.selectedAssets]
  /// when there're any assets chosen.
  /// 当有资源已选时，点击按钮将把已选资源通过路由返回。
  @override
  Widget confirmButton(BuildContext context) {
    return Consumer<DefaultAssetPickerProvider>(
      builder: (_, DefaultAssetPickerProvider provider, __) {
        return MaterialButton(
          minWidth: provider.isSelectedNotEmpty ? 48.0 : 20.0,
          height: appBarItemHeight,
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          color: provider.isSelectedNotEmpty ? themeColor : theme.dividerColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3.0),
          ),
          child: Text(
            provider.isSelectedNotEmpty && !isSingleAssetMode
                ? '${Constants.textDelegate.confirm}'
                    '(${provider.selectedAssets.length}/${provider.maxAssets})'
                : Constants.textDelegate.confirm,
            style: TextStyle(
              color: provider.isSelectedNotEmpty
                  ? theme.textTheme.bodyText1?.color
                  : theme.textTheme.caption?.color,
              fontSize: 17.0,
              fontWeight: FontWeight.normal,
            ),
          ),
          onPressed: () {
            if (provider.isSelectedNotEmpty) {
              Navigator.of(context).pop(provider.selectedAssets);
            }
          },
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
    final AssetEntityImageProvider imageProvider =
        AssetEntityImageProvider(asset, isOriginal: false);
    return RepaintBoundary(
      child: ExtendedImage(
        image: imageProvider,
        fit: BoxFit.cover,
        loadStateChanged: (ExtendedImageState state) {
          Widget loader = const SizedBox.shrink();
          switch (state.extendedImageLoadState) {
            case LoadState.loading:
              loader = const ColoredBox(color: Color(0x10ffffff));
              break;
            case LoadState.completed:
              SpecialImageType? type;
              if (imageProvider.imageFileType == ImageFileType.gif) {
                type = SpecialImageType.gif;
              } else if (imageProvider.imageFileType == ImageFileType.heic) {
                type = SpecialImageType.heic;
              }
              final AssetEntity asset = provider.currentAssets.elementAt(index);
              loader = Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Positioned.fill(
                    child: RepaintBoundary(child: state.completedWidget),
                  ),
                  selectedBackdrop(context, index, asset),
                  if (type == SpecialImageType.gif) // 如果为GIF则显示标识
                    gifIndicator(context, asset),
                  if (asset.type == AssetType.video) // 如果为视频则显示标识
                    videoIndicator(context, asset),
                ],
              );
              loader = FadeImageBuilder(child: loader);
              break;
            case LoadState.failed:
              loader = failedItemBuilder(context);
              break;
          }
          return loader;
        },
      ),
    );
  }

  @override
  Widget loadingIndicator(BuildContext context) {
    return Center(
      child: Selector<DefaultAssetPickerProvider, bool>(
        selector: (_, DefaultAssetPickerProvider p) => p.isAssetsEmpty,
        builder: (_, bool isAssetsEmpty, __) {
          if (isAssetsEmpty) {
            return const Text('Nothing here.');
          } else {
            return PlatformProgressIndicator(
              color: theme.iconTheme.color,
              size: Screens.width / gridCount / 3,
            );
          }
        },
      ),
    );
  }

  /// While the picker is switching path, this will displayed.
  /// If the user tapped on it, it'll collapse the list widget.
  ///
  /// 当选择器正在选择路径时，它会出现。用户点击它时，列表会折叠收起。
  @override
  Widget pathEntityListBackdrop(BuildContext context) {
    return Selector<DefaultAssetPickerProvider, bool>(
      selector: (_, DefaultAssetPickerProvider p) => p.isSwitchingPath,
      builder: (BuildContext context, bool isSwitchingPath, __) {
        return IgnorePointer(
          ignoring: !isSwitchingPath,
          child: GestureDetector(
            onTap: () {
              context.read<DefaultAssetPickerProvider>().isSwitchingPath =
                  false;
            },
            child: AnimatedOpacity(
              duration: switchingPathDuration,
              opacity: isSwitchingPath ? 1.0 : 0.0,
              child: Container(color: Colors.black.withOpacity(0.75)),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget pathEntityListWidget(BuildContext context) {
    final double appBarHeight = kToolbarHeight + Screens.topSafeHeight;
    final double maxHeight = Screens.height * 0.825;
    final bool isAudio =
        context.read<DefaultAssetPickerProvider>().requestType ==
            RequestType.audio;
    return Selector<DefaultAssetPickerProvider, bool>(
      selector: (_, DefaultAssetPickerProvider p) => p.isSwitchingPath,
      builder: (_, bool isSwitchingPath, Widget? w) => AnimatedPositioned(
        duration: switchingPathDuration,
        curve: switchingPathCurve,
        top: isAppleOS
            ? !isSwitchingPath
                ? -maxHeight
                : appBarHeight
            : -(!isSwitchingPath ? maxHeight : 1.0),
        child: AnimatedOpacity(
          duration: switchingPathDuration,
          curve: switchingPathCurve,
          opacity: !isAppleOS || isSwitchingPath ? 1.0 : 0.0,
          child: Container(
            width: Screens.width,
            height: maxHeight,
            decoration: BoxDecoration(
              borderRadius: isAppleOS
                  ? const BorderRadius.vertical(bottom: Radius.circular(10.0))
                  : null,
              color: theme.colorScheme.background,
            ),
            child: w,
          ),
        ),
      ),
      child: Selector<DefaultAssetPickerProvider, int>(
        selector: (_, DefaultAssetPickerProvider p) => p.validPathThumbCount,
        builder: (BuildContext c, int count, __) {
          final Map<AssetPathEntity, Uint8List?> list =
              c.watch<DefaultAssetPickerProvider>().pathEntityList;
          return ListView.separated(
            padding: const EdgeInsets.only(top: 1.0),
            itemCount: list.length,
            itemBuilder: (_, int index) => pathEntityWidget(
              context: c,
              list: list,
              index: index,
              isAudio: isAudio,
            ),
            separatorBuilder: (BuildContext _, int __) => Container(
              margin: const EdgeInsets.only(left: 60.0),
              height: 1.0,
              color: theme.canvasColor,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget pathEntitySelector(BuildContext context) {
    return UnconstrainedBox(
      child: GestureDetector(
        onTap: () => provider.isSwitchingPath = !provider.isSwitchingPath,
        child: Container(
          height: appBarItemHeight,
          constraints: BoxConstraints(maxWidth: Screens.width * 0.5),
          padding: const EdgeInsets.only(left: 12.0, right: 6.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            color: theme.dividerColor,
          ),
          child: Selector<DefaultAssetPickerProvider, AssetPathEntity?>(
            selector: (_, DefaultAssetPickerProvider p) => p.currentPathEntity,
            builder: (_, AssetPathEntity? p, Widget? w) => Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (p != null)
                  Flexible(
                    child: Text(
                      p.name,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.normal,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                w!,
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.iconTheme.color!.withOpacity(0.5),
                ),
                child: Selector<DefaultAssetPickerProvider, bool>(
                  selector: (_, DefaultAssetPickerProvider p) =>
                      p.isSwitchingPath,
                  builder: (_, bool isSwitchingPath, Widget? w) =>
                      Transform.rotate(
                    angle: isSwitchingPath ? math.pi : 0.0,
                    alignment: Alignment.center,
                    child: w,
                  ),
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    size: 20.0,
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
    required Map<AssetPathEntity, Uint8List?> list,
    required int index,
    bool isAudio = false,
  }) {
    final AssetPathEntity pathEntity = list.keys.elementAt(index);
    final Uint8List? data = list.values.elementAt(index);

    Widget builder() {
      if (isAudio) {
        return ColoredBox(
          color: theme.colorScheme.primary.withOpacity(0.12),
          child: const Center(child: Icon(Icons.audiotrack)),
        );
      }

      // The reason that the `thumbData` should be checked at here to see if it
      // is null is that even the image file is not exist, the `File` can still
      // returned as it exist, which will cause the thumb bytes return null.
      //
      // 此处需要检查缩略图为空的原因是：尽管文件可能已经被删除，
      // 但通过 `File` 读取的文件对象仍然存在，使得返回的数据为空。
      if (data != null) {
        return Image.memory(data, fit: BoxFit.cover);
      } else {
        return ColoredBox(
          color: theme.colorScheme.primary.withOpacity(0.12),
        );
      }
    }

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        splashFactory: InkSplash.splashFactory,
        onTap: () {
          provider.switchPath(pathEntity);
          gridScrollController.jumpTo(0);
        },
        child: SizedBox(
          height: isAppleOS ? 64.0 : 52.0,
          child: Row(
            children: <Widget>[
              RepaintBoundary(
                child: AspectRatio(aspectRatio: 1.0, child: builder()),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 20.0),
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: Text(
                            pathEntity.name,
                            style: const TextStyle(fontSize: 18.0),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      Text(
                        '(${pathEntity.assetCount})',
                        style: TextStyle(
                          color: theme.textTheme.caption?.color,
                          fontSize: 18.0,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
              Selector<DefaultAssetPickerProvider, AssetPathEntity?>(
                selector: (_, DefaultAssetPickerProvider p) =>
                    p.currentPathEntity,
                builder: (_, AssetPathEntity? currentPathEntity, __) {
                  if (currentPathEntity != pathEntity) {
                    return const SizedBox.shrink();
                  } else {
                    return AspectRatio(
                      aspectRatio: 1.0,
                      child: Icon(Icons.check, color: themeColor, size: 26.0),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget previewButton(BuildContext context) {
    return Selector<DefaultAssetPickerProvider, bool>(
      selector: (_, DefaultAssetPickerProvider p) => p.isSelectedNotEmpty,
      builder: (_, bool isSelectedNotEmpty, __) => GestureDetector(
        onTap: isSelectedNotEmpty
            ? () async {
                final List<AssetEntity>? result =
                    await AssetPickerViewer.pushToViewer(
                  context,
                  currentIndex: 0,
                  previewAssets: provider.selectedAssets,
                  previewThumbSize: previewThumbSize,
                  selectedAssets: provider.selectedAssets,
                  selectorProvider: provider as DefaultAssetPickerProvider,
                  themeData: theme,
                );
                if (result != null) {
                  Navigator.of(context).pop(result);
                }
              }
            : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Selector<DefaultAssetPickerProvider, List<AssetEntity>>(
            selector: (_, DefaultAssetPickerProvider provider) =>
                provider.selectedAssets,
            builder: (_, List<AssetEntity> selectedAssets, __) {
              return Text(
                isSelectedNotEmpty
                    ? '${Constants.textDelegate.preview}'
                        '(${provider.selectedAssets.length})'
                    : Constants.textDelegate.preview,
                style: TextStyle(
                  color: isSelectedNotEmpty
                      ? null
                      : theme.textTheme.caption?.color,
                  fontSize: 18.0,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget selectIndicator(BuildContext context, AssetEntity asset) {
    return Selector<DefaultAssetPickerProvider, String>(
      selector: (_, DefaultAssetPickerProvider p) => p.selectedDescriptions,
      builder: (BuildContext context, _, __) {
        final List<AssetEntity> selectedAssets =
            context.select<DefaultAssetPickerProvider, List<AssetEntity>>(
          (DefaultAssetPickerProvider p) => p.selectedAssets,
        );
        final bool selected = selectedAssets.contains(asset);
        final double indicatorSize = Screens.width / gridCount / 3;
        return Positioned(
          top: 0.0,
          right: 0.0,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              if (selected) {
                provider.unSelectAsset(asset);
              } else {
                if (isSingleAssetMode) {
                  provider.selectedAssets.clear();
                }
                provider.selectAsset(asset);
              }
            },
            child: Container(
              margin: EdgeInsets.all(
                Screens.width / gridCount / (isAppleOS ? 12.0 : 15.0),
              ),
              width: indicatorSize,
              height: indicatorSize,
              alignment: AlignmentDirectional.topEnd,
              child: AnimatedContainer(
                duration: switchingPathDuration,
                width: indicatorSize / (isAppleOS ? 1.25 : 1.5),
                height: indicatorSize / (isAppleOS ? 1.25 : 1.5),
                decoration: BoxDecoration(
                  border: !selected
                      ? Border.all(color: Colors.white, width: 2.0)
                      : null,
                  color: selected ? themeColor : null,
                  shape: BoxShape.circle,
                ),
                child: AnimatedSwitcher(
                  duration: switchingPathDuration,
                  reverseDuration: switchingPathDuration,
                  child: selected
                      ? isSingleAssetMode
                          ? const Icon(Icons.check, size: 18.0)
                          : Text(
                              '${selectedAssets.indexOf(asset) + 1}',
                              style: TextStyle(
                                color: selected
                                    ? theme.textTheme.bodyText1?.color
                                    : null,
                                fontSize: isAppleOS ? 16.0 : 14.0,
                                fontWeight: isAppleOS
                                    ? FontWeight.w600
                                    : FontWeight.bold,
                              ),
                            )
                      : const SizedBox.shrink(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget selectedBackdrop(BuildContext context, int index, AssetEntity asset) {
    return Positioned.fill(
      child: GestureDetector(
        onTap: () async {
          // While the special type is WeChat moment, picture and video cannot
          // be selected at the same time. Video select should be banned if any
          // picture is selected.
          if (specialPickerType == SpecialPickerType.wechatMoment &&
              asset.type == AssetType.video &&
              provider.selectedAssets.isNotEmpty) {
            return;
          }
          final List<AssetEntity>? result =
              await AssetPickerViewer.pushToViewer(
            context,
            currentIndex: index,
            previewAssets: provider.currentAssets,
            themeData: theme,
            previewThumbSize: previewThumbSize,
            selectedAssets: provider.selectedAssets,
            selectorProvider: provider as DefaultAssetPickerProvider,
            specialPickerType:
                asset.type == AssetType.video ? specialPickerType : null,
          );
          if (result != null) {
            Navigator.of(context).pop(result);
          }
        },
        child: Selector<DefaultAssetPickerProvider, List<AssetEntity>>(
          selector: (_, DefaultAssetPickerProvider p) => p.selectedAssets,
          builder: (_, List<AssetEntity> selectedAssets, __) {
            final bool selected = selectedAssets.contains(asset);
            return AnimatedContainer(
              duration: switchingPathDuration,
              color: selected
                  ? theme.colorScheme.primary.withOpacity(0.45)
                  : Colors.black.withOpacity(0.1),
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
    return PositionedDirectional(
      start: 0,
      bottom: 0,
      child: Container(
        width: double.maxFinite,
        height: 26.0,
        padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: AlignmentDirectional.bottomCenter,
            end: AlignmentDirectional.topCenter,
            colors: <Color>[theme.dividerColor, Colors.transparent],
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Icon(Icons.videocam, size: 24.0, color: Colors.white),
            Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: Text(
                Constants.textDelegate.durationIndicatorBuilder(
                  Duration(seconds: asset.duration),
                ),
                style: const TextStyle(color: Colors.white, fontSize: 16.0),
                strutStyle: const StrutStyle(
                  forceStrutHeight: true,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
