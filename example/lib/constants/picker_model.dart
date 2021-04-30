///
/// [Author] Alex (https://github.com/Alex525)
/// [Date] 2020-05-30 20:56
///
import 'package:flutter/material.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

class PickMethodModel {
  const PickMethodModel({
    required this.icon,
    required this.name,
    required this.description,
    required this.method,
  });

  factory PickMethodModel.image(int maxAssetsCount) {
    return PickMethodModel(
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

  factory PickMethodModel.video(int maxAssetsCount) {
    return PickMethodModel(
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

  factory PickMethodModel.audio(int maxAssetsCount) {
    return PickMethodModel(
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

  factory PickMethodModel.camera({
    required int maxAssetsCount,
    required Function(BuildContext, AssetEntity) handleResult,
  }) {
    return PickMethodModel(
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

  factory PickMethodModel.common(int maxAssetsCount) {
    return PickMethodModel(
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

  factory PickMethodModel.threeItemsGrid(int maxAssetsCount) {
    return PickMethodModel(
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

  factory PickMethodModel.customFilterOptions(int maxAssetsCount) {
    return PickMethodModel(
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

  factory PickMethodModel.prependItem(int maxAssetsCount) {
    return PickMethodModel(
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
            return const Center(child: Text('Custom Widget'));
          },
        );
      },
    );
  }

  factory PickMethodModel.noPreview(int maxAssetsCount) {
    return PickMethodModel(
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
    BuildContext,
    List<AssetEntity>,
  ) method;
}
