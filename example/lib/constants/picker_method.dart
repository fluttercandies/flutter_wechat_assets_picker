///
/// [Author] Alex (https://github.com/Alex525)
/// [Date] 2020-05-30 20:56
///
import 'package:flutter/material.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

class PickMethod {
  const PickMethod({
    required this.icon,
    required this.name,
    required this.description,
    required this.method,
  });

  factory PickMethod.image(int maxAssetsCount) {
    return PickMethod(
      icon: '🖼️',
      name: 'Image picker',
      description: 'Only pick image from device.',
      method: (BuildContext context, List<AssetEntity> assets) {
        return AssetPicker.pickAssets(
          context,
          maxAssets: maxAssetsCount,
          selectedAssets: assets,
          requestType: RequestType.image,
        );
      },
    );
  }

  factory PickMethod.video(int maxAssetsCount) {
    return PickMethod(
      icon: '🎞',
      name: 'Video picker',
      description: 'Only pick video from device.',
      method: (BuildContext context, List<AssetEntity> assets) {
        return AssetPicker.pickAssets(
          context,
          maxAssets: maxAssetsCount,
          selectedAssets: assets,
          requestType: RequestType.video,
        );
      },
    );
  }

  factory PickMethod.audio(int maxAssetsCount) {
    return PickMethod(
      icon: '🎶',
      name: 'Audio picker',
      description: 'Only pick audio from device.',
      method: (BuildContext context, List<AssetEntity> assets) {
        return AssetPicker.pickAssets(
          context,
          maxAssets: maxAssetsCount,
          selectedAssets: assets,
          requestType: RequestType.audio,
        );
      },
    );
  }

  factory PickMethod.camera({
    required int maxAssetsCount,
    required Function(BuildContext, AssetEntity) handleResult,
  }) {
    return PickMethod(
      icon: '📷',
      name: 'Pick from camera',
      description: 'Allow pick an asset through camera.',
      method: (BuildContext context, List<AssetEntity> assets) {
        return AssetPicker.pickAssets(
          context,
          maxAssets: maxAssetsCount,
          selectedAssets: assets,
          requestType: RequestType.common,
          specialItemPosition: SpecialItemPosition.prepend,
          specialItemBuilder: (BuildContext context) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () async {
                final AssetEntity? result = await CameraPicker.pickFromCamera(
                  context,
                  enableRecording: true,
                );
                if (result != null) {
                  handleResult(context, result);
                }
              },
              child: const Center(
                child: Icon(Icons.camera_enhance, size: 42.0),
              ),
            );
          },
        );
      },
    );
  }

  factory PickMethod.cameraAndStay({required int maxAssetsCount}) {
    return PickMethod(
      icon: '📸',
      name: 'Pick from camera and stay',
      description: 'Take a photo or video with the camera picker, '
          'select the result and stay in the entities list.',
      method: (BuildContext context, List<AssetEntity> assets) {
        return AssetPicker.pickAssets(
          context,
          maxAssets: maxAssetsCount,
          selectedAssets: assets,
          requestType: RequestType.common,
          specialItemPosition: SpecialItemPosition.prepend,
          specialItemBuilder: (BuildContext context) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () async {
                final AssetEntity? result = await CameraPicker.pickFromCamera(
                  context,
                  enableRecording: true,
                );
                if (result != null) {
                  final AssetPicker<AssetEntity, AssetPathEntity> picker =
                      context.findAncestorWidgetOfExactType()!;
                  final DefaultAssetPickerProvider p =
                      picker.builder.provider as DefaultAssetPickerProvider;
                  await p.currentPathEntity!.refreshPathProperties();
                  await p.switchPath(p.currentPathEntity!);
                  p.selectAsset(result);
                }
              },
              child: const Center(
                child: Icon(Icons.camera_enhance, size: 42.0),
              ),
            );
          },
        );
      },
    );
  }

  factory PickMethod.common(int maxAssetsCount) {
    return PickMethod(
      icon: '📹',
      name: 'Common picker',
      description: 'Pick images and videos.',
      method: (BuildContext context, List<AssetEntity> assets) {
        return AssetPicker.pickAssets(
          context,
          maxAssets: maxAssetsCount,
          selectedAssets: assets,
          requestType: RequestType.common,
        );
      },
    );
  }

  factory PickMethod.threeItemsGrid(int maxAssetsCount) {
    return PickMethod(
      icon: '🔲',
      name: '3 items grid',
      description: 'Picker will served as 3 items on cross axis. '
          '(pageSize must be a multiple of gridCount)',
      method: (BuildContext context, List<AssetEntity> assets) {
        return AssetPicker.pickAssets(
          context,
          gridCount: 3,
          pageSize: 120,
          maxAssets: maxAssetsCount,
          selectedAssets: assets,
          requestType: RequestType.all,
        );
      },
    );
  }

  factory PickMethod.customFilterOptions(int maxAssetsCount) {
    return PickMethod(
      icon: '⏳',
      name: 'Custom filter options',
      description: 'Add filter options for the picker.',
      method: (
        BuildContext context,
        List<AssetEntity> assets,
      ) {
        return AssetPicker.pickAssets(
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
    );
  }

  factory PickMethod.prependItem(int maxAssetsCount) {
    return PickMethod(
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
          specialItemPosition: SpecialItemPosition.prepend,
          specialItemBuilder: (BuildContext context) {
            return const Center(
              child: Text('Custom Widget', textAlign: TextAlign.center),
            );
          },
        );
      },
    );
  }

  factory PickMethod.noPreview(int maxAssetsCount) {
    return PickMethod(
      icon: '👁️‍🗨️',
      name: 'No preview',
      description: 'Pick assets like the WhatsApp/MegaTok pattern.',
      method: (
        BuildContext context,
        List<AssetEntity> assets,
      ) async {
        return await AssetPicker.pickAssets(
          context,
          maxAssets: maxAssetsCount,
          selectedAssets: assets,
          requestType: RequestType.common,
          specialPickerType: SpecialPickerType.noPreview,
        );
      },
    );
  }

  final String icon;
  final String name;
  final String description;
  final Future<List<AssetEntity>?> Function(
    BuildContext context,
    List<AssetEntity> selectedAssets,
  ) method;
}
