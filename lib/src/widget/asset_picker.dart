///
/// [Author] Alex (https://github.com/AlexVincent525)
/// [Date] 2020/3/31 15:39
///
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:extended_image/extended_image.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../constants/constants.dart';
import 'builder/fade_image_builder.dart';
import 'builder/slide_page_transition_builder.dart';
import 'fixed_appbar.dart';

class AssetPicker extends StatelessWidget {
  AssetPicker({
    Key key,
    @required this.provider,
    this.pickerTheme,
    int gridCount = 4,
    Color themeColor,
    TextDelegate textDelegate,
  })  : assert(
          provider != null,
          'AssetPickerProvider must be provided and not null.',
        ),
        assert(
          pickerTheme == null || themeColor == null,
          'Theme and theme color cannot be set at the same time.',
        ),
        gridCount = gridCount ?? 4,
        themeColor =
            pickerTheme?.colorScheme?.secondary ?? themeColor ?? C.themeColor,
        super(key: key) {
    Constants.textDelegate = textDelegate ?? DefaultTextDelegate();
  }

  /// [ChangeNotifier] for asset picker.
  /// 资源选择器状态保持
  final AssetPickerProvider provider;

  /// Assets count for picker.
  /// 资源网格数
  final int gridCount;

  /// Main color for picker.
  /// 选择器的主题色
  final Color themeColor;

  /// Theme for the picker.
  /// 选择器的主题
  ///
  /// Usually the WeChat uses the dark version (dark background color) for the picker,
  /// but some developer wants a light theme version for some reasons.
  /// 通常情况下微信选择器使用的是暗色（暗色背景）的主题，但某些情况下开发者需要亮色或自定义主题。
  final ThemeData pickerTheme;

  /// Static method to push with navigator.
  /// 跳转至选择器的静态方法
  static Future<List<AssetEntity>> pickAssets(
    BuildContext context, {
    Key key,
    int maxAssets = 9,
    int pageSize = 320,
    int pathThumbSize = 200,
    int gridCount = 4,
    RequestType requestType = RequestType.image,
    List<AssetEntity> selectedAssets,
    Color themeColor,
    ThemeData pickerTheme,
    SortPathDelegate sortPathDelegate,
    TextDelegate textDelegate,
    Curve routeCurve = Curves.easeIn,
    Duration routeDuration = const Duration(milliseconds: 300),
  }) async {
    if (maxAssets == null || maxAssets < 1) {
      throw ArgumentError('maxAssets must be greater than 1.');
    }
    if (pageSize != null && pageSize % gridCount != 0) {
      throw ArgumentError('pageSize must be a multiple of gridCount.');
    }
    if (pickerTheme != null && themeColor != null) {
      throw ArgumentError(
          'Theme and theme color cannot be set at the same time.');
    }
    try {
      final bool isPermissionGranted = await PhotoManager.requestPermission();
      if (isPermissionGranted) {
        final AssetPickerProvider provider = AssetPickerProvider(
          maxAssets: maxAssets,
          pageSize: pageSize,
          pathThumbSize: pathThumbSize,
          selectedAssets: selectedAssets,
          requestType: requestType,
          sortPathDelegate: sortPathDelegate,
          routeDuration: routeDuration,
        );
        final Widget picker = AssetPicker(
          key: key,
          provider: provider,
          gridCount: gridCount,
          textDelegate: textDelegate,
          themeColor: themeColor,
          pickerTheme: pickerTheme,
        );
        final List<AssetEntity> result = await Navigator.of(
          context,
          rootNavigator: true,
        ).push<List<AssetEntity>>(
          SlidePageTransitionBuilder<List<AssetEntity>>(
            builder: picker,
            transitionCurve: routeCurve,
            transitionDuration: routeDuration,
          ),
        );
        return result;
      } else {
        return null;
      }
    } catch (e) {
      realDebugPrint('Error when calling assets picker: $e');
      return null;
    }
  }

  /// Register observe callback with assets changes.
  /// 注册资源（图库）变化的监听回调
  static void registerObserve([ValueChanged<MethodCall> callback]) {
    try {
      PhotoManager.addChangeCallback(callback);
      PhotoManager.startChangeNotify();
    } catch (e) {
      realDebugPrint('Error when registering assets callback: $e');
    }
  }

  /// Unregister observe callback with assets changes.
  /// 取消注册资源（图库）变化的监听回调
  static void unregisterObserve([ValueChanged<MethodCall> callback]) {
    try {
      PhotoManager.removeChangeCallback(callback);
      PhotoManager.stopChangeNotify();
    } catch (e) {
      realDebugPrint('Error when unregistering assets callback: $e');
    }
  }

  /// Whether the current platform is Apple OS.
  /// 当前平台是否苹果系列系统 (iOS & MacOS)
  bool get isAppleOS => Platform.isIOS || Platform.isMacOS;

  /// Whether the picker is under the single asset mode.
  /// 选择器是否为单选模式
  bool get isSingleAssetMode => provider.maxAssets == 1;

  /// Space between asset item widget.
  /// 资源部件之间的间隔
  double get itemSpacing => 2.0;

  /// Item's height in app bar.
  /// 顶栏内各个组件的统一高度
  double get appBarItemHeight => 32.0;

  /// Height for bottom action bar.
  /// 底部操作栏的高度
  double get bottomActionBarHeight => kToolbarHeight / 1.1;

  /// Blur radius in Apple OS layout mode.
  /// 苹果系列系统布局方式下的模糊度
  double get appleOSBlurRadius => 15.0;

  /// [Curve] when triggering path switching.
  /// 切换路径时的动画曲线
  Curve get switchingPathCurve => Curves.easeInOut;

  /// [Duration] when triggering path switching.
  /// 切换路径时的动画时长
  Duration get switchingPathDuration => kThemeAnimationDuration * 1.5;

  /// Build a dark theme according to the theme color.
  /// 通过主题色构建一个默认的暗黑主题
  static ThemeData themeData(Color themeColor) => ThemeData.dark().copyWith(
        buttonColor: themeColor,
        brightness: Brightness.dark,
        primaryColor: Colors.grey[900],
        primaryColorBrightness: Brightness.dark,
        primaryColorLight: Colors.grey[900],
        primaryColorDark: Colors.grey[900],
        accentColor: themeColor,
        accentColorBrightness: Brightness.dark,
        canvasColor: Colors.grey[850],
        scaffoldBackgroundColor: Colors.grey[900],
        bottomAppBarColor: Colors.grey[900],
        cardColor: Colors.grey[900],
        highlightColor: Colors.transparent,
        toggleableActiveColor: themeColor,
        cursorColor: themeColor,
        textSelectionColor: themeColor.withAlpha(100),
        textSelectionHandleColor: themeColor,
        indicatorColor: themeColor,
        appBarTheme: const AppBarTheme(
          brightness: Brightness.dark,
          elevation: 0,
        ),
        colorScheme: ColorScheme(
          primary: Colors.grey[900],
          primaryVariant: Colors.grey[900],
          secondary: themeColor,
          secondaryVariant: themeColor,
          background: Colors.grey[900],
          surface: Colors.grey[900],
          brightness: Brightness.dark,
          error: const Color(0xffcf6679),
          onPrimary: Colors.black,
          onSecondary: Colors.black,
          onSurface: Colors.white,
          onBackground: Colors.white,
          onError: Colors.black,
        ),
      );

  /// [ThemeData] for picker.
  /// 选择器使用的主题
  ThemeData get theme => pickerTheme ?? themeData(themeColor);

  /// Return a system ui overlay style according to
  /// the brightness of the theme data.
  /// 根据主题返回状态栏的明暗样式
  SystemUiOverlayStyle get overlayStyle => theme.brightness == Brightness.light
      ? SystemUiOverlayStyle.dark
      : SystemUiOverlayStyle.light;

  /// Path entity select widget.
  /// 路径选择部件
  Widget get pathEntitySelector => UnconstrainedBox(
        child: Consumer<AssetPickerProvider>(
          builder: (BuildContext _, AssetPickerProvider provider, Widget __) {
            return GestureDetector(
              onTap: () {
                provider.isSwitchingPath = !provider.isSwitchingPath;
              },
              child: Container(
                height: appBarItemHeight,
                constraints: BoxConstraints(maxWidth: Screens.width * 0.5),
                padding: const EdgeInsets.only(left: 12.0, right: 6.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  color: theme.dividerColor,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    if (provider.currentPathEntity != null)
                      Flexible(
                        child: Text(
                          provider.currentPathEntity.name ?? '',
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.normal,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: theme.iconTheme.color.withOpacity(0.5),
                        ),
                        child: Transform.rotate(
                          angle: provider.isSwitchingPath ? math.pi : 0.0,
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.keyboard_arrow_down,
                            size: 20.0,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );

  /// Item widget for path entity selector.
  /// 路径单独条目选择组件
  Widget pathEntityWidget(AssetPathEntity pathEntity) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        splashFactory: InkSplash.splashFactory,
        onTap: () => provider.switchPath(pathEntity),
        child: SizedBox(
          height: isAppleOS ? 64.0 : 52.0,
          child: Row(
            children: <Widget>[
              RepaintBoundary(
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: Selector<AssetPickerProvider,
                      Map<AssetPathEntity, Uint8List>>(
                    selector: (BuildContext _, AssetPickerProvider provider) =>
                        provider.pathEntityList,
                    builder: (
                      BuildContext _,
                      Map<AssetPathEntity, Uint8List> pathEntityList,
                      Widget __,
                    ) {
                      if (_.watch<AssetPickerProvider>().requestType ==
                          RequestType.audio) {
                        return ColoredBox(
                          color: theme.colorScheme.primary.withOpacity(0.12),
                          child: const Center(child: Icon(Icons.audiotrack)),
                        );
                      }

                      /// The reason that the `thumbData` should be checked at here to see if it is
                      /// null is that even the image file is not exist, the `File` can still
                      /// returned as it exist, which will cause the thumb bytes return null.
                      /// 此处需要检查缩略图为空的原因是：尽管文件可能已经被删除，但通过`File`读取的文件对象
                      /// 仍然存在，使得返回的数据为空。
                      final Uint8List thumbData = pathEntityList[pathEntity];
                      if (thumbData != null) {
                        return Image.memory(
                          pathEntityList[pathEntity],
                          fit: BoxFit.cover,
                        );
                      } else {
                        return ColoredBox(
                          color: theme.colorScheme.primary.withOpacity(0.12),
                        );
                      }
                    },
                  ),
                ),
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
                            pathEntity.name ?? '',
                            style: const TextStyle(fontSize: 18.0),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      Text(
                        '(${pathEntity.assetCount})',
                        style: TextStyle(
                          color: theme.textTheme.caption.color,
                          fontSize: 18.0,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
              Selector<AssetPickerProvider, AssetPathEntity>(
                selector: (BuildContext _, AssetPickerProvider provider) =>
                    provider.currentPathEntity,
                builder: (
                  BuildContext _,
                  AssetPathEntity currentPathEntity,
                  Widget __,
                ) {
                  if (currentPathEntity == pathEntity) {
                    return AspectRatio(
                      aspectRatio: 1.0,
                      child: Icon(Icons.check, color: themeColor, size: 26.0),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// List widget for path entities.
  /// 路径选择列表组件
  Widget get pathEntityListWidget {
    final double appBarHeight = kToolbarHeight + Screens.topSafeHeight;
    final double maxHeight =
        isAppleOS ? Screens.height - appBarHeight : Screens.height * 0.75;
    return Selector<AssetPickerProvider, bool>(
      selector: (BuildContext _, AssetPickerProvider provider) =>
          provider.isSwitchingPath,
      builder: (BuildContext _, bool isSwitchingPath, Widget __) {
        return AnimatedPositioned(
          duration: switchingPathDuration,
          curve: switchingPathCurve,
          top: isAppleOS
              ? !isSwitchingPath ? -maxHeight : appBarHeight
              : -(!isSwitchingPath ? maxHeight : 1.0),
          child: AnimatedOpacity(
            duration: switchingPathDuration,
            curve: switchingPathCurve,
            opacity: !isAppleOS || isSwitchingPath ? 1.0 : 0.0,
            child: Container(
              width: Screens.width,
              height: maxHeight,
              decoration: BoxDecoration(color: theme.colorScheme.background),
              child: Selector<AssetPickerProvider,
                  Map<AssetPathEntity, Uint8List>>(
                selector: (BuildContext _, AssetPickerProvider provider) =>
                    provider.pathEntityList,
                builder: (
                  BuildContext _,
                  Map<AssetPathEntity, Uint8List> pathEntityList,
                  Widget __,
                ) {
                  return ListView.separated(
                    padding: const EdgeInsets.only(top: 1.0),
                    itemCount: pathEntityList.length,
                    itemBuilder: (BuildContext _, int index) {
                      return pathEntityWidget(
                          pathEntityList.keys.elementAt(index));
                    },
                    separatorBuilder: (BuildContext _, int __) => Container(
                      margin: const EdgeInsets.only(left: 60.0),
                      height: 1.0,
                      color: theme.canvasColor,
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  /// Loading indicator.
  /// 加载指示器
  Widget get loadingIndicator => Center(
        child: Selector<AssetPickerProvider, bool>(
          selector: (BuildContext _, AssetPickerProvider provider) =>
              provider.isAssetsEmpty,
          builder: (BuildContext _, bool isAssetsEmpty, Widget __) {
            if (isAssetsEmpty) {
              return Text(Constants.textDelegate.emptyPlaceHolder);
            } else {
              return PlatformProgressIndicator(
                color: theme.iconTheme.color,
                size: Screens.width / gridCount / 3,
              );
            }
          },
        ),
      );

  /// Indicator when no assets.
  /// 资源为空时的指示器
  Widget get assetsEmptyIndicator => Center(
        child: Selector<AssetPickerProvider, bool>(
          selector: (BuildContext _, AssetPickerProvider provider) =>
              provider.isAssetsEmpty,
          builder: (BuildContext _, bool isAssetsEmpty, Widget __) {
            if (isAssetsEmpty) {
              return Text(Constants.textDelegate.emptyPlaceHolder);
            } else {
              return PlatformProgressIndicator(
                color: theme.iconTheme.color,
                size: Screens.width / gridCount / 3,
              );
            }
          },
        ),
      );

  /// Confirm button.
  /// 确认按钮
  ///
  /// It'll pop with [AssetPickerProvider.selectedAssets] when there're any assets were chosen.
  /// 当有资源已选时，点击按钮将把已选资源通过路由返回。
  Widget confirmButton(BuildContext context) => Consumer<AssetPickerProvider>(
        builder: (BuildContext _, AssetPickerProvider provider, Widget __) {
          return MaterialButton(
            minWidth: provider.isSelectedNotEmpty ? 48.0 : 20.0,
            height: appBarItemHeight,
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            color:
                provider.isSelectedNotEmpty ? themeColor : theme.dividerColor,
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
                    ? theme.textTheme.bodyText1.color
                    : theme.textTheme.caption.color,
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

  /// GIF image type indicator.
  /// GIF类型图片指示
  Widget get gifIndicator => Align(
        alignment: AlignmentDirectional.bottomStart,
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
          child: Align(
            alignment: const FractionalOffset(0.1, 0.1),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 2.0,
                vertical: 2.0,
              ),
              decoration: !isAppleOS
                  ? BoxDecoration(
                      borderRadius: BorderRadius.circular(2.0),
                      color: theme.iconTheme.color.withOpacity(0.75),
                    )
                  : null,
              child: Text(
                Constants.textDelegate.gifIndicator,
                style: TextStyle(
                  color: isAppleOS
                      ? theme.textTheme.bodyText2.color
                      : theme.primaryColor,
                  fontSize: isAppleOS ? 14.0 : 12.0,
                  fontWeight: isAppleOS ? FontWeight.w500 : FontWeight.normal,
                ),
              ),
            ),
          ),
        ),
      );

  /// Audio asset type indicator.
  /// 音频类型资源指示
  Widget audioIndicator(AssetEntity asset) {
    return Align(
      alignment: AlignmentDirectional.bottomStart,
      child: Container(
        width: double.maxFinite,
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
            Constants.textDelegate
                .durationIndicatorBuilder(Duration(seconds: asset.duration)),
            style: const TextStyle(fontSize: 16.0),
          ),
        ),
      ),
    );
  }

  /// Video asset type indicator.
  /// 视频类型资源指示
  ///
  /// Videos often contains various of color in the cover,
  /// so in order to keep the content visible in most cases,
  /// the color of the indicator has been set to [Colors.white].
  /// 视频封面通常包含各种颜色，为了保证内容在一般情况下可见，此处
  /// 将指示器的图标和文字设置为 [Colors.white]。
  Widget videoIndicator(AssetEntity asset) {
    return Align(
      alignment: AlignmentDirectional.bottomStart,
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
          children: <Widget>[
            const Icon(
              Icons.videocam,
              size: 24.0,
              color: Colors.white,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: Text(
                Constants.textDelegate.durationIndicatorBuilder(
                  Duration(seconds: asset.duration),
                ),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Animated backdrop widget for items.
  /// 部件选中时的动画遮罩部件
  Widget _selectedBackdrop(
    BuildContext context,
    int index,
    AssetEntity asset,
  ) {
    return Selector<AssetPickerProvider, List<AssetEntity>>(
      selector: (BuildContext _, AssetPickerProvider provider) =>
          provider.selectedAssets,
      builder: (BuildContext _, List<AssetEntity> selectedAssets, Widget __) {
        final bool selected = selectedAssets.contains(asset);
        return Positioned.fill(
          child: GestureDetector(
            onTap: () {
              AssetPickerViewer.pushToViewer(
                context,
                currentIndex: index,
                assets: provider.currentAssets,
                themeData: theme,
              );
            },
            child: AnimatedContainer(
              duration: switchingPathDuration,
              color: selected
                  ? theme.colorScheme.primary.withOpacity(0.45)
                  : Colors.black.withOpacity(0.1),
            ),
          ), // 点击预览同目录下所有资源
        );
      },
    );
  }

  /// Indicator for assets selected status.
  /// 资源是否已选的指示器
  Widget _selectIndicator(AssetEntity asset) {
    return Selector<AssetPickerProvider, List<AssetEntity>>(
      selector: (BuildContext _, AssetPickerProvider provider) =>
          provider.selectedAssets,
      builder: (BuildContext _, List<AssetEntity> selectedAssets, Widget __) {
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
                  Screens.width / gridCount / (isAppleOS ? 12.0 : 15.0)),
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
                          ? Icon(Icons.check, size: 18.0)
                          : Text(
                              '${selectedAssets.indexOf(asset) + 1}',
                              style: TextStyle(
                                color: selected
                                    ? theme.textTheme.bodyText1.color
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

  /// Item widget when [AssetEntity.thumbData] load failed.
  /// 资源缩略数据加载失败时使用的部件
  Widget get _failedItem => Center(
        child: Text(
          Constants.textDelegate.loadFailed,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18.0),
        ),
      );

  /// [GridView] for assets under [AssetPickerProvider.currentPathEntity].
  /// 正在查看的目录下的资源网格部件
  Widget assetsGrid(BuildContext context) => Container(
        color: theme.canvasColor,
        child: Selector<AssetPickerProvider, List<AssetEntity>>(
          selector: (BuildContext _, AssetPickerProvider provider) =>
              provider.currentAssets,
          builder: (
            BuildContext _,
            List<AssetEntity> currentAssets,
            Widget __,
          ) {
            return GridView.builder(
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
              itemCount: currentAssets.length,
              itemBuilder: (BuildContext _, int index) {
                if (index == currentAssets.length - gridCount * 3 &&
                    _.read<AssetPickerProvider>().hasMoreToLoad) {
                  provider.loadMoreAssets();
                }
                final AssetEntity asset = currentAssets.elementAt(index);
                Widget builder;
                switch (asset.type) {
                  case AssetType.audio:
                    builder = audioItemBuilder(context, index, asset);
                    break;
                  case AssetType.image:
                  case AssetType.video:
                    builder = imageAndVideoItemBuilder(context, index, asset);
                    break;
                  case AssetType.other:
                    builder = const SizedBox.shrink();
                    break;
                }
                return Stack(
                  children: <Widget>[
                    builder,
                    _selectIndicator(asset),
                  ],
                );
              },
            );
          },
        ),
      );

  /// Item builder for audio type of asset.
  /// 音频资源的部件构建
  Widget audioItemBuilder(
    BuildContext context,
    int index,
    AssetEntity asset,
  ) {
    return Stack(
      children: <Widget>[
        Align(
          alignment: AlignmentDirectional.topStart,
          child: Container(
            width: double.maxFinite,
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
                asset.title,
                style: const TextStyle(fontSize: 16.0),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
        const Center(child: Icon(Icons.audiotrack)),
        _selectedBackdrop(context, index, asset),
        audioIndicator(asset),
      ],
    );
  }

  /// Item builder for image and video type of asset.
  /// 图片和视频资源的部件构建
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
          Widget loader;
          switch (state.extendedImageLoadState) {
            case LoadState.loading:
              loader = Container(color: const Color(0x10ffffff));
              break;
            case LoadState.completed:
              SpecialImageType type;
              if (imageProvider.imageFileType == ImageFileType.gif) {
                type = SpecialImageType.gif;
              } else if (imageProvider.imageFileType == ImageFileType.heic) {
                type = SpecialImageType.heic;
              }
              loader = FadeImageBuilder(
                child: () {
                  final AssetEntity asset =
                      provider.currentAssets.elementAt(index);
                  return Selector<AssetPickerProvider, List<AssetEntity>>(
                    selector: (BuildContext _, AssetPickerProvider provider) =>
                        provider.selectedAssets,
                    builder: (
                      BuildContext _,
                      List<AssetEntity> selectedAssets,
                      Widget __,
                    ) {
                      return Stack(
                        children: <Widget>[
                          Positioned.fill(
                            child: RepaintBoundary(
                              child: state.completedWidget,
                            ),
                          ),
                          _selectedBackdrop(context, index, asset),
                          if (type == SpecialImageType.gif) // 如果为GIF则显示标识
                            gifIndicator,
                          if (asset.type == AssetType.video) // 如果为视频则显示标识
                            videoIndicator(asset),
                        ],
                      );
                    },
                  );
                }(),
              );
              break;
            case LoadState.failed:
              loader = _failedItem;
              break;
          }
          return loader;
        },
      ),
    );
  }

  /// Preview button to preview selected assets.
  /// 预览已选资源的按钮
  Widget previewButton(BuildContext context) {
    return Selector<AssetPickerProvider, bool>(
      selector: (BuildContext _, AssetPickerProvider provider) =>
          provider.isSelectedNotEmpty,
      builder: (BuildContext _, bool isSelectedNotEmpty, Widget __) {
        return GestureDetector(
          onTap: isSelectedNotEmpty
              ? () async {
                  final List<AssetEntity> result =
                      await AssetPickerViewer.pushToViewer(
                    context,
                    currentIndex: 0,
                    assets: provider.selectedAssets,
                    selectedAssets: provider.selectedAssets,
                    selectorProvider: provider,
                    themeData: theme,
                  );
                  if (result != null) {
                    Navigator.of(context).pop(result);
                  }
                }
              : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Selector<AssetPickerProvider, List<AssetEntity>>(
              selector: (BuildContext _, AssetPickerProvider provider) =>
                  provider.selectedAssets,
              builder: (
                BuildContext _,
                List<AssetEntity> selectedAssets,
                Widget __,
              ) {
                return Text(
                  isSelectedNotEmpty
                      ? '${Constants.textDelegate.preview}'
                          '(${provider.selectedAssets.length})'
                      : Constants.textDelegate.preview,
                  style: TextStyle(
                    color: isSelectedNotEmpty
                        ? null
                        : theme.textTheme.caption.color,
                    fontSize: 18.0,
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

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
  Widget backButton(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: isAppleOS
            ? GestureDetector(
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
              )
            : IconButton(
                onPressed: Navigator.of(context).maybePop,
                icon: const Icon(Icons.close),
              ),
      );

  /// Custom app bar for the picker.
  /// 选择器自定义的顶栏
  FixedAppBar appBar(BuildContext context) => FixedAppBar(
        backgroundColor: theme.appBarTheme.color,
        centerTitle: isAppleOS,
        title: pathEntitySelector,
        leading: backButton(context),
        actions: !isAppleOS ? <Widget>[confirmButton(context)] : null,
        actionsPadding: const EdgeInsets.only(right: 14.0),
        blurRadius: isAppleOS ? appleOSBlurRadius : 0.0,
      );

  /// Layout for Apple OS devices.
  /// 苹果系列设备的选择器布局
  Widget appleOSLayout(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: Selector<AssetPickerProvider, bool>(
            selector: (BuildContext _, AssetPickerProvider provider) =>
                provider.hasAssetsToDisplay,
            builder: (
              BuildContext _,
              bool hasAssetsToDisplay,
              Widget __,
            ) {
              return AnimatedSwitcher(
                duration: switchingPathDuration,
                child: hasAssetsToDisplay
                    ? Stack(
                        children: <Widget>[
                          RepaintBoundary(
                            child: Stack(
                              children: <Widget>[
                                Positioned.fill(child: assetsGrid(context)),
                                if (!isSingleAssetMode || isAppleOS)
                                  PositionedDirectional(
                                    bottom: 0.0,
                                    child: bottomActionBar(context),
                                  ),
                              ],
                            ),
                          ),
                          pathEntityListWidget,
                        ],
                      )
                    : assetsEmptyIndicator,
              );
            },
          ),
        ),
        appBar(context),
      ],
    );
  }

  /// Layout for Android devices.
  /// Android设备的选择器布局
  Widget androidLayout(BuildContext context) {
    return FixedAppBarWrapper(
      appBar: appBar(context),
      body: Selector<AssetPickerProvider, bool>(
        selector: (BuildContext _, AssetPickerProvider provider) =>
            provider.hasAssetsToDisplay,
        builder: (
          BuildContext _,
          bool hasAssetsToDisplay,
          Widget __,
        ) {
          return AnimatedSwitcher(
            duration: switchingPathDuration,
            child: hasAssetsToDisplay
                ? Stack(
                    children: <Widget>[
                      RepaintBoundary(
                        child: Column(
                          children: <Widget>[
                            Expanded(child: assetsGrid(context)),
                            if (!isSingleAssetMode) bottomActionBar(context),
                          ],
                        ),
                      ),
                      pathEntityListWidget,
                    ],
                  )
                : loadingIndicator,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlayStyle,
      child: Theme(
        data: theme,
        child: ChangeNotifierProvider<AssetPickerProvider>.value(
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
