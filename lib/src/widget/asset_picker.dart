///
/// [Author] Alex (https://github.com/AlexVincent525)
/// [Date] 2020/3/31 15:39
///
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:extended_image/extended_image.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';
import 'package:wechat_assets_picker/src/widget/platform_progress_indicator.dart';

import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_assets_picker/src/constants/constants.dart';
import 'package:wechat_assets_picker/src/widget/fixed_appbar.dart';

class AssetPicker extends StatelessWidget {
  const AssetPicker({
    Key key,
    @required this.provider,
    int gridCount = 4,
    Color themeColor = C.themeColor,
  })  : assert(provider != null, 'AssetPickerProvider must be provided and not null.'),
        gridCount = gridCount ?? 4,
        themeColor = themeColor ?? C.themeColor,
        super(key: key);

  /// [ChangeNotifier] for asset picker.
  /// 资源选择器状态保持
  final AssetPickerProvider provider;

  /// Assets count for picker.
  /// 资源网格数
  final int gridCount;

  /// Main color for picker.
  /// 选择器的主题色
  final Color themeColor;

  /// Static method to push with navigator.
  /// 跳转至选择器的静态方法
  static Future<Set<AssetEntity>> pickAssets(
    BuildContext context,
    AssetPickerProvider provider, {
    int gridCount = 4,
  }) async {
    final WidgetBuilder picker =
        (BuildContext _) => AssetPicker(provider: provider, gridCount: gridCount);
    final Set<AssetEntity> result = await Navigator.of(context).push<Set<AssetEntity>>(
      Platform.isAndroid
          ? MaterialPageRoute<Set<AssetEntity>>(builder: picker)
          : CupertinoPageRoute<Set<AssetEntity>>(builder: picker),
    );
    return result;
  }

  /// Space between asset item widget [_succeedItem].
  /// 资源部件之间的间隔
  double get itemSpacing => 2.0;

  /// [Curve] when triggering path switching.
  /// 切换路径时的动画曲线
  Curve get switchingPathCurve => Curves.easeInOut;

  /// [Duration] when triggering path switching.
  /// 切换路径时的动画时长
  Duration get switchingPathDuration => kThemeAnimationDuration * 1.5;

  /// [ThemeData] for picker.
  /// 选择器使用的主题
  ThemeData get theme => ThemeData.dark().copyWith(
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
        appBarTheme: const AppBarTheme(brightness: Brightness.dark, elevation: 0),
        iconTheme: IconThemeData(color: Colors.grey[350]),
        primaryIconTheme: IconThemeData(color: Colors.grey[350]),
        tabBarTheme: TabBarTheme(
          indicatorSize: TabBarIndicatorSize.tab,
          labelColor: Colors.grey[200],
          unselectedLabelColor: Colors.grey[200],
        ),
        textTheme: TextTheme(
          title: TextStyle(color: Colors.grey[350]),
          body1: TextStyle(color: Colors.grey[350]),
          body2: TextStyle(color: Colors.grey[500]),
          button: TextStyle(color: Colors.grey[350]),
          caption: TextStyle(color: Colors.grey[500]),
          subhead: TextStyle(color: Colors.grey[500]),
          display4: TextStyle(color: Colors.grey[500]),
          display3: TextStyle(color: Colors.grey[500]),
          display2: TextStyle(color: Colors.grey[500]),
          display1: TextStyle(color: Colors.grey[500]),
          headline: TextStyle(color: Colors.grey[350]),
          overline: TextStyle(color: Colors.grey[350]),
        ),
      );

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
                height: 38.0,
                constraints: BoxConstraints(maxWidth: Screens.width * 0.5),
                padding: const EdgeInsets.only(left: 15.0, right: 8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: theme.dividerColor,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    if (provider.currentPathEntity != null)
                      Flexible(
                        child: Text(
                          '${provider.currentPathEntity.name}',
                          style: const TextStyle(fontSize: 18.0),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(left: 6.0),
                      child: Transform.rotate(
                        angle: provider.isSwitchingPath ? math.pi : 0.0,
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.white54,
                          size: 24.0,
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
          height: 80.0,
          child: Row(
            children: <Widget>[
              RepaintBoundary(
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: Selector<AssetPickerProvider, Map<AssetPathEntity, Uint8List>>(
                    selector: (BuildContext _, AssetPickerProvider provider) =>
                        provider.pathEntityList,
                    builder: (BuildContext _, Map<AssetPathEntity, Uint8List> pathEntityList,
                        Widget __) {
                      /// The reason that the `thumbData` should be checked at here to see if it is
                      /// null is that even the image file is not exist, the `File` can still
                      /// returned as it exist, which will cause the thumb bytes return null.
                      /// 此处需要检查缩略图为空的原因是：尽管文件可能已经被删除，但通过`File`读取的文件对象
                      /// 仍然存在，使得返回的数据为空。
                      final Uint8List thumbData = pathEntityList[pathEntity];
                      if (thumbData != null) {
                        return Image.memory(pathEntityList[pathEntity], fit: BoxFit.cover);
                      } else {
                        return Container(color: Colors.white12);
                      }
                    },
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: Text(
                            '${pathEntity.name}',
                            style: const TextStyle(fontSize: 20.0, height: 1.25),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      Text(
                        '(${pathEntity.assetCount})',
                        style: TextStyle(color: Colors.grey[600], fontSize: 20.0),
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
                builder: (BuildContext _, AssetPathEntity currentPathEntity, Widget __) {
                  if (currentPathEntity == pathEntity) {
                    return AspectRatio(
                      aspectRatio: 1.0,
                      child: Icon(Icons.check, color: themeColor, size: 32.0),
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
    final double maxHeight = Screens.height * 0.75;
    return Selector<AssetPickerProvider, bool>(
      selector: (BuildContext _, AssetPickerProvider provider) => provider.isSwitchingPath,
      builder: (BuildContext _, bool isSwitchingPath, Widget __) {
        return AnimatedPositioned(
          duration: switchingPathDuration,
          curve: switchingPathCurve,
          top: -(!isSwitchingPath ? maxHeight : 1.0),
          child: Container(
            width: Screens.width,
            height: maxHeight,
            decoration: BoxDecoration(color: theme.primaryColor),
            child: Selector<AssetPickerProvider, Map<AssetPathEntity, Uint8List>>(
              selector: (BuildContext _, AssetPickerProvider provider) => provider.pathEntityList,
              builder: (BuildContext _, Map<AssetPathEntity, Uint8List> pathEntityList, Widget __) {
                return ListView.separated(
                  padding: const EdgeInsets.only(top: 1.0),
                  itemCount: pathEntityList.length,
                  itemBuilder: (BuildContext _, int index) {
                    return pathEntityWidget(pathEntityList.keys.elementAt(index));
                  },
                  separatorBuilder: (BuildContext _, int __) => Container(
                    height: 1.0,
                    color: const Color(0xff4e4e4e),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  /// Confirm button.
  /// 确认按钮
  ///
  /// It'll pop with [AssetPickerProvider.selectedAssets] when there're any assets were chosen.
  /// 当有资源已选时，点击按钮将把已选资源通过路由返回。
  Widget confirmButton(BuildContext context) => Consumer<AssetPickerProvider>(
        builder: (BuildContext _, AssetPickerProvider provider, Widget __) {
          return MaterialButton(
            minWidth: provider.isSelectedNotEmpty ? 50.0 : 20.0,
            height: 38.0,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            color: provider.isSelectedNotEmpty ? themeColor : theme.dividerColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Text(
              provider.isSelectedNotEmpty
                  ? '确认(${provider.selectedAssets.length}/${provider.maxAssets})'
                  : '确认',
              style: TextStyle(
                color: provider.isSelectedNotEmpty ? Colors.white : Colors.grey[600],
                fontSize: 18.0,
                height: 1.25,
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
  Widget get gifIndicator => Positioned(
        bottom: 6.0,
        right: 6.0,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
            color: theme.primaryColor.withOpacity(0.75),
          ),
          child: Text(
            '动图',
            style: TextStyle(
              color: theme.iconTheme.color,
              fontSize: 14.0,
            ),
          ),
        ),
      );

  /// Item widget when [AssetEntity.thumbData] loaded successfully.
  /// 资源缩略数据加载成功时使用的部件
  Widget _succeedItem(
    BuildContext context,
    int index,
    Widget completedWidget, {
    SpecialAssetType specialAssetType,
  }) {
    final AssetEntity item = provider.currentAssets.elementAt(index);
    return Selector<AssetPickerProvider, Set<AssetEntity>>(
      selector: (BuildContext _, AssetPickerProvider provider) => provider.selectedAssets,
      builder: (BuildContext _, Set<AssetEntity> selectedAssets, Widget __) {
        final bool selected = provider.selectedAssets.contains(item);
        return Stack(
          children: <Widget>[
            Positioned.fill(child: RepaintBoundary(child: completedWidget)),
            Positioned.fill(
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
                  duration: kThemeAnimationDuration,
                  color: selected ? Colors.black45 : Colors.black.withOpacity(0.1),
                ),
              ), // 点击预览同目录下所有资源
            ),
            if (specialAssetType == SpecialAssetType.gif)
              gifIndicator,
            Positioned(
              top: 0.0,
              right: 0.0,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  if (selected) {
                    provider.unSelectAsset(item);
                  } else {
                    provider.selectAsset(item);
                  }
                },
                child: AnimatedContainer(
                  duration: kThemeAnimationDuration,
                  width: 25.0,
                  height: 25.0,
                  margin: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: !selected ? Border.all(color: Colors.white, width: 2.0) : null,
                    color: selected ? themeColor : null,
                    shape: BoxShape.circle,
                  ),
                  child: AnimatedSwitcher(
                    duration: kThemeAnimationDuration,
                    reverseDuration: kThemeAnimationDuration,
                    child: selected
                        ? Text(
                            '${selectedAssets.toList().indexOf(item) + 1}',
                            style: TextStyle(color: Colors.white, fontSize: 18.0),
                          )
                        : const SizedBox.shrink(),
                  ),
                ),
              ),
            ) // 角标,
          ],
        );
      },
    );
  }

  /// Item widget when [AssetEntity.thumbData] load failed.
  /// 资源缩略数据加载失败时使用的部件
  Widget get _failedItem => Center(
        child: Text(
          '加载失败',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 18.0),
        ),
      );

  /// [GridView] for assets under [AssetPickerProvider.currentPathEntity].
  /// 正在查看的目录下的资源网格部件
  Widget assetsGrid(BuildContext context) => Selector<AssetPickerProvider, Set<AssetEntity>>(
        selector: (BuildContext _, AssetPickerProvider provider) => provider.currentAssets,
        builder: (BuildContext _, Set<AssetEntity> currentAssets, Widget __) {
          return GridView.builder(
            padding: EdgeInsets.zero,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: gridCount,
              mainAxisSpacing: itemSpacing,
              crossAxisSpacing: itemSpacing,
            ),
            itemCount: currentAssets.length,
            itemBuilder: (BuildContext _, int index) {
              final AssetEntityImageProvider imageProvider = AssetEntityImageProvider(
                currentAssets.elementAt(index),
                isOriginal: false,
              );
              return RepaintBoundary(
                child: ExtendedImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                  loadStateChanged: (ExtendedImageState state) {
                    Widget loader;
                    switch (state.extendedImageLoadState) {
                      case LoadState.loading:
                        loader = PlatformProgressIndicator(
                          color: theme.iconTheme.color,
                          size: Screens.width / gridCount / 6,
                        );
                        break;
                      case LoadState.completed:
                        SpecialAssetType type;
                        if (imageProvider.imageFileType == ImageFileType.gif) {
                          type = SpecialAssetType.gif;
                        }
                        loader = FadeImageBuilder(
                          child: _succeedItem(
                            context,
                            index,
                            state.completedWidget,
                            specialAssetType: type,
                          ),
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
            },
          );
        },
      );

  /// Preview button to preview selected assets.
  /// 预览已选资源的按钮
  Widget previewButton(BuildContext context) {
    return Selector<AssetPickerProvider, bool>(
      selector: (BuildContext _, AssetPickerProvider provider) => provider.isSelectedNotEmpty,
      builder: (BuildContext _, bool isSelectedNotEmpty, Widget __) {
        return GestureDetector(
          onTap: isSelectedNotEmpty
              ? () async {
                  final Set<AssetEntity> result = await AssetPickerViewer.pushToViewer(
                    context,
                    currentIndex: 0,
                    assets: provider.currentAssets,
                    selectedAssets: provider.selectedAssets,
                    selectorProvider: provider,
                    themeData: theme,
                  );
                  if (result != null) {
                    Navigator.of(context).pop(result);
                  }
                }
              : null,
          child: Selector<AssetPickerProvider, Set<AssetEntity>>(
            selector: (BuildContext _, AssetPickerProvider provider) => provider.selectedAssets,
            builder: (BuildContext _, Set<AssetEntity> selectedAssets, Widget __) {
              return Text(
                isSelectedNotEmpty ? '预览(${provider.selectedAssets.length})' : '预览',
                style: TextStyle(
                  color: isSelectedNotEmpty ? null : Colors.grey[600],
                  fontSize: 18.0,
                ),
              );
            },
          ),
        );
      },
    );
  }

  /// Action bar widget aligned to bottom.
  /// 底部操作栏部件
  Widget bottomActionBar(BuildContext context) => Container(
        height: kToolbarHeight / 1.4,
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        color: theme.primaryColor,
        child: Row(children: <Widget>[previewButton(context)]),
      );

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Theme(
        data: theme,
        child: ChangeNotifierProvider<AssetPickerProvider>.value(
          value: provider,
          child: Material(
            color: theme.canvasColor,
            child: FixedAppBarWrapper(
              appBar: FixedAppBar(
                backgroundColor: theme.primaryColor,
                centerTitle: false,
                title: pathEntitySelector,
                actionsPadding: const EdgeInsets.only(right: 20.0),
                actions: <Widget>[confirmButton(context)],
              ),
              body: Selector<AssetPickerProvider, bool>(
                selector: (BuildContext _, AssetPickerProvider provider) =>
                    provider.hasAssetsToDisplay,
                builder: (BuildContext _, bool hasAssetsToDisplay, Widget __) {
                  return AnimatedSwitcher(
                    duration: kThemeAnimationDuration,
                    child: hasAssetsToDisplay
                        ? Stack(
                            children: <Widget>[
                              RepaintBoundary(
                                child: Column(
                                  children: <Widget>[
                                    Expanded(child: assetsGrid(context)),
                                    bottomActionBar(context),
                                  ],
                                ),
                              ),
                              pathEntityListWidget,
                            ],
                          )
                        : Center(
                            child: PlatformProgressIndicator(
                              color: theme.iconTheme.color,
                              size: Screens.width / gridCount / 6,
                            ),
                          ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
