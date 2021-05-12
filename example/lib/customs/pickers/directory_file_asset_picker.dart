///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2021/5/10 16:44
///
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../../constants/screens.dart';

const Color themeColor = Color(0xff00bc56);

const List<String> imagesExtensions = <String>[
  'jpg',
  'jpeg',
  'webp',
  'gif',
  'bmp',
  'wbmp',
  'tiff',
  'heic',
];

class DirectoryFileAssetPicker extends StatefulWidget {
  const DirectoryFileAssetPicker({Key? key}) : super(key: key);

  @override
  _DirectoryFileAssetPickerState createState() =>
      _DirectoryFileAssetPickerState();
}

class _DirectoryFileAssetPickerState extends State<DirectoryFileAssetPicker>
    with AutomaticKeepAliveClientMixin {
  final List<File> fileList = <File>[];

  bool isDisplayingDetail = true;

  ThemeData get currentTheme => Theme.of(context);

  Future<void> callPicker() async {
    final FileAssetPickerProvider provider = FileAssetPickerProvider(
      selectedAssets: fileList,
    );
    final Widget picker = ChangeNotifierProvider<FileAssetPickerProvider>.value(
      value: provider,
      child: AssetPicker<File, Directory>(
        builder: FileAssetPickerBuilder(provider: provider),
      ),
    );
    final List<File>? result = await Navigator.of(
      context,
      rootNavigator: true,
    ).push<List<File>>(
      AssetPickerPageRoute<List<File>>(
        builder: picker,
        transitionCurve: Curves.easeIn,
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
    if (result != null) {
      fileList
        ..clear()
        ..addAll(result);
      if (mounted) {
        setState(() {});
      }
    }
  }

  Widget get selectedAssetsWidget {
    return AnimatedContainer(
      duration: kThemeChangeDuration,
      curve: Curves.easeInOut,
      height: fileList.isNotEmpty
          ? isDisplayingDetail
              ? 120.0
              : 80.0
          : 40.0,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 20.0,
            child: GestureDetector(
              onTap: () {
                if (fileList.isNotEmpty) {
                  setState(() {
                    isDisplayingDetail = !isDisplayingDetail;
                  });
                }
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Text('Selected Assets'),
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                    ),
                    padding: const EdgeInsets.all(4.0),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey,
                    ),
                    child: Text(
                      '${fileList.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        height: 1.0,
                      ),
                    ),
                  ),
                  if (fileList.isNotEmpty)
                    Icon(
                      isDisplayingDetail
                          ? Icons.arrow_downward
                          : Icons.arrow_upward,
                      size: 18.0,
                    ),
                ],
              ),
            ),
          ),
          selectedAssetsListView,
        ],
      ),
    );
  }

  Widget get selectedAssetsListView {
    return Expanded(
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        scrollDirection: Axis.horizontal,
        itemCount: fileList.length,
        itemBuilder: (BuildContext _, int index) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 16.0,
            ),
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Stack(
                children: <Widget>[
                  Positioned.fill(child: _selectedAssetWidget(index)),
                  AnimatedPositionedDirectional(
                    duration: kThemeAnimationDuration,
                    top: isDisplayingDetail ? 6.0 : -30.0,
                    end: isDisplayingDetail ? 6.0 : -30.0,
                    child: _selectedAssetDeleteButton(index),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _selectedAssetWidget(int index) {
    final File asset = fileList.elementAt(index);
    return GestureDetector(
      onTap: isDisplayingDetail
          ? () async {
              final Widget viewer = AssetPickerViewer<File, Directory>(
                builder: FileAssetPickerViewerBuilderDelegate(
                  currentIndex: index,
                  previewAssets: fileList,
                  provider: FileAssetPickerViewerProvider(fileList),
                  themeData: AssetPicker.themeData(themeColor),
                ),
              );
              final PageRouteBuilder<List<File>> pageRoute =
                  PageRouteBuilder<List<File>>(
                pageBuilder: (
                  BuildContext context,
                  Animation<double> animation,
                  Animation<double> secondaryAnimation,
                ) {
                  return viewer;
                },
                transitionsBuilder: (
                  BuildContext context,
                  Animation<double> animation,
                  Animation<double> secondaryAnimation,
                  Widget child,
                ) {
                  return FadeTransition(opacity: animation, child: child);
                },
              );
              final List<File>? result =
                  await Navigator.of(context).push<List<File>>(pageRoute);
              if (result != null && result != fileList) {
                fileList
                  ..clear()
                  ..addAll(result);
                if (mounted) {
                  setState(() {});
                }
              }
            }
          : null,
      child: RepaintBoundary(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: _assetWidgetBuilder(asset),
        ),
      ),
    );
  }

  Widget _assetWidgetBuilder(File asset) {
    return Image.file(asset, fit: BoxFit.cover);
  }

  Widget _selectedAssetDeleteButton(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          fileList.removeAt(index);
          if (fileList.isEmpty) {
            isDisplayingDetail = false;
          }
        });
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          color: currentTheme.canvasColor.withOpacity(0.5),
        ),
        child: Icon(
          Icons.close,
          color: currentTheme.iconTheme.color,
          size: 18.0,
        ),
      ),
    );
  }

  Widget paddingText(String text) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SelectableText(text),
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  @mustCallSuper
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Directory+File picker')),
      body: Column(
        children: <Widget>[
          Expanded(
            child: DefaultTextStyle.merge(
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  paddingText(
                    'This is a custom picker built for `File`.\n'
                    'By browsing this picker, we want you to know that '
                    'you can build your own picker components using '
                    'the entity\'s type you desired.',
                  ),
                  paddingText(
                    'In this page, picker will grab files from '
                    '`getExternalStorageDirectory`, Then check whether '
                    'it contains images.',
                  ),
                  paddingText(
                    'Put files into the path to see how this custom picker work.',
                  ),
                  TextButton(
                    onPressed: callPicker,
                    child: const Text(
                      '🎁 Call the Picker',
                      style: TextStyle(fontSize: 22),
                    ),
                  ),
                ],
              ),
            ),
          ),
          selectedAssetsWidget,
        ],
      ),
    );
  }
}

class FileAssetPickerProvider extends AssetPickerProvider<File, Directory> {
  FileAssetPickerProvider({
    required List<File> selectedAssets,
  }) : super(selectedAssets: selectedAssets) {
    Future<void>.delayed(const Duration(milliseconds: 300), () async {
      await getAssetPathList();
      getAssetsFromEntity(0, pathEntityList.keys.elementAt(0));
    });
  }

  @override
  Future<void> getAssetPathList() async {
    currentAssets = <File>[];
    pathEntityList.clear();
    final Directory? directory = await getExternalStorageDirectory();
    if (directory != null) {
      pathEntityList[directory] = null;
      currentPathEntity = directory;
      pathEntityList[directory] = await getFirstThumbFromPathEntity(directory);
    }
  }

  @override
  Future<void> getAssetsFromEntity(int page, Directory pathEntity) async {
    final List<FileSystemEntity> entities =
        pathEntity.listSync().whereType<File>().toList();
    currentAssets.clear();
    for (final FileSystemEntity entity in entities) {
      final String extension = path.basename(entity.path).split('.').last;
      if (entity is File && imagesExtensions.contains(extension)) {
        currentAssets.add(entity);
      }
    }
    hasAssetsToDisplay = currentAssets.isNotEmpty;
    totalAssetsCount = currentAssets.length;
  }

  @override
  Future<Uint8List?> getFirstThumbFromPathEntity(Directory pathEntity) async {
    final List<FileSystemEntity> entities =
        pathEntity.listSync().whereType<File>().toList();
    currentAssets.clear();
    for (final FileSystemEntity entity in entities) {
      final String extension = path.basename(entity.path).split('.').last;
      if (entity is File && imagesExtensions.contains(extension)) {
        final Uint8List data = await entity.readAsBytes();
        return data;
      }
    }
    return null;
  }

  @override
  void unSelectAsset(File item) {
    final List<File> _set = List<File>.from(selectedAssets);
    _set.removeWhere((File f) => f.path == item.path);
    selectedAssets = _set;
  }

  @override
  Future<void> loadMoreAssets() {
    return Future<void>.value(null);
  }

  @override
  void switchPath(Directory pathEntity) {
    isSwitchingPath = false;
    currentPathEntity = pathEntity;
    totalAssetsCount = 0;
    notifyListeners();
    getAssetsFromEntity(0, currentPathEntity!);
  }
}

class FileAssetPickerBuilder
    extends AssetPickerBuilderDelegate<File, Directory> {
  FileAssetPickerBuilder({
    required FileAssetPickerProvider provider,
  }) : super(provider: provider);

  AssetsPickerTextDelegate get textDelegate =>
      DefaultAssetsPickerTextDelegate();

  Duration get switchingPathDuration => kThemeAnimationDuration * 1.5;

  Curve get switchingPathCurve => Curves.easeInOut;

  Future<List<File>?> pushToPicker(
    BuildContext context, {
    required int index,
    required List<File> previewAssets,
    List<File>? selectedAssets,
    FileAssetPickerProvider? selectorProvider,
  }) {
    final Widget viewer = AssetPickerViewer<File, Directory>(
      builder: FileAssetPickerViewerBuilderDelegate(
        currentIndex: index,
        previewAssets: previewAssets,
        provider: selectedAssets != null
            ? FileAssetPickerViewerProvider(selectedAssets)
            : null,
        themeData: AssetPicker.themeData(themeColor),
        selectedAssets: selectedAssets,
        selectorProvider: selectorProvider,
      ),
    );
    final PageRouteBuilder<List<File>> pageRoute = PageRouteBuilder<List<File>>(
      pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) {
        return viewer;
      },
      transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
      ) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
    return Navigator.of(context).push<List<File>?>(pageRoute);
  }

  @override
  Widget androidLayout(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          appBar(context),
          Expanded(
            child: Selector<FileAssetPickerProvider, bool>(
              selector: (
                BuildContext _,
                FileAssetPickerProvider provider,
              ) =>
                  provider.hasAssetsToDisplay,
              builder: (_, bool hasAssetsToDisplay, __) {
                return AnimatedSwitcher(
                  duration: switchingPathDuration,
                  child: hasAssetsToDisplay
                      ? Stack(
                          children: <Widget>[
                            RepaintBoundary(
                              child: Column(
                                children: <Widget>[
                                  Expanded(child: assetsGridBuilder(context)),
                                  if (!isSingleAssetMode)
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
          ),
        ],
      ),
    );
  }

  @override
  PreferredSizeWidget appBar(BuildContext context) {
    return AppBar(
      backgroundColor: theme.appBarTheme.color,
      centerTitle: isAppleOS,
      title: pathEntitySelector(context),
      leading: backButton(context),
      actions: !isAppleOS
          ? <Widget>[
              confirmButton(context),
              const SizedBox(width: 14.0),
            ]
          : null,
    );
  }

  @override
  Widget appleOSLayout(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: Selector<FileAssetPickerProvider, bool>(
            selector: (
              _,
              FileAssetPickerProvider p,
            ) =>
                p.hasAssetsToDisplay,
            builder: (_, bool hasAssetsToDisplay, __) {
              return AnimatedSwitcher(
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
              );
            },
          ),
        ),
        appBar(context),
      ],
    );
  }

  @override
  Widget assetGridItemBuilder(
    BuildContext context,
    int index,
    List<File> currentAssets,
  ) {
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

    final File asset = currentAssets.elementAt(currentIndex);
    final Widget builder = imageAndVideoItemBuilder(
      context,
      currentIndex,
      asset,
    );
    return Stack(
      key: ValueKey<String>(asset.path),
      fit: StackFit.expand,
      children: <Widget>[
        Positioned.fill(child: builder),
        selectIndicator(context, asset),
      ],
    );
  }

  @override
  int assetsGridItemCount(BuildContext context, List<File> currentAssets) {
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
  Widget audioIndicator(BuildContext context, File asset) {
    return const SizedBox.shrink();
  }

  @override
  Widget audioItemBuilder(BuildContext context, int index, File asset) {
    return imageAndVideoItemBuilder(context, index, asset);
  }

  @override
  Widget confirmButton(BuildContext context) {
    return Center(
      child: Consumer<FileAssetPickerProvider>(
        builder: (_, FileAssetPickerProvider provider, __) {
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
                  ? '${textDelegate.confirm}'
                      '(${provider.selectedAssets.length}/${provider.maxAssets})'
                  : textDelegate.confirm,
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
      ),
    );
  }

  @override
  Widget imageAndVideoItemBuilder(BuildContext context, int index, File asset) {
    final FileImage imageProvider = FileImage(asset);
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
              loader = Stack(
                children: <Widget>[
                  Positioned.fill(
                    child: RepaintBoundary(child: state.completedWidget),
                  ),
                  selectedBackdrop(context, index, asset),
                ],
              );
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
      child: Selector<FileAssetPickerProvider, bool>(
        selector: (_, FileAssetPickerProvider p) => p.isAssetsEmpty,
        builder: (_, bool isAssetsEmpty, __) {
          if (isAssetsEmpty) {
            return const Text('Nothing here.');
          } else {
            return Center(
              child: SizedBox.fromSize(
                size: Size.square(Screens.width / gridCount / 3),
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    theme.iconTheme.color ?? Colors.grey,
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  @override
  Widget pathEntityListBackdrop(BuildContext context) {
    return Selector<FileAssetPickerProvider, bool>(
      selector: (_, FileAssetPickerProvider p) => p.isSwitchingPath,
      builder: (BuildContext context, bool isSwitchingPath, _) {
        return IgnorePointer(
          ignoring: !isSwitchingPath,
          child: GestureDetector(
            onTap: () {
              context.read<FileAssetPickerProvider>().isSwitchingPath = false;
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
    return Selector<FileAssetPickerProvider, bool>(
      selector: (_, FileAssetPickerProvider p) => p.isSwitchingPath,
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
      child: Selector<FileAssetPickerProvider, Map<Directory, Uint8List?>>(
        selector: (_, FileAssetPickerProvider p) => p.pathEntityList,
        builder: (_, Map<Directory, Uint8List?> pathEntityList, __) {
          return ListView.separated(
            padding: const EdgeInsetsDirectional.only(top: 1.0),
            itemCount: pathEntityList.length,
            itemBuilder: (_, int index) => pathEntityWidget(
              context: context,
              list: pathEntityList,
              index: index,
            ),
            separatorBuilder: (_, __) => Container(
              margin: const EdgeInsetsDirectional.only(start: 60.0),
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
      child: Consumer<FileAssetPickerProvider>(
        builder: (_, FileAssetPickerProvider provider, __) {
          return GestureDetector(
            onTap: () {
              provider.isSwitchingPath = !provider.isSwitchingPath;
            },
            child: Container(
              height: appBarItemHeight,
              constraints: BoxConstraints(maxWidth: Screens.width * 0.5),
              padding: const EdgeInsetsDirectional.only(start: 12.0, end: 6.0),
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
                        provider.currentPathEntity!.path,
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.normal,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsetsDirectional.only(start: 5.0),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: theme.iconTheme.color?.withOpacity(0.5),
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
  }

  @override
  Widget pathEntityWidget({
    required BuildContext context,
    required Map<Directory, Uint8List?> list,
    required int index,
    bool isAudio = false,
  }) {
    final Directory path = list.keys.elementAt(index);
    final Uint8List? data = list.values.elementAt(index);

    Widget builder() {
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
        onTap: () => provider.switchPath(path),
        child: SizedBox(
          height: isAppleOS ? 64.0 : 52.0,
          child: Row(
            children: <Widget>[
              RepaintBoundary(
                child: AspectRatio(aspectRatio: 1.0, child: builder()),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(
                    start: 15.0,
                    end: 20.0,
                  ),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(end: 10.0),
                    child: Text(
                      path.path,
                      style: const TextStyle(fontSize: 18.0),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
              Selector<FileAssetPickerProvider, Directory>(
                selector: (_, FileAssetPickerProvider p) =>
                    p.currentPathEntity!,
                builder: (_, Directory currentPathEntity, __) {
                  if (currentPathEntity == path) {
                    return const AspectRatio(
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

  @override
  Widget previewButton(BuildContext context) {
    return Selector<FileAssetPickerProvider, bool>(
      selector: (_, FileAssetPickerProvider p) => p.isSelectedNotEmpty,
      builder: (_, bool isSelectedNotEmpty, __) {
        return GestureDetector(
          onTap: isSelectedNotEmpty
              ? () async {
                  final List<File>? result = await pushToPicker(
                    context,
                    index: 0,
                    previewAssets: provider.selectedAssets,
                    selectedAssets: provider.selectedAssets,
                    selectorProvider: provider as FileAssetPickerProvider,
                  );
                  if (result != null) {
                    Navigator.of(context).pop(result);
                  }
                }
              : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Selector<FileAssetPickerProvider, List<File>>(
              selector: (_, FileAssetPickerProvider p) => p.selectedAssets,
              builder: (_, List<File> selectedAssets, __) {
                return Text(
                  isSelectedNotEmpty
                      ? '${textDelegate.preview}'
                          '(${provider.selectedAssets.length})'
                      : textDelegate.preview,
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
        );
      },
    );
  }

  @override
  Widget selectIndicator(BuildContext context, File asset) {
    return Selector<FileAssetPickerProvider, List<File>>(
      selector: (_, FileAssetPickerProvider p) => p.selectedAssets,
      builder: (_, List<File> selectedAssets, __) {
        final bool isSelected =
            selectedAssets.where((File f) => f.path == asset.path).isNotEmpty;
        int index = 0;
        if (isSelected) {
          index = selectedAssets.indexWhere((File f) => f.path == asset.path);
        }
        final double indicatorSize = Screens.width / gridCount / 3;
        return Positioned(
          top: 0.0,
          right: 0.0,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              if (isSelected) {
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
                  border: !isSelected
                      ? Border.all(color: Colors.white, width: 2.0)
                      : null,
                  color: isSelected ? themeColor : null,
                  shape: BoxShape.circle,
                ),
                child: AnimatedSwitcher(
                  duration: switchingPathDuration,
                  reverseDuration: switchingPathDuration,
                  child: isSelected
                      ? isSingleAssetMode
                          ? const Icon(Icons.check, size: 18.0)
                          : Text(
                              '${index + 1}',
                              style: TextStyle(
                                color: isSelected
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
  Widget selectedBackdrop(BuildContext context, int index, File asset) {
    return Selector<FileAssetPickerProvider, List<File>>(
      selector: (_, FileAssetPickerProvider p) => p.selectedAssets,
      builder: (_, List<File> selectedAssets, __) {
        final bool isSelected =
            selectedAssets.where((File f) => f.path == asset.path).isNotEmpty;
        return Positioned.fill(
          child: GestureDetector(
            onTap: () async {
              final List<File>? result = await pushToPicker(
                context,
                index: index,
                previewAssets: provider.currentAssets,
              );
              if (result != null) {
                Navigator.of(context).pop(result);
              }
            },
            child: AnimatedContainer(
              duration: switchingPathDuration,
              color: isSelected
                  ? theme.colorScheme.primary.withOpacity(0.45)
                  : Colors.black.withOpacity(0.1),
            ),
          ), // 点击预览同目录下所有资源
        );
      },
    );
  }

  @override
  Widget videoIndicator(BuildContext context, File asset) {
    return const SizedBox.shrink();
  }

  @override
  int findChildIndexBuilder(String id, List<File> currentAssets) {
    return currentAssets.indexWhere((File file) => file.path == id);
  }
}

class FileAssetPickerViewerProvider extends AssetPickerViewerProvider<File> {
  FileAssetPickerViewerProvider(List<File> assets) : super(assets);

  @override
  void unSelectAssetEntity(File entity) {
    final List<File> set = List<File>.from(currentlySelectedAssets);
    set.removeWhere((File f) => f.path == entity.path);
    currentlySelectedAssets = List<File>.from(set);
  }
}

class FileAssetPickerViewerBuilderDelegate
    extends AssetPickerViewerBuilderDelegate<File, Directory> {
  FileAssetPickerViewerBuilderDelegate({
    required List<File> previewAssets,
    required ThemeData themeData,
    required int currentIndex,
    List<File>? selectedAssets,
    AssetPickerProvider<File, Directory>? selectorProvider,
    AssetPickerViewerProvider<File>? provider,
  }) : super(
          provider: provider,
          previewAssets: previewAssets,
          themeData: themeData,
          currentIndex: currentIndex,
          selectedAssets: selectedAssets,
          selectorProvider: selectorProvider,
          maxAssets: selectorProvider?.maxAssets,
        );

  bool isDisplayingDetail = true;

  late final AnimationController _doubleTapAnimationController;
  late final Animation<double> _doubleTapCurveAnimation;
  Animation<double>? _doubleTapAnimation;
  late VoidCallback _doubleTapListener;

  late final PageController pageController;

  AssetsPickerTextDelegate get textDelegate =>
      DefaultAssetsPickerTextDelegate();

  void switchDisplayingDetail({bool? value}) {
    isDisplayingDetail = value ?? !isDisplayingDetail;
    if (viewerState.mounted) {
      // ignore: invalid_use_of_protected_member
      viewerState.setState(() {});
    }
  }

  void updateAnimation(ExtendedImageGestureState state) {
    final double begin = state.gestureDetails!.totalScale!;
    final double end = state.gestureDetails!.totalScale! == 1.0 ? 3.0 : 1.0;
    final Offset pointerDownPosition = state.pointerDownPosition!;

    _doubleTapAnimation?.removeListener(_doubleTapListener);
    _doubleTapAnimationController
      ..stop()
      ..reset();
    _doubleTapListener = () {
      state.handleDoubleTap(
        scale: _doubleTapAnimation!.value,
        doubleTapPosition: pointerDownPosition,
      );
    };
    _doubleTapAnimation = Tween<double>(
      begin: begin,
      end: end,
    ).animate(_doubleTapCurveAnimation)
      ..addListener(_doubleTapListener);
    _doubleTapAnimationController.forward();
  }

  Future<bool> syncSelectedAssetsWhenPop() async {
    if (provider?.currentlySelectedAssets != null) {
      selectorProvider?.selectedAssets = provider!.currentlySelectedAssets;
    }
    return true;
  }

  @override
  Widget assetPageBuilder(BuildContext context, int index) {
    final File asset = previewAssets.elementAt(index);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: switchDisplayingDetail,
      child: ExtendedImage.file(
        asset,
        fit: BoxFit.contain,
        mode: ExtendedImageMode.gesture,
        onDoubleTap: updateAnimation,
        initGestureConfigHandler: (ExtendedImageState state) {
          return GestureConfig(
            initialScale: 1.0,
            minScale: 1.0,
            maxScale: 3.0,
            animationMinScale: 0.6,
            animationMaxScale: 4.0,
            cacheGesture: false,
            inPageView: true,
          );
        },
        loadStateChanged: (ExtendedImageState state) {
          return previewWidgetLoadStateChanged(context, state);
        },
      ),
    );
  }

  @override
  Widget bottomDetailBuilder(BuildContext context) {
    return AnimatedPositioned(
      duration: kThemeAnimationDuration,
      curve: Curves.easeInOut,
      bottom: isDisplayingDetail
          ? 0.0
          : -(Screens.bottomSafeHeight + bottomDetailHeight),
      left: 0.0,
      right: 0.0,
      height: Screens.bottomSafeHeight + bottomDetailHeight,
      child: Container(
        padding: EdgeInsetsDirectional.only(bottom: Screens.bottomSafeHeight),
        color: themeData.canvasColor.withOpacity(0.85),
        child: Column(
          children: <Widget>[
            ChangeNotifierProvider<AssetPickerViewerProvider<File>>.value(
              value: provider!,
              child: SizedBox(
                height: 90.0,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  itemCount: selectedAssets!.length,
                  itemBuilder: bottomDetailItemBuilder,
                ),
              ),
            ),
            Container(
              height: 1.0,
              color: themeData.dividerColor,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Spacer(),
                    if (isAppleOS && provider != null)
                      ChangeNotifierProvider<
                          AssetPickerViewerProvider<File>>.value(
                        value: provider!,
                        child: confirmButton(context),
                      )
                    else
                      selectButton(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget bottomDetailItemBuilder(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
      child: AspectRatio(
        aspectRatio: 1.0,
        child: StreamBuilder<int>(
          initialData: currentIndex,
          stream: pageStreamController.stream,
          builder: (BuildContext _, AsyncSnapshot<int> snapshot) {
            final File asset = selectedAssets!.elementAt(index);
            final bool isViewing = asset.path == currentAsset.path;
            return GestureDetector(
              onTap: () {
                if (previewAssets == selectedAssets) {
                  pageController.jumpToPage(index);
                }
              },
              child: Selector<AssetPickerViewerProvider<File>, List<File>>(
                selector: (_, AssetPickerViewerProvider<File> p) =>
                    p.currentlySelectedAssets,
                builder: (_, List<File> currentlySelectedAssets, __) {
                  final bool isSelected = currentlySelectedAssets
                      .where((File f) => f.path == asset.path)
                      .isNotEmpty;
                  return Stack(
                    children: <Widget>[
                      Positioned.fill(
                        child: RepaintBoundary(
                          child: ExtendedImage.file(asset, fit: BoxFit.cover),
                        ),
                      ),
                      AnimatedContainer(
                        duration: kThemeAnimationDuration,
                        curve: Curves.easeInOut,
                        decoration: BoxDecoration(
                          border: isViewing
                              ? Border.all(
                                  color: themeData.colorScheme.secondary,
                                  width: 2.0,
                                )
                              : null,
                          color: isSelected
                              ? null
                              : themeData.colorScheme.surface.withOpacity(0.54),
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget appBar(BuildContext context) {
    return AnimatedPositioned(
      duration: kThemeAnimationDuration,
      curve: Curves.easeInOut,
      top: isDisplayingDetail ? 0.0 : -(Screens.topSafeHeight + kToolbarHeight),
      left: 0.0,
      right: 0.0,
      height: Screens.topSafeHeight + kToolbarHeight,
      child: Container(
        padding: EdgeInsetsDirectional.only(
          top: Screens.topSafeHeight,
          end: 12.0,
        ),
        color: themeData.canvasColor.withOpacity(0.85),
        child: Row(
          children: <Widget>[
            const BackButton(),
            if (!isAppleOS)
              StreamBuilder<int>(
                initialData: currentIndex,
                stream: pageStreamController.stream,
                builder: (BuildContext _, AsyncSnapshot<int> snapshot) {
                  return Text(
                    '${snapshot.data! + 1}/${previewAssets.length}',
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            const Spacer(),
            if (isAppleOS && provider != null) selectButton(context),
            if (!isAppleOS && provider != null) confirmButton(context),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: syncSelectedAssetsWhenPop,
      child: Theme(
        data: themeData,
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: themeData.brightness == Brightness.dark
              ? SystemUiOverlayStyle.light
              : SystemUiOverlayStyle.dark,
          child: Material(
            color: Colors.black,
            child: Stack(
              children: <Widget>[
                Positioned.fill(
                  child: ExtendedImageGesturePageView.builder(
                    physics: const BouncingScrollPhysics(),
                    controller: pageController,
                    itemCount: previewAssets.length,
                    itemBuilder: assetPageBuilder,
                    onPageChanged: (int index) {
                      currentIndex = index;
                      pageStreamController.add(index);
                    },
                    scrollDirection: Axis.horizontal,
                  ),
                ),
                appBar(context),
                if (selectedAssets != null) bottomDetailBuilder(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget confirmButton(BuildContext context) {
    return ChangeNotifierProvider<AssetPickerViewerProvider<File>>.value(
      value: provider!,
      child: Consumer<AssetPickerViewerProvider<File>>(
        builder: (_, AssetPickerViewerProvider<File> provider, __) {
          return MaterialButton(
            minWidth: () {
              return provider.isSelectedNotEmpty ? 48.0 : 20.0;
            }(),
            height: 32.0,
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            color: () {
              return provider.isSelectedNotEmpty
                  ? themeData.colorScheme.secondary
                  : themeData.dividerColor;
            }(),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(3.0),
            ),
            child: Text(
              () {
                if (provider.isSelectedNotEmpty) {
                  return '${textDelegate.confirm}'
                      '(${provider.currentlySelectedAssets.length}'
                      '/'
                      '${selectorProvider!.maxAssets})';
                }
                return textDelegate.confirm;
              }(),
              style: TextStyle(
                color: () {
                  return provider.isSelectedNotEmpty
                      ? themeData.textTheme.bodyText1?.color
                      : themeData.textTheme.caption?.color;
                }(),
                fontSize: 17.0,
                fontWeight: FontWeight.normal,
              ),
            ),
            onPressed: () {
              if (provider.isSelectedNotEmpty) {
                Navigator.of(context).pop(provider.currentlySelectedAssets);
              }
            },
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          );
        },
      ),
    );
  }

  @override
  void initStateAndTicker(
    AssetPickerViewerState<File, Directory> s,
    TickerProvider v,
  ) {
    super.initStateAndTicker(s, v);
    _doubleTapAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: v,
    );
    _doubleTapCurveAnimation = CurvedAnimation(
      parent: _doubleTapAnimationController,
      curve: Curves.easeInOut,
    );
    pageController = PageController(initialPage: currentIndex);
  }

  @override
  void dispose() {
    _doubleTapAnimationController.dispose();
    pageStreamController.close();
  }

  @override
  Widget selectButton(BuildContext context) {
    return Row(
      children: <Widget>[
        StreamBuilder<int>(
          initialData: currentIndex,
          stream: pageStreamController.stream,
          builder: (BuildContext _, AsyncSnapshot<int> snapshot) {
            return ChangeNotifierProvider<
                AssetPickerViewerProvider<File>>.value(
              value: provider!,
              child: Selector<AssetPickerViewerProvider<File>, List<File>>(
                selector: (
                  BuildContext _,
                  AssetPickerViewerProvider<File> provider,
                ) =>
                    provider.currentlySelectedAssets,
                builder: (_, List<File> currentlySelectedAssets, __) {
                  final File asset = previewAssets.elementAt(snapshot.data!);
                  final bool isSelected =
                      currentlySelectedAssets.contains(asset);
                  if (isAppleOS) {
                    return _appleOSSelectButton(isSelected, asset);
                  } else {
                    return _androidSelectButton(isSelected, asset);
                  }
                },
              ),
            );
          },
        ),
        if (!isAppleOS)
          Text(
            textDelegate.select,
            style: const TextStyle(fontSize: 18.0),
          ),
      ],
    );
  }

  Widget _appleOSSelectButton(bool isSelected, File asset) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 10.0),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (isSelected) {
            provider?.unSelectAssetEntity(asset);
          } else {
            provider?.selectAssetEntity(asset);
          }
        },
        child: AnimatedContainer(
          duration: kThemeAnimationDuration,
          width: 28.0,
          decoration: BoxDecoration(
            border: !isSelected
                ? Border.all(color: themeData.iconTheme.color!)
                : null,
            color: isSelected ? themeData.buttonColor : null,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: isSelected
                ? Text(
                    (currentIndex + 1).toString(),
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : const Icon(Icons.check, size: 20.0),
          ),
        ),
      ),
    );
  }

  Widget _androidSelectButton(bool isSelected, File asset) {
    return Checkbox(
      value: isSelected,
      onChanged: (bool? value) {
        if (isSelected) {
          provider?.unSelectAssetEntity(asset);
        } else {
          provider?.selectAssetEntity(asset);
        }
      },
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}
