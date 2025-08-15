// Copyright 2019 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by an Apache license that can be found
// in the LICENSE file.

/// Author: Maël (https://github.com/LeGoffMael)
///
/// See the package https://github.com/LeGoffMael/insta_assets_picker
/// for the complete implementations.
library;

import 'dart:math';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../../constants/extensions.dart';

/// The reduced height of the viewer
const double _kReducedViewerHeight = kToolbarHeight;

/// The position of the viewer when extended
const double _kExtendedViewerPosition = 0.0;

/// Scroll offset multiplier to start viewer position animation
const double _kScrollMultiplier = 1.5;

const double _kIndicatorSize = 20.0;
const double _kPathSelectorRowHeight = 50.0;

const Color _themeColor = Color(0xffe1306c);

class InstaAssetPicker extends StatefulWidget {
  const InstaAssetPicker({super.key});

  @override
  State<InstaAssetPicker> createState() => _InstaAssetPickerState();
}

class _InstaAssetPickerState extends State<InstaAssetPicker> {
  final int maxAssets = 10;
  late final ThemeData theme = AssetPicker.themeData(_themeColor);
  List<AssetEntity> entities = <AssetEntity>[];

  // use always same provider for `keepScrollOffset`
  late final DefaultAssetPickerProvider provider = DefaultAssetPickerProvider(
    maxAssets: maxAssets,
    requestType: RequestType.all,
  );

  bool isDisplayingDetail = true;

  @override
  void dispose() {
    provider.dispose();
    super.dispose();
  }

  Future<void> callPicker(BuildContext context) async {
    final PermissionState ps = await AssetPicker.permissionCheck(
      requestOption: PermissionRequestOption(
        androidPermission: AndroidPermission(
          type: provider.requestType,
          mediaLocation: false,
        ),
      ),
    );
    final InstaAssetPickerBuilder builder = InstaAssetPickerBuilder(
      provider: provider,
      initialPermission: ps,
      pickerTheme: theme,
      keepScrollOffset: true,
      locale: Localizations.maybeLocaleOf(context),
    );
    final List<AssetEntity>? result = await AssetPicker.pickAssetsWithDelegate(
      context,
      delegate: builder,
    );

    if (result != null) {
      entities = result;
      if (mounted) {
        setState(() {});
      }
    }
  }

  Widget selectedAssetsWidget(BuildContext context) {
    return AnimatedContainer(
      duration: kThemeChangeDuration,
      curve: Curves.easeInOut,
      height: entities.isNotEmpty
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
                if (entities.isNotEmpty) {
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
                      '${entities.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        height: 1.0,
                      ),
                    ),
                  ),
                  if (entities.isNotEmpty)
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
        itemCount: entities.length,
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
    final AssetEntity asset = entities.elementAt(index);

    Future<void> onTap() async {
      final List<AssetEntity>? result = await AssetPickerViewer.pushToViewer(
        context,
        currentIndex: index,
        previewAssets: entities,
        selectedAssets: entities,
        themeData: theme,
        selectorProvider: provider,
        maxAssets: maxAssets,
      );
      if (result != null) {
        entities = result;
        if (mounted) {
          setState(() {});
        }
      }
    }

    return GestureDetector(
      onTap: isDisplayingDetail ? onTap : null,
      child: RepaintBoundary(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: _assetWidgetBuilder(asset),
        ),
      ),
    );
  }

  Widget _assetWidgetBuilder(AssetEntity asset) {
    return Image(image: AssetEntityImageProvider(asset), fit: BoxFit.cover);
  }

  Widget _selectedAssetDeleteButton(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          entities.removeAt(index);
          if (entities.isEmpty) {
            isDisplayingDetail = false;
          }
        });
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          color: theme.canvasColor.withOpacity(0.5),
        ),
        child: Icon(
          Icons.close,
          color: theme.iconTheme.color,
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.customPickerInstagramLayoutName),
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
                      context.l10n.customPickerInstagramLayoutDescription,
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

class InstaAssetPickerBuilder extends DefaultAssetPickerBuilderDelegate {
  InstaAssetPickerBuilder({
    required super.provider,
    required super.initialPermission,
    super.gridCount = 4,
    super.pickerTheme,
    super.textDelegate,
    super.locale,
    super.keepScrollOffset,
  }) : super(
          shouldRevertGrid: false,
          specialItemPosition: SpecialItemPosition.none,
        );

  /// Save last position of the grid view scroll controller
  double _lastScrollOffset = 0.0;
  double _lastEndScrollOffset = 0.0;

  /// Scroll offset position to jump to after the viewer is expanded
  double? _scrollTargetOffset;

  final ValueNotifier<double> _viewerPosition = ValueNotifier<double>(0);
  final ValueNotifier<AssetEntity?> _previewAsset =
      ValueNotifier<AssetEntity?>(null);

  @override
  void dispose() {
    if (!keepScrollOffset) {
      _viewerPosition.dispose();
      _previewAsset.dispose();
    }
    super.dispose();
  }

  /// The responsive height of the preview widget
  /// setup to not be bigger than half the screen height
  double previewHeight(BuildContext context) => min(
        MediaQuery.sizeOf(context).width,
        MediaQuery.sizeOf(context).height * 0.5,
      );

  /// Returns thumbnail [index] position in scroll view
  double indexPosition(BuildContext context, int index) {
    final int row = (index / gridCount).floor();
    final double size =
        (MediaQuery.sizeOf(context).width - itemSpacing * (gridCount - 1)) /
            gridCount;
    return row * size + (row * itemSpacing);
  }

  void _expandViewer([double? scrollOffset]) {
    _scrollTargetOffset = scrollOffset;
    _viewerPosition.value = _kExtendedViewerPosition;
  }

  void unSelectAll() {
    provider.selectedAssets = <AssetEntity>[];
    _previewAsset.value = null;
  }

  /// Initialize [_previewAsset] with [p.selectedAssets] if not empty
  /// otherwise if the first item of the album
  Future<void> _initializePreviewAsset(
    DefaultAssetPickerProvider p,
    bool shouldDisplayAssets,
  ) async {
    if (_previewAsset.value != null) {
      return;
    }

    if (p.selectedAssets.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _previewAsset.value = p.selectedAssets.last,
      );
    }

    // when asset list is available and no asset is selected,
    // preview the first of the list
    if (shouldDisplayAssets && p.selectedAssets.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final List<AssetEntity>? list =
            await p.currentPath?.path.getAssetListRange(start: 0, end: 1);
        if (list?.isNotEmpty ?? false) {
          _previewAsset.value = list!.first;
        }
      });
    }
  }

  @override
  Future<void> viewAsset(
    BuildContext context,
    int? index,
    AssetEntity currentAsset,
  ) async {
    if (index == null) {
      return;
    }
    // if is preview asset, unselect it
    if (provider.selectedAssets.isNotEmpty &&
        _previewAsset.value == currentAsset) {
      selectAsset(context, currentAsset, index, true);
      _previewAsset.value = provider.selectedAssets.isEmpty
          ? currentAsset
          : provider.selectedAssets.last;
      return;
    }

    _previewAsset.value = currentAsset;
    selectAsset(context, currentAsset, index, false);
  }

  @override
  Future<void> selectAsset(
    BuildContext context,
    AssetEntity asset,
    int index,
    bool selected,
  ) async {
    final double thumbnailPosition = indexPosition(context, index);
    final int prevCount = provider.selectedAssets.length;
    await super.selectAsset(context, asset, index, selected);

    // update preview asset with selected
    final List<AssetEntity> selectedAssets = provider.selectedAssets;
    if (prevCount < selectedAssets.length) {
      _previewAsset.value = asset;
    } else if (selected &&
        asset == _previewAsset.value &&
        selectedAssets.isNotEmpty) {
      _previewAsset.value = selectedAssets.last;
    }

    _expandViewer(thumbnailPosition);
  }

  /// Handle scroll on grid view to hide/expand the viewer
  bool _handleScroll(
    BuildContext context,
    ScrollNotification notification,
    double position,
    double reducedPosition,
  ) {
    final bool isScrollUp = gridScrollController.position.userScrollDirection ==
        ScrollDirection.reverse;
    final bool isScrollDown =
        gridScrollController.position.userScrollDirection ==
            ScrollDirection.forward;

    if (notification is ScrollEndNotification) {
      _lastEndScrollOffset = gridScrollController.offset;
      // reduce viewer
      if (position > reducedPosition && position < _kExtendedViewerPosition) {
        _viewerPosition.value = reducedPosition;
        return true;
      }
    }

    // expand viewer
    if (isScrollDown &&
        gridScrollController.offset < 0 &&
        position < _kExtendedViewerPosition) {
      // if scroll at edge, compute position based on scroll
      if (_lastScrollOffset > gridScrollController.offset) {
        _viewerPosition.value -=
            (_lastScrollOffset.abs() - gridScrollController.offset.abs()) * 6;
      } else {
        // otherwise just expand it
        _expandViewer();
      }
    } else if (isScrollUp &&
        (gridScrollController.offset - _lastEndScrollOffset) *
                _kScrollMultiplier >
            previewHeight(context) - position &&
        position > reducedPosition) {
      // reduce viewer
      _viewerPosition.value = previewHeight(context) -
          (gridScrollController.offset - _lastEndScrollOffset) *
              _kScrollMultiplier;
    }

    _lastScrollOffset = gridScrollController.offset;

    return true;
  }

  Widget get buildEntityViewer {
    return Listener(
      onPointerDown: (_) {
        _expandViewer();
        // stop scroll event
        if (gridScrollController.hasClients) {
          gridScrollController.jumpTo(gridScrollController.offset);
        }
      },
      child: ValueListenableBuilder<AssetEntity?>(
        valueListenable: _previewAsset,
        builder: (BuildContext context, AssetEntity? previewAsset, __) =>
            SizedBox(
          width: MediaQuery.sizeOf(context).width,
          height: previewHeight(context),
          child: Selector<DefaultAssetPickerProvider, List<AssetEntity>>(
            selector: (_, DefaultAssetPickerProvider p) => p.selectedAssets,
            builder: (_, List<AssetEntity> selected, __) {
              if (previewAsset == null && selected.isEmpty) {
                return loadingIndicator(context);
              }

              int effectiveIndex =
                  selected.isEmpty ? 0 : selected.indexOf(selected.last);
              if (previewAsset != null) {
                effectiveIndex = selected.indexOf(previewAsset);
              }
              final List<AssetEntity> assets =
                  selected.isEmpty ? <AssetEntity>[previewAsset!] : selected;

              return AssetPickerViewer<AssetEntity, AssetPathEntity>(
                builder: InstaAssetPickerViewerBuilder(
                  currentIndex: effectiveIndex == -1 ? 0 : effectiveIndex,
                  previewAssets: assets,
                  themeData: theme,
                  selectorProvider: provider,
                  selectPredicate: selectPredicate,
                  selectedAssets: assets,
                  onPreviewChanged: (int index) =>
                      _previewAsset.value = assets[index],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  AssetPickerAppBar appBar(BuildContext context) {
    final AssetPickerAppBar appBar = AssetPickerAppBar(
      leading: backButton(context),
      actions: <Widget>[confirmButton(context)],
    );
    appBarPreferredSize ??= appBar.preferredSize;
    return appBar;
  }

  @override
  Widget androidLayout(BuildContext context) {
    appBarPreferredSize ??= appBar(context).preferredSize;
    final double appBarHeight = appBarPreferredSize!.height;
    // height of appbar + viewer + path selector row
    final double topWidgetHeight = previewHeight(context) +
        appBarHeight +
        _kPathSelectorRowHeight +
        MediaQuery.paddingOf(context).top;

    return ChangeNotifierProvider<DefaultAssetPickerProvider>.value(
      value: provider,
      builder: (BuildContext context, _) => ValueListenableBuilder<double>(
        valueListenable: _viewerPosition,
        builder: (BuildContext context, double position, _) {
          // the top position when the viewer is reduced
          final double topReducedPosition =
              -(previewHeight(context) - _kReducedViewerHeight + appBarHeight);
          position =
              position.clamp(topReducedPosition, _kExtendedViewerPosition);
          // opacity is calculated based on the position of the viewer
          final double opacity =
              ((position / -topReducedPosition) + 1).clamp(0.4, 1.0);
          final Duration animationDuration = position == topReducedPosition ||
                  position == _kExtendedViewerPosition
              ? const Duration(milliseconds: 250)
              : Duration.zero;

          double gridHeight = MediaQuery.sizeOf(context).height -
              appBarHeight -
              _kReducedViewerHeight;
          // when not assets are displayed, compute the exact height to show the loader
          if (!provider.hasAssetsToDisplay) {
            gridHeight -= previewHeight(context) - -_viewerPosition.value;
          }
          final double topPadding = topWidgetHeight + position;
          if (gridScrollController.hasClients && _scrollTargetOffset != null) {
            gridScrollController.jumpTo(_scrollTargetOffset!);
          }
          _scrollTargetOffset = null;

          return Stack(
            children: <Widget>[
              AnimatedPadding(
                padding: EdgeInsets.only(top: topPadding),
                duration: animationDuration,
                child: SizedBox(
                  height: gridHeight,
                  width: MediaQuery.sizeOf(context).width,
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification notification) =>
                        _handleScroll(
                      context,
                      notification,
                      position,
                      topReducedPosition,
                    ),
                    child: _buildGrid(context),
                  ),
                ),
              ),
              AnimatedPositioned(
                top: position,
                duration: animationDuration,
                child: SizedBox(
                  width: MediaQuery.sizeOf(context).width,
                  height: topWidgetHeight,
                  child: AssetPickerAppBarWrapper(
                    appBar: appBar(context),
                    body: DecoratedBox(
                      decoration: BoxDecoration(
                        color: pickerTheme?.canvasColor,
                      ),
                      child: Column(
                        children: <Widget>[
                          Opacity(opacity: opacity, child: buildEntityViewer),
                          SizedBox(
                            height: _kPathSelectorRowHeight,
                            width: MediaQuery.sizeOf(context).width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                pathEntitySelector(context),
                                IconButton(
                                  onPressed: unSelectAll,
                                  icon: const Icon(
                                    Icons.layers_clear_sharp,
                                    size: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              pathEntityListBackdrop(context),
              _buildListAlbums(context),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget appleOSLayout(BuildContext context) => androidLayout(context);

  Widget _buildListAlbums(BuildContext context) {
    appBarPreferredSize ??= appBar(context).preferredSize;
    return Consumer<DefaultAssetPickerProvider>(
      builder: (BuildContext context, DefaultAssetPickerProvider provider, __) {
        if (isAppleOS(context)) {
          return pathEntityListWidget(context);
        }

        // NOTE: fix position on android, quite hacky could be optimized
        return ValueListenableBuilder<bool>(
          valueListenable: isSwitchingPath,
          builder: (_, bool isSwitchingPath, __) => Transform.translate(
            offset: isSwitchingPath
                ? Offset(
                    0,
                    appBarPreferredSize!.height +
                        MediaQuery.paddingOf(context).top,
                  )
                : Offset.zero,
            child: Stack(
              children: <Widget>[pathEntityListWidget(context)],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGrid(BuildContext context) {
    appBarPreferredSize ??= appBar(context).preferredSize;
    return Consumer<DefaultAssetPickerProvider>(
      builder: (BuildContext context, DefaultAssetPickerProvider p, __) {
        final bool shouldDisplayAssets =
            p.hasAssetsToDisplay || shouldBuildSpecialItem;
        _initializePreviewAsset(p, shouldDisplayAssets);

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: shouldDisplayAssets
              ? MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    padding: EdgeInsets.only(
                      top: -appBarPreferredSize!.height,
                    ),
                  ),
                  child: RepaintBoundary(child: assetsGridBuilder(context)),
                )
              : loadingIndicator(context),
        );
      },
    );
  }

  /// To show selected assets indicator and preview asset overlay
  @override
  Widget selectIndicator(BuildContext context, int index, AssetEntity asset) {
    final List<AssetEntity> selectedAssets = provider.selectedAssets;
    final Duration duration = switchingPathDuration * 0.75;

    final int indexSelected = selectedAssets.indexOf(asset);
    final bool isSelected = indexSelected != -1;

    final Widget innerSelector = AnimatedContainer(
      duration: duration,
      width: _kIndicatorSize,
      height: _kIndicatorSize,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        border: Border.all(color: theme.unselectedWidgetColor),
        color: isSelected
            ? themeColor
            : theme.unselectedWidgetColor.withOpacity(.2),
        shape: BoxShape.circle,
      ),
      child: FittedBox(
        child: AnimatedSwitcher(
          duration: duration,
          reverseDuration: duration,
          child: isSelected
              ? Text((indexSelected + 1).toString())
              : const SizedBox.shrink(),
        ),
      ),
    );

    return ValueListenableBuilder<AssetEntity?>(
      valueListenable: _previewAsset,
      builder:
          (BuildContext context, AssetEntity? previewAsset, Widget? child) {
        final bool isPreview = asset == _previewAsset.value;

        return Positioned.fill(
          child: GestureDetector(
            onTap: isPreviewEnabled
                ? () => viewAsset(context, index, asset)
                : null,
            child: AnimatedContainer(
              duration: switchingPathDuration,
              padding: const EdgeInsets.all(4),
              color: isPreview
                  ? theme.unselectedWidgetColor.withOpacity(.5)
                  : theme.colorScheme.surface.withOpacity(.1),
              child: Align(
                alignment: AlignmentDirectional.topEnd,
                child: isSelected && !isSingleAssetMode
                    ? GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () =>
                            selectAsset(context, asset, index, isSelected),
                        child: innerSelector,
                      )
                    : innerSelector,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget selectedBackdrop(BuildContext context, int index, AssetEntity asset) =>
      const SizedBox.shrink();
}

class InstaAssetPickerViewerBuilder
    extends DefaultAssetPickerViewerBuilderDelegate {
  InstaAssetPickerViewerBuilder({
    required super.currentIndex,
    required super.previewAssets,
    required super.themeData,
    super.selectorProvider,
    super.provider,
    super.selectedAssets,
    super.maxAssets,
    super.shouldReversePreview,
    super.selectPredicate,
    required this.onPreviewChanged,
  });

  final Function(int index) onPreviewChanged;

  Widget _pageViewBuilder(BuildContext context) {
    // update pageController to display `currentIndex`
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (pageController.hasClients &&
          !pageController.position.isScrollingNotifier.value) {
        pageController.jumpToPage(currentIndex);
      }
    });

    return Semantics(
      sortKey: ordinalSortKey(1),
      child: ExtendedImageGesturePageView.builder(
        controller: pageController,
        itemCount: previewAssets.length,
        itemBuilder: assetPageBuilder,
        reverse: shouldReversePreview,
        onPageChanged: (int index) {
          currentIndex = index;
          pageStreamController.add(index);
          onPreviewChanged(index);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) => _pageViewBuilder(context);
}
