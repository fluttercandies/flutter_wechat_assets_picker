///
/// [Author] Alex (https://github.com/Alex525)
/// [Date] 2020-05-31 20:21
///
import 'package:flutter/material.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

import '../constants/extensions.dart';
import '../constants/picker_model.dart';
import '../main.dart';

class MultiAssetsPage extends StatefulWidget {
  @override
  _MultiAssetsPageState createState() => _MultiAssetsPageState();
}

class _MultiAssetsPageState extends State<MultiAssetsPage> {
  final int maxAssetsCount = 9;

  List<AssetEntity> assets = <AssetEntity>[];

  bool isDisplayingDetail = true;

  int get assetsLength => assets.length;

  ThemeData get currentTheme => context.themeData;

  List<PickMethodModel> get pickMethods => <PickMethodModel>[
        PickMethodModel(
          icon: '🖼️',
          name: 'Image picker',
          description: 'Only pick image from device.',
          method: (
            BuildContext context,
            List<AssetEntity> assets,
          ) async {
            return await AssetPicker.pickAssets(
              context,
              maxAssets: maxAssetsCount,
              selectedAssets: assets,
              requestType: RequestType.image,
            );
          },
        ),
        PickMethodModel(
          icon: '🎞',
          name: 'Video picker',
          description: 'Only pick video from device.',
          method: (
            BuildContext context,
            List<AssetEntity> assets,
          ) async {
            return await AssetPicker.pickAssets(
              context,
              maxAssets: maxAssetsCount,
              selectedAssets: assets,
              requestType: RequestType.video,
            );
          },
        ),
        PickMethodModel(
          icon: '🎶',
          name: 'Audio picker',
          description: 'Only pick audio from device.',
          method: (
            BuildContext context,
            List<AssetEntity> assets,
          ) async {
            return await AssetPicker.pickAssets(
              context,
              maxAssets: maxAssetsCount,
              selectedAssets: assets,
              requestType: RequestType.audio,
            );
          },
        ),
        PickMethodModel(
          icon: '📷',
          name: 'Pick from camera',
          description: 'Allow pick an asset through camera.',
          method: (
            BuildContext context,
            List<AssetEntity> assets,
          ) async {
            return await AssetPicker.pickAssets(
              context,
              maxAssets: maxAssetsCount,
              selectedAssets: assets,
              requestType: RequestType.common,
              specialItemPosition: SpecialItemPosition.prepend,
              specialItemBuilder: (BuildContext context) {
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () async {
                    final AssetEntity? result =
                        await CameraPicker.pickFromCamera(
                      context,
                      enableRecording: true,
                    );
                    if (result != null) {
                      Navigator.of(context)
                          .pop(<AssetEntity>[...assets, result]);
                    }
                  },
                  child: const Center(
                    child: Icon(Icons.camera_enhance, size: 42.0),
                  ),
                );
              },
            );
          },
        ),
        PickMethodModel(
          icon: '📹',
          name: 'Common picker',
          description: 'Pick images and videos.',
          method: (
            BuildContext context,
            List<AssetEntity> assets,
          ) async {
            return await AssetPicker.pickAssets(
              context,
              maxAssets: maxAssetsCount,
              selectedAssets: assets,
              requestType: RequestType.common,
            );
          },
        ),
        PickMethodModel(
          icon: '🔲',
          name: '3 items grid',
          description: 'Picker will served as 3 items on cross axis. '
              '(pageSize must be a multiple of gridCount)',
          method: (
            BuildContext context,
            List<AssetEntity> assets,
          ) async {
            return await AssetPicker.pickAssets(
              context,
              gridCount: 3,
              pageSize: 120,
              maxAssets: maxAssetsCount,
              selectedAssets: assets,
              requestType: RequestType.common,
            );
          },
        ),
        PickMethodModel(
          icon: '⏳',
          name: 'Custom filter options',
          description: 'Add filter options for the picker.',
          method: (
            BuildContext context,
            List<AssetEntity> assets,
          ) async {
            return await AssetPicker.pickAssets(
              context,
              maxAssets: maxAssetsCount,
              selectedAssets: assets,
              requestType: RequestType.video,
              filterOptions: FilterOptionGroup()
                ..setOption(
                  AssetType.video,
                  const FilterOption(
                    durationConstraint: DurationConstraint(
                      max: Duration(minutes: 1),
                    ),
                  ),
                ),
            );
          },
        ),
        PickMethodModel(
          icon: '➕',
          name: 'Prepend special item',
          description: 'A special item will prepend to the assets grid.',
          method: (
            BuildContext context,
            List<AssetEntity> assets,
          ) async {
            return await AssetPicker.pickAssets(
              context,
              maxAssets: maxAssetsCount,
              selectedAssets: assets,
              requestType: RequestType.common,
              specialItemPosition: SpecialItemPosition.append,
              specialItemBuilder: (BuildContext context) {
                return const Center(child: Text('Custom Widget'));
              },
            );
          },
        ),
        PickMethodModel(
          icon: '🎚',
          name: 'Custom image preview thumb size',
          description:
              'You can reduce the thumb size to get more quickly load speed.',
          method: (
            BuildContext context,
            List<AssetEntity> assets,
          ) async {
            return await AssetPicker.pickAssets(
              context,
              maxAssets: maxAssetsCount,
              selectedAssets: assets,
              requestType: RequestType.image,
              previewThumbSize: const <int>[300, 300],
            );
          },
        ),
      ];

  Future<void> selectAssets(PickMethodModel model) async {
    final List<AssetEntity>? result = await model.method(context, assets);
    if (result != null) {
      assets = List<AssetEntity>.from(result);
      if (mounted) {
        setState(() {});
      }
    }
  }

  void removeAsset(int index) {
    setState(() {
      assets.removeAt(index);
      if (assets.isEmpty) {
        isDisplayingDetail = false;
      }
    });
  }

  Widget methodItemBuilder(BuildContext _, int index) {
    final PickMethodModel model = pickMethods[index];
    return InkWell(
      onTap: () => selectAssets(model),
      child: Container(
        height: 72.0,
        padding: const EdgeInsets.symmetric(
          horizontal: 30.0,
          vertical: 10.0,
        ),
        child: Row(
          children: <Widget>[
            AspectRatio(
              aspectRatio: 1.0,
              child: Container(
                margin: const EdgeInsets.all(2.0),
                child: Center(
                  child: Text(
                    model.icon,
                    style: const TextStyle(fontSize: 24.0),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    model.name,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    model.description,
                    style: context.themeData.textTheme.caption,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget get methodListView => Expanded(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            itemCount: pickMethods.length,
            itemBuilder: methodItemBuilder,
          ),
        ),
      );

  Widget _assetWidgetBuilder(AssetEntity asset) {
    Widget widget;
    switch (asset.type) {
      case AssetType.audio:
        widget = _audioAssetWidget(asset);
        break;
      case AssetType.video:
        widget = _videoAssetWidget(asset);
        break;
      case AssetType.image:
      case AssetType.other:
        widget = _imageAssetWidget(asset);
        break;
    }
    return widget;
  }

  Widget _audioAssetWidget(AssetEntity asset) {
    return ColoredBox(
      color: context.themeData.dividerColor,
      child: Stack(
        children: <Widget>[
          AnimatedPositioned(
            duration: kThemeAnimationDuration,
            top: 0.0,
            left: 0.0,
            right: 0.0,
            bottom: isDisplayingDetail ? 20.0 : 0.0,
            child: Center(
              child: Icon(
                Icons.audiotrack,
                size: isDisplayingDetail ? 24.0 : 16.0,
              ),
            ),
          ),
          AnimatedPositioned(
            duration: kThemeAnimationDuration,
            left: 0.0,
            right: 0.0,
            bottom: isDisplayingDetail ? 0.0 : -20.0,
            height: 20.0,
            child: Text(
              asset.title ?? '',
              style: const TextStyle(height: 1.0, fontSize: 10.0),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _imageAssetWidget(AssetEntity asset) {
    return Image(
      image: AssetEntityImageProvider(asset, isOriginal: false),
      fit: BoxFit.cover,
    );
  }

  Widget _videoAssetWidget(AssetEntity asset) {
    return Stack(
      children: <Widget>[
        Positioned.fill(child: _imageAssetWidget(asset)),
        ColoredBox(
          color: context.themeData.dividerColor.withOpacity(0.3),
          child: Center(
            child: Icon(
              Icons.video_library,
              color: Colors.white,
              size: isDisplayingDetail ? 24.0 : 16.0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _selectedAssetWidget(int index) {
    final AssetEntity asset = assets.elementAt(index);
    return GestureDetector(
      onTap: isDisplayingDetail
          ? () async {
              final List<AssetEntity>? result =
                  await AssetPickerViewer.pushToViewer(
                context,
                currentIndex: index,
                previewAssets: assets,
                themeData: AssetPicker.themeData(themeColor),
              );
              if (result != null && result != assets) {
                assets = List<AssetEntity>.from(result);
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

  Widget _selectedAssetDeleteButton(int index) {
    return GestureDetector(
      onTap: () => removeAsset(index),
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

  Widget get selectedAssetsWidget => AnimatedContainer(
        duration: kThemeChangeDuration,
        curve: Curves.easeInOut,
        height: assets.isNotEmpty
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
                  if (assets.isNotEmpty) {
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
                        '${assets.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          height: 1.0,
                        ),
                      ),
                    ),
                    if (assets.isNotEmpty)
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

  Widget get selectedAssetsListView => Expanded(
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          scrollDirection: Axis.horizontal,
          itemCount: assetsLength,
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
                    AnimatedPositioned(
                      duration: kThemeAnimationDuration,
                      top: isDisplayingDetail ? 6.0 : -30.0,
                      right: isDisplayingDetail ? 6.0 : -30.0,
                      child: _selectedAssetDeleteButton(index),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        methodListView,
        selectedAssetsWidget,
      ],
    );
  }
}
