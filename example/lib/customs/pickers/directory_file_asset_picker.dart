// Copyright 2019 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by an Apache license that can be found
// in the LICENSE file.

import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data' as typed_data;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' show basename;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../../constants/extensions.dart';

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
  const DirectoryFileAssetPicker({super.key});

  @override
  State<DirectoryFileAssetPicker> createState() =>
      _DirectoryFileAssetPickerState();
}

class _DirectoryFileAssetPickerState extends State<DirectoryFileAssetPicker> {
  final List<File> fileList = <File>[];

  bool isDisplayingDetail = true;

  ThemeData get currentTheme => Theme.of(context);

  Future<void> callPicker(BuildContext context) async {
    final FileAssetPickerProvider provider = FileAssetPickerProvider(
      selectedAssets: fileList,
    );
    final FileAssetPickerBuilder builder = FileAssetPickerBuilder(
      provider: provider,
      locale: Localizations.maybeLocaleOf(context),
    );
    final List<File>? result = await AssetPicker.pickAssetsWithDelegate(
      context,
      delegate: builder,
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

  Widget selectedAssetsWidget(BuildContext context) {
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
                  Text(context.l10n.selectedAssetsText),
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
          selectedAssetsListView(context),
        ],
      ),
    );
  }

  Widget selectedAssetsListView(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        scrollDirection: Axis.horizontal,
        itemCount: fileList.length,
        itemBuilder: (_, int index) {
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
              final List<File>? result =
                  await Navigator.maybeOf(context)?.push<List<File>>(
                AssetPickerViewerPageRoute(builder: (context) => viewer),
              );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.customPickerDirectoryAndFileName),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: DefaultTextStyle.merge(
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: SelectableText(
                      context.l10n.customPickerDirectoryAndFileDescription,
                    ),
                  ),
                  TextButton(
                    onPressed: () => callPicker(context),
                    child: Text(
                      context.l10n.customPickerCallThePickerButton,
                      style: const TextStyle(fontSize: 22),
                    ),
                  ),
                ],
              ),
            ),
          ),
          selectedAssetsWidget(context),
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
      await getPaths();
      getAssetsFromPath(0, paths.first.path);
    });
  }

  @override
  Future<void> getPaths() async {
    currentAssets = <File>[];
    final Directory directory = await getApplicationDocumentsDirectory();
    final PathWrapper<Directory> wrapper = PathWrapper<Directory>(
      path: directory,
      thumbnailData: await getThumbnailFromPath(
        PathWrapper<Directory>(path: directory),
      ),
    );
    paths = [wrapper];
    currentPath = wrapper;
  }

  @override
  Future<void> getAssetsFromPath(int page, Directory path) async {
    final List<FileSystemEntity> entities =
        path.listSync().whereType<File>().toList();
    currentAssets.clear();
    for (final FileSystemEntity entity in entities) {
      final String extension = basename(entity.path).split('.').last;
      if (entity is File && imagesExtensions.contains(extension)) {
        currentAssets.add(entity);
      }
    }
    hasAssetsToDisplay = currentAssets.isNotEmpty;
    totalAssetsCount = currentAssets.length;
    isAssetsEmpty = totalAssetsCount == 0;
    final PathWrapper<Directory> wrapper = currentPath!;
    if (wrapper.assetCount == null) {
      currentPath = currentPath!.copyWith(assetCount: totalAssetsCount);
    }
  }

  @override
  Future<typed_data.Uint8List?> getThumbnailFromPath(
    PathWrapper<Directory> path,
  ) async {
    final List<FileSystemEntity> entities =
        path.path.listSync().whereType<File>().toList();
    currentAssets.clear();
    for (final FileSystemEntity entity in entities) {
      final String extension = basename(entity.path).split('.').last;
      if (entity is File && imagesExtensions.contains(extension)) {
        final typed_data.Uint8List data = await entity.readAsBytes();
        return data;
      }
    }
    return null;
  }

  @override
  void unSelectAsset(File item) {
    final List<File> set = selectedAssets.toList();
    set.removeWhere((File f) => f.path == item.path);
    selectedAssets = set;
  }

  @override
  Future<void> loadMoreAssets() {
    return Future<void>.value();
  }

  @override
  Future<void> switchPath([PathWrapper<Directory>? path]) async {
    if (path == null) {
      return;
    }
    currentPath = path;
    totalAssetsCount = 0;
    notifyListeners();
    await getAssetsFromPath(0, currentPath!.path);
  }
}

class FileAssetPickerBuilder
    extends AssetPickerBuilderDelegate<File, Directory> {
  FileAssetPickerBuilder({
    required this.provider,
    super.locale,
  }) : super(initialPermission: PermissionState.authorized);

  final FileAssetPickerProvider provider;

  Duration get switchingPathDuration => kThemeAnimationDuration * 1.5;

  Curve get switchingPathCurve => Curves.easeInOut;

  @override
  bool get isSingleAssetMode => provider.maxAssets == 1;

  @override
  Future<void> viewAsset(
    BuildContext context,
    int? index,
    File currentAsset,
  ) async {
    final Widget viewer = AssetPickerViewer<File, Directory>(
      builder: FileAssetPickerViewerBuilderDelegate(
        currentIndex: index ?? provider.selectedAssets.indexOf(currentAsset),
        previewAssets: provider.selectedAssets,
        provider: FileAssetPickerViewerProvider(provider.selectedAssets),
        themeData: AssetPicker.themeData(themeColor),
        selectedAssets: provider.selectedAssets,
        selectorProvider: provider,
      ),
    );
    final List<File>? result =
        await Navigator.maybeOf(context)?.push<List<File>?>(
      AssetPickerViewerPageRoute(builder: (context) => viewer),
    );
    if (result != null) {
      Navigator.maybeOf(context)?.maybePop(result);
    }
  }

  Future<List<File>?> pushToPicker(
    BuildContext context, {
    required int index,
    required List<File> previewAssets,
    List<File>? selectedAssets,
    FileAssetPickerProvider? selectorProvider,
  }) async {
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
    return await Navigator.maybeOf(context)?.push<List<File>?>(
      AssetPickerViewerPageRoute(builder: (context) => viewer),
    );
  }

  @override
  void selectAsset(BuildContext context, File asset, int index, bool selected) {
    if (selected) {
      provider.unSelectAsset(asset);
    } else {
      if (isSingleAssetMode) {
        provider.selectedAssets.clear();
      }
      provider.selectAsset(asset);
    }
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
    final AppBar appBar = AppBar(
      backgroundColor: theme.appBarTheme.backgroundColor,
      title: Semantics(
        onTapHint: semanticsTextDelegate.sActionSwitchPathLabel,
        child: pathEntitySelector(context),
      ),
      leading: backButton(context),
    );
    appBarPreferredSize ??= appBar.preferredSize;
    return appBar;
  }

  @override
  Widget appleOSLayout(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: Selector<FileAssetPickerProvider, bool>(
            selector: (_, FileAssetPickerProvider p) => p.hasAssetsToDisplay,
            builder: (BuildContext context, bool hasAssetsToDisplay, __) {
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
        Positioned.fill(bottom: null, child: appBar(context)),
      ],
    );
  }

  @override
  Widget loadingIndicator(BuildContext context) {
    return Selector<FileAssetPickerProvider, bool>(
      selector: (_, FileAssetPickerProvider p) => p.isAssetsEmpty,
      builder: (BuildContext context, bool isAssetsEmpty, Widget? w) {
        if (loadingIndicatorBuilder != null) {
          return loadingIndicatorBuilder!(context, isAssetsEmpty);
        }
        return Center(child: isAssetsEmpty ? emptyIndicator(context) : w);
      },
      child: Center(
        child: SizedBox.fromSize(
          size: Size.square(MediaQuery.sizeOf(context).width / gridCount / 3),
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              theme.iconTheme.color ?? Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget assetsGridBuilder(BuildContext context) {
    appBarPreferredSize ??= appBar(context).preferredSize;
    int totalCount = provider.currentAssets.length;
    if (specialItemPosition != SpecialItemPosition.none) {
      totalCount += 1;
    }
    final int placeholderCount;
    if (isAppleOS(context) && totalCount % gridCount != 0) {
      placeholderCount = gridCount - totalCount % gridCount;
    } else {
      placeholderCount = 0;
    }
    final int row = (totalCount + placeholderCount) ~/ gridCount;
    final double dividedSpacing = itemSpacing / gridCount;
    final double topPadding =
        MediaQuery.paddingOf(context).top + appBarPreferredSize!.height;

    Widget sliverGrid(BuildContext ctx, List<File> assets) {
      return SliverGrid(
        delegate: SliverChildBuilderDelegate(
          (_, int index) => Builder(
            builder: (BuildContext c) {
              if (isAppleOS(c)) {
                if (index < placeholderCount) {
                  return const SizedBox.shrink();
                }
                index -= placeholderCount;
              }
              return Directionality(
                textDirection: Directionality.of(context),
                child: assetGridItemBuilder(c, index, assets),
              );
            },
          ),
          childCount: assetsGridItemCount(
            context: ctx,
            assets: assets,
            placeholderCount: placeholderCount,
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
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: gridCount,
          mainAxisSpacing: itemSpacing,
          crossAxisSpacing: itemSpacing,
        ),
      );
    }

    return LayoutBuilder(
      builder: (BuildContext c, BoxConstraints constraints) {
        final double itemSize = constraints.maxWidth / gridCount;
        // Use [ScrollView.anchor] to determine where is the first place of
        // the [SliverGrid]. Each row needs [dividedSpacing] to calculate,
        // then minus one times of [itemSpacing] because spacing's count in the
        // cross axis is always less than the rows.
        final double anchor = math.min(
          (row * (itemSize + dividedSpacing) + topPadding - itemSpacing) /
              constraints.maxHeight,
          1,
        );

        return Directionality(
          textDirection: effectiveGridDirection(context),
          child: ColoredBox(
            color: theme.canvasColor,
            child: Selector<FileAssetPickerProvider, List<File>>(
              selector: (_, FileAssetPickerProvider provider) =>
                  provider.currentAssets,
              builder: (context, List<File> assets, __) => CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                controller: gridScrollController,
                anchor: isAppleOS(context) ? anchor : 0,
                center: isAppleOS(context) ? gridRevertKey : null,
                slivers: <Widget>[
                  if (isAppleOS(context))
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: MediaQuery.paddingOf(context).top +
                            appBarPreferredSize!.height,
                      ),
                    ),
                  sliverGrid(context, assets),
                  // Ignore the gap when the [anchor] is not equal to 1.
                  if (isAppleOS(context) && anchor == 1)
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: MediaQuery.paddingOf(context).bottom +
                            bottomSectionHeight,
                      ),
                    ),
                  if (isAppleOS(context))
                    SliverToBoxAdapter(
                      key: gridRevertKey,
                      child: const SizedBox.shrink(),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget assetGridItemBuilder(
    BuildContext context,
    int index,
    List<File> currentAssets,
  ) {
    final int currentIndex = switch (specialItemPosition) {
      SpecialItemPosition.none || SpecialItemPosition.append => index,
      SpecialItemPosition.prepend => index - 1,
    };
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
        selectIndicator(context, index, asset),
      ],
    );
  }

  @override
  Semantics assetGridItemSemanticsBuilder(
    BuildContext context,
    int index,
    File asset,
    Widget child,
  ) {
    return Semantics(child: child);
  }

  @override
  int assetsGridItemCount({
    required BuildContext context,
    required List<File> assets,
    int placeholderCount = 0,
  }) {
    final int length = switch (specialItemPosition) {
      SpecialItemPosition.none => assets.length,
      SpecialItemPosition.prepend ||
      SpecialItemPosition.append =>
        assets.length + 1,
    };
    return length + placeholderCount;
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
            onPressed: () {
              if (provider.isSelectedNotEmpty) {
                Navigator.maybeOf(context)?.pop(provider.selectedAssets);
              }
            },
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            child: Text(
              provider.isSelectedNotEmpty && !isSingleAssetMode
                  ? '${textDelegate.confirm}'
                      '(${provider.selectedAssets.length}/${provider.maxAssets})'
                  : textDelegate.confirm,
              style: TextStyle(
                color: provider.isSelectedNotEmpty
                    ? theme.textTheme.bodyLarge?.color
                    : theme.textTheme.bodySmall?.color,
                fontSize: 17.0,
                fontWeight: FontWeight.normal,
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget imageAndVideoItemBuilder(BuildContext context, int index, File asset) {
    return RepaintBoundary(child: Image.file(asset, fit: BoxFit.cover));
  }

  @override
  Widget pathEntityListBackdrop(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isSwitchingPath,
      builder: (_, bool isSwitchingPath, __) => IgnorePointer(
        ignoring: !isSwitchingPath,
        child: GestureDetector(
          onTap: () => this.isSwitchingPath.value = false,
          child: AnimatedOpacity(
            duration: switchingPathDuration,
            opacity: isSwitchingPath ? 1.0 : 0.0,
            child: Container(color: Colors.black.withOpacity(0.75)),
          ),
        ),
      ),
    );
  }

  @override
  Widget pathEntityListWidget(BuildContext context) {
    appBarPreferredSize ??= appBar(context).preferredSize;
    final double appBarHeight =
        appBarPreferredSize!.height + MediaQuery.paddingOf(context).top;
    final double maxHeight = MediaQuery.sizeOf(context).height * 0.825;
    return ValueListenableBuilder<bool>(
      valueListenable: isSwitchingPath,
      builder: (_, bool isSwitchingPath, Widget? w) => AnimatedPositioned(
        duration: switchingPathDuration,
        curve: switchingPathCurve,
        top: isAppleOS(context)
            ? !isSwitchingPath
                ? -maxHeight
                : appBarHeight
            : -(!isSwitchingPath ? maxHeight : 1.0),
        child: AnimatedOpacity(
          duration: switchingPathDuration,
          curve: switchingPathCurve,
          opacity: !isAppleOS(context) || isSwitchingPath ? 1.0 : 0.0,
          child: Container(
            width: MediaQuery.sizeOf(context).width,
            height: maxHeight,
            decoration: BoxDecoration(
              borderRadius: isAppleOS(context)
                  ? const BorderRadius.vertical(bottom: Radius.circular(10.0))
                  : null,
              color: theme.colorScheme.background,
            ),
            child: w,
          ),
        ),
      ),
      child: Selector<FileAssetPickerProvider, List<PathWrapper<Directory>>>(
        selector: (_, FileAssetPickerProvider p) => p.paths,
        builder: (_, List<PathWrapper<Directory>> paths, __) {
          return ListView.separated(
            padding: const EdgeInsetsDirectional.only(top: 1.0),
            itemCount: paths.length,
            itemBuilder: (_, int index) => pathEntityWidget(
              context: context,
              list: paths,
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
      child: GestureDetector(
        onTap: () => isSwitchingPath.value = !isSwitchingPath.value,
        child: Container(
          height: appBarItemHeight,
          constraints: BoxConstraints(
            maxWidth: MediaQuery.sizeOf(context).width * 0.5,
          ),
          padding: const EdgeInsetsDirectional.only(start: 12.0, end: 6.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            color: theme.dividerColor,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Selector<FileAssetPickerProvider, PathWrapper<Directory>?>(
                selector: (_, FileAssetPickerProvider p) => p.currentPath,
                builder: (_, PathWrapper<Directory>? currentWrapper, __) {
                  if (currentWrapper == null) {
                    return const SizedBox.shrink();
                  }
                  return Flexible(
                    child: Text(
                      currentWrapper.path.path,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.normal,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsetsDirectional.only(start: 5.0),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.iconTheme.color?.withOpacity(0.5),
                  ),
                  child: ValueListenableBuilder<bool>(
                    valueListenable: isSwitchingPath,
                    builder: (_, bool isSwitchingPath, Widget? w) {
                      return Transform.rotate(
                        angle: isSwitchingPath ? math.pi : 0.0,
                        child: w,
                      );
                    },
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
      ),
    );
  }

  @override
  Widget pathEntityWidget({
    required BuildContext context,
    required List<PathWrapper<Directory>> list,
    required int index,
    bool isAudio = false,
  }) {
    final PathWrapper<Directory> wrapper = list[index];
    final Directory path = wrapper.path;
    final typed_data.Uint8List? data = wrapper.thumbnailData;

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
        onTap: () {
          provider.switchPath(wrapper);
          isSwitchingPath.value = false;
        },
        child: SizedBox(
          height: isAppleOS(context) ? 64.0 : 52.0,
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
              Selector<FileAssetPickerProvider, PathWrapper<Directory>>(
                selector: (_, FileAssetPickerProvider p) => p.currentPath!,
                builder: (_, PathWrapper<Directory> currentPathEntity, __) {
                  if (currentPathEntity == wrapper) {
                    return const AspectRatio(
                      aspectRatio: 1.0,
                      child: Icon(Icons.check, color: themeColor, size: 26.0),
                    );
                  }
                  return const SizedBox.shrink();
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
                    selectorProvider: provider,
                  );
                  if (result != null) {
                    Navigator.maybeOf(context)?.pop(result);
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
                        : theme.textTheme.bodySmall?.color,
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
  Widget selectIndicator(BuildContext context, int index, File asset) {
    return Selector<FileAssetPickerProvider, List<File>>(
      selector: (_, FileAssetPickerProvider p) => p.selectedAssets,
      builder: (_, List<File> selectedAssets, __) {
        final bool isSelected =
            selectedAssets.where((File f) => f.path == asset.path).isNotEmpty;
        final double indicatorSize =
            MediaQuery.sizeOf(context).width / gridCount / 3;
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
                MediaQuery.sizeOf(context).width /
                    gridCount /
                    (isAppleOS(context) ? 12.0 : 15.0),
              ),
              width: indicatorSize,
              height: indicatorSize,
              alignment: AlignmentDirectional.topEnd,
              child: AnimatedContainer(
                duration: switchingPathDuration,
                width: indicatorSize / (isAppleOS(context) ? 1.25 : 1.5),
                height: indicatorSize / (isAppleOS(context) ? 1.25 : 1.5),
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
                                    ? theme.textTheme.bodyLarge?.color
                                    : null,
                                fontSize: isAppleOS(context) ? 16.0 : 14.0,
                                fontWeight: isAppleOS(context)
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
                Navigator.maybeOf(context)?.pop(result);
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
  int findChildIndexBuilder({
    required String id,
    required List<File> assets,
    int placeholderCount = 0,
  }) {
    return assets.indexWhere((File file) => file.path == id);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlayStyle,
      child: Theme(
        data: theme,
        child: ChangeNotifierProvider<FileAssetPickerProvider>.value(
          value: provider,
          builder: (BuildContext c, __) => Material(
            color: theme.canvasColor,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                if (isAppleOS(context)) appleOSLayout(c) else androidLayout(c),
                permissionOverlay(c),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FileAssetPickerViewerProvider extends AssetPickerViewerProvider<File> {
  FileAssetPickerViewerProvider(List<File> super.assets);

  @override
  void unSelectAsset(File item) {
    final List<File> list = currentlySelectedAssets.toList()
      ..removeWhere((File f) => f.path == item.path);
    currentlySelectedAssets = list;
  }
}

class FileAssetPickerViewerBuilderDelegate
    extends AssetPickerViewerBuilderDelegate<File, Directory> {
  FileAssetPickerViewerBuilderDelegate({
    required super.previewAssets,
    required super.themeData,
    required super.currentIndex,
    super.selectedAssets,
    super.selectorProvider,
    super.provider,
  }) : super(
          maxAssets: selectorProvider?.maxAssets,
        );

  late final PageController _pageController = PageController(
    initialPage: currentIndex,
  );

  bool _isDisplayingDetail = true;

  @override
  void switchDisplayingDetail({bool? value}) {
    _isDisplayingDetail = value ?? !_isDisplayingDetail;
    if (viewerState.mounted) {
      // ignore: invalid_use_of_protected_member
      viewerState.setState(() {});
    }
  }

  @override
  Widget assetPageBuilder(BuildContext context, int index) {
    final File asset = previewAssets.elementAt(index);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: switchDisplayingDetail,
      child: Image.file(asset, fit: BoxFit.contain),
    );
  }

  @override
  Widget bottomDetailBuilder(BuildContext context) {
    return AnimatedPositioned(
      duration: kThemeAnimationDuration,
      curve: Curves.easeInOut,
      bottom: _isDisplayingDetail
          ? 0.0
          : -(MediaQuery.paddingOf(context).bottom + bottomDetailHeight),
      left: 0.0,
      right: 0.0,
      height: MediaQuery.paddingOf(context).bottom + bottomDetailHeight,
      child: Container(
        padding: EdgeInsetsDirectional.only(
          bottom: MediaQuery.paddingOf(context).bottom,
        ),
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
                    if (isAppleOS(context) && provider != null)
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
                          child: Image.file(asset, fit: BoxFit.cover),
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
      top: _isDisplayingDetail
          ? 0.0
          : -(MediaQuery.paddingOf(context).top + kToolbarHeight),
      left: 0.0,
      right: 0.0,
      height: MediaQuery.paddingOf(context).top + kToolbarHeight,
      child: Container(
        padding: EdgeInsetsDirectional.only(
          top: MediaQuery.paddingOf(context).top,
          end: 12.0,
        ),
        color: themeData.canvasColor.withOpacity(0.85),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: Semantics(
                  sortKey: ordinalSortKey(0),
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    tooltip: MaterialLocalizations.of(
                      context,
                    ).backButtonTooltip,
                    onPressed: Navigator.maybeOf(context)?.maybePop,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: StreamBuilder<int>(
                  initialData: currentIndex,
                  stream: pageStreamController.stream,
                  builder: (BuildContext _, AsyncSnapshot<int> snapshot) {
                    return Text(
                      '${snapshot.requireData + 1}/${previewAssets.length}',
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
              ),
            ),
            if (provider != null)
              Expanded(
                child: Container(
                  alignment: AlignmentDirectional.centerEnd,
                  padding: const EdgeInsetsDirectional.only(end: 14),
                  child: Semantics(
                    sortKey: ordinalSortKey(0.2),
                    child: selectButton(context),
                  ),
                ),
              )
            else
              const Spacer(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: themeData,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: themeData.brightness.reverse == Brightness.dark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
        child: Builder(
          builder: (BuildContext context) => Material(
            color: Colors.black,
            child: Stack(
              children: <Widget>[
                Positioned.fill(
                  child: PageView.builder(
                    physics: const BouncingScrollPhysics(),
                    controller: _pageController,
                    itemCount: previewAssets.length,
                    itemBuilder: assetPageBuilder,
                    onPageChanged: (int index) {
                      currentIndex = index;
                      pageStreamController.add(index);
                    },
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
            onPressed: () {
              if (provider.isSelectedNotEmpty) {
                Navigator.maybeOf(context)
                    ?.pop(provider.currentlySelectedAssets);
              }
            },
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
                      ? themeData.textTheme.bodyLarge?.color
                      : themeData.textTheme.bodySmall?.color;
                }(),
                fontSize: 17.0,
                fontWeight: FontWeight.normal,
              ),
            ),
          );
        },
      ),
    );
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
                  if (isAppleOS(context)) {
                    return _appleOSSelectButton(isSelected, asset);
                  } else {
                    return _androidSelectButton(isSelected, asset);
                  }
                },
              ),
            );
          },
        ),
        if (!isAppleOS(context))
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
            provider?.unSelectAsset(asset);
          } else {
            provider?.selectAsset(asset);
          }
        },
        child: AnimatedContainer(
          duration: kThemeAnimationDuration,
          width: 28.0,
          decoration: BoxDecoration(
            border: !isSelected
                ? Border.all(color: themeData.iconTheme.color!)
                : null,
            color: isSelected ? themeData.colorScheme.secondary : null,
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
          provider?.unSelectAsset(asset);
          selectorProvider?.unSelectAsset(asset);
        } else {
          provider?.selectAsset(asset);
          selectorProvider?.selectAsset(asset);
        }
      },
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}
