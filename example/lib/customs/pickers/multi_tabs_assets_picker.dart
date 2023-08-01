// Copyright 2019 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by an Apache license that can be found
// in the LICENSE file.

import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../../constants/extensions.dart';

const Color _themeColor = Color(0xfff2223a);

class MultiTabAssetPicker extends StatefulWidget {
  const MultiTabAssetPicker({super.key});

  @override
  State<MultiTabAssetPicker> createState() => _MultiTabAssetPickerState();
}

class _MultiTabAssetPickerState extends State<MultiTabAssetPicker> {
  final int maxAssets = 9;
  late final ThemeData theme = AssetPicker.themeData(_themeColor);

  List<AssetEntity> entities = <AssetEntity>[];

  bool isDisplayingDetail = true;

  Future<void> callPicker(BuildContext context) async {
    final PermissionState ps = await AssetPicker.permissionCheck();

    final DefaultAssetPickerProvider provider = DefaultAssetPickerProvider(
      selectedAssets: entities,
      maxAssets: maxAssets,
    );
    final DefaultAssetPickerProvider imagesProvider =
        DefaultAssetPickerProvider(
      selectedAssets: entities,
      maxAssets: maxAssets,
    );
    final DefaultAssetPickerProvider videosProvider =
        DefaultAssetPickerProvider(
      selectedAssets: entities,
      maxAssets: maxAssets,
      requestType: RequestType.video,
    );
    final MultiTabAssetPickerBuilder builder = MultiTabAssetPickerBuilder(
      provider: provider,
      imagesProvider: imagesProvider,
      videosProvider: videosProvider,
      initialPermission: ps,
      pickerTheme: theme,
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
        itemBuilder: (_, int index) => Padding(
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
        ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.customPickerMultiTabName)),
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
                      context.l10n.customPickerMultiTabDescription,
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

class MultiTabAssetPickerBuilder extends DefaultAssetPickerBuilderDelegate {
  MultiTabAssetPickerBuilder({
    required super.provider,
    required this.videosProvider,
    required this.imagesProvider,
    required super.initialPermission,
    super.gridCount = 3,
    super.pickerTheme,
    super.themeColor,
    super.textDelegate,
    super.locale,
  }) : super(shouldRevertGrid: false);

  final DefaultAssetPickerProvider videosProvider;
  final DefaultAssetPickerProvider imagesProvider;

  late final TabController _tabController;

  @override
  void initState(AssetPickerState<AssetEntity, AssetPathEntity> state) {
    super.initState(state);
    _tabController = TabController(length: 3, vsync: state);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget pathEntitySelector(BuildContext context) {
    Widget selector(BuildContext context) {
      return UnconstrainedBox(
        child: GestureDetector(
          onTap: () {
            Feedback.forTap(context);
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
              color: theme.dividerColor,
            ),
            child: Selector<DefaultAssetPickerProvider,
                PathWrapper<AssetPathEntity>?>(
              selector: (_, DefaultAssetPickerProvider p) => p.currentPath,
              builder: (_, PathWrapper<AssetPathEntity>? p, Widget? w) => Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (p != null)
                    Flexible(
                      child: Text(
                        isPermissionLimited && p.path.isAll
                            ? textDelegate.accessiblePathName
                            : p.path.name,
                        style: const TextStyle(
                          fontSize: 17,
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

    return ChangeNotifierProvider<TabController>.value(
      value: _tabController,
      builder: (_, __) => Selector<TabController, int>(
        selector: (_, TabController p) => p.index,
        builder: (_, int index, __) {
          return ChangeNotifierProvider<DefaultAssetPickerProvider>.value(
            value: switch (index) {
              1 => videosProvider,
              2 => imagesProvider,
              _ => provider,
            },
            builder: (BuildContext c, _) => selector(c),
          );
        },
      ),
    );
  }

  @override
  Widget confirmButton(BuildContext context) {
    final Widget button = Consumer<DefaultAssetPickerProvider>(
      builder: (_, DefaultAssetPickerProvider p, __) {
        return MaterialButton(
          minWidth: p.isSelectedNotEmpty ? 48 : 20,
          height: appBarItemHeight,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          disabledColor: theme.dividerColor,
          color: p.isSelectedNotEmpty ? themeColor : theme.dividerColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3),
          ),
          onPressed: p.isSelectedNotEmpty
              ? () => Navigator.of(context).maybePop(p.selectedAssets)
              : null,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          child: Text(
            p.isSelectedNotEmpty && !isSingleAssetMode
                ? '${textDelegate.confirm}'
                    ' (${p.selectedAssets.length}/${p.maxAssets})'
                : textDelegate.confirm,
            style: TextStyle(
              color: p.isSelectedNotEmpty
                  ? theme.textTheme.bodyLarge?.color
                  : theme.textTheme.bodySmall?.color,
              fontSize: 17,
              fontWeight: FontWeight.normal,
            ),
          ),
        );
      },
    );
    return ChangeNotifierProvider<TabController>.value(
      value: _tabController,
      builder: (_, __) => Selector<TabController, int>(
        selector: (_, TabController p) => p.index,
        builder: (_, int index, __) {
          return ChangeNotifierProvider<DefaultAssetPickerProvider>.value(
            value: switch (index) {
              1 => videosProvider,
              2 => imagesProvider,
              _ => provider,
            },
            builder: (_, __) => button,
          );
        },
      ),
    );
  }

  @override
  AssetPickerAppBar appBar(BuildContext context) {
    final AssetPickerAppBar appBar = AssetPickerAppBar(
      backgroundColor: theme.appBarTheme.backgroundColor,
      centerTitle: true,
      title: Semantics(
        onTapHint: textDelegate.sActionSwitchPathLabel,
        child: pathEntitySelector(context),
      ),
      leading: backButton(context),
      blurRadius: isAppleOS(context) ? appleOSBlurRadius : 0,
      bottom: TabBar(
        controller: _tabController,
        tabs: <Tab>[
          Tab(text: context.l10n.customPickerMultiTabTab1),
          Tab(text: context.l10n.customPickerMultiTabTab2),
          Tab(text: context.l10n.customPickerMultiTabTab3),
        ],
      ),
    );
    appBarPreferredSize ??= appBar.preferredSize;
    return appBar;
  }

  @override
  Widget appleOSLayout(BuildContext context) {
    Widget layout(BuildContext context) {
      return Stack(
        children: <Widget>[
          TabBarView(
            controller: _tabController,
            children: <Widget>[
              ChangeNotifierProvider<DefaultAssetPickerProvider>.value(
                value: provider,
                builder: (BuildContext context, _) => _buildGrid(context),
              ),
              ChangeNotifierProvider<DefaultAssetPickerProvider>.value(
                value: videosProvider,
                builder: (BuildContext context, _) => _buildGrid(context),
              ),
              ChangeNotifierProvider<DefaultAssetPickerProvider>.value(
                value: imagesProvider,
                builder: (BuildContext context, _) => _buildGrid(context),
              ),
            ],
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
  Widget androidLayout(BuildContext context) {
    return AssetPickerAppBarWrapper(
      appBar: appBar(context),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          ChangeNotifierProvider<DefaultAssetPickerProvider>.value(
            value: provider,
            builder: (BuildContext context, _) => _buildGrid(context),
          ),
          ChangeNotifierProvider<DefaultAssetPickerProvider>.value(
            value: videosProvider,
            builder: (BuildContext context, _) => _buildGrid(context),
          ),
          ChangeNotifierProvider<DefaultAssetPickerProvider>.value(
            value: imagesProvider,
            builder: (BuildContext context, _) => _buildGrid(context),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid(BuildContext context) {
    return Consumer<DefaultAssetPickerProvider>(
      builder: (BuildContext context, DefaultAssetPickerProvider p, __) {
        final bool shouldDisplayAssets =
            p.hasAssetsToDisplay || shouldBuildSpecialItem;
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: shouldDisplayAssets
              ? Stack(
                  children: <Widget>[
                    RepaintBoundary(
                      child: Column(
                        children: <Widget>[
                          Expanded(child: assetsGridBuilder(context)),
                          if (isPreviewEnabled) bottomActionBar(context),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlayStyle,
      child: Theme(
        data: theme,
        child: Builder(
          builder: (BuildContext context) => Material(
            color: theme.canvasColor,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                if (isAppleOS(context))
                  appleOSLayout(context)
                else
                  androidLayout(context),
                if (Platform.isIOS) iOSPermissionOverlay(context),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
