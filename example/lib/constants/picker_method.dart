// Copyright 2019 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by an Apache license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

Future<AssetEntity?> _pickFromCamera(BuildContext c) {
  return CameraPicker.pickFromCamera(
    c,
    pickerConfig: const CameraPickerConfig(enableRecording: true),
  );
}

/// Define a regular pick method.
class PickMethod {
  const PickMethod({
    required this.icon,
    required this.name,
    required this.description,
    required this.method,
    this.onLongPress,
  });

  factory PickMethod.image(int maxAssetsCount) {
    return PickMethod(
      icon: '🖼️',
      name: 'Image picker',
      description: 'Only pick image from device.',
      method: (BuildContext context, List<AssetEntity> assets) {
        return AssetPicker.pickAssets(
          context,
          pickerConfig: AssetPickerConfig(
            maxAssets: maxAssetsCount,
            selectedAssets: assets,
            requestType: RequestType.image,
          ),
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
          pickerConfig: AssetPickerConfig(
            maxAssets: maxAssetsCount,
            selectedAssets: assets,
            requestType: RequestType.video,
          ),
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
          pickerConfig: AssetPickerConfig(
            maxAssets: maxAssetsCount,
            selectedAssets: assets,
            requestType: RequestType.audio,
          ),
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
        const AssetPickerTextDelegate textDelegate = AssetPickerTextDelegate();
        return AssetPicker.pickAssets(
          context,
          pickerConfig: AssetPickerConfig(
            maxAssets: maxAssetsCount,
            selectedAssets: assets,
            specialItemPosition: SpecialItemPosition.prepend,
            specialItemBuilder: (
              BuildContext context,
              AssetPathEntity? path,
              int length,
            ) {
              if (path?.isAll != true) {
                return null;
              }
              return Semantics(
                label: textDelegate.sActionUseCameraHint,
                button: true,
                onTapHint: textDelegate.sActionUseCameraHint,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () async {
                    Feedback.forTap(context);
                    final AssetEntity? result = await _pickFromCamera(context);
                    if (result != null) {
                      handleResult(context, result);
                    }
                  },
                  child: const Center(
                    child: Icon(Icons.camera_enhance, size: 42.0),
                  ),
                ),
              );
            },
          ),
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
        const AssetPickerTextDelegate textDelegate = AssetPickerTextDelegate();
        return AssetPicker.pickAssets(
          context,
          pickerConfig: AssetPickerConfig(
            maxAssets: maxAssetsCount,
            selectedAssets: assets,
            specialItemPosition: SpecialItemPosition.prepend,
            specialItemBuilder: (
              BuildContext context,
              AssetPathEntity? path,
              int length,
            ) {
              if (path?.isAll != true) {
                return null;
              }
              return Semantics(
                label: textDelegate.sActionUseCameraHint,
                button: true,
                onTapHint: textDelegate.sActionUseCameraHint,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () async {
                    final AssetEntity? result = await _pickFromCamera(context);
                    if (result == null) {
                      return;
                    }
                    final AssetPicker<AssetEntity, AssetPathEntity> picker =
                        context.findAncestorWidgetOfExactType()!;
                    final DefaultAssetPickerBuilderDelegate builder =
                        picker.builder as DefaultAssetPickerBuilderDelegate;
                    final DefaultAssetPickerProvider p = builder.provider;
                    await p.switchPath(
                      PathWrapper<AssetPathEntity>(
                        path:
                            await p.currentPath!.path.obtainForNewProperties(),
                      ),
                    );
                    p.selectAsset(result);
                  },
                  child: const Center(
                    child: Icon(Icons.camera_enhance, size: 42.0),
                  ),
                ),
              );
            },
          ),
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
          pickerConfig: AssetPickerConfig(
            maxAssets: maxAssetsCount,
            selectedAssets: assets,
          ),
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
          pickerConfig: AssetPickerConfig(
            gridCount: 3,
            pageSize: 120,
            maxAssets: maxAssetsCount,
            selectedAssets: assets,
            requestType: RequestType.all,
          ),
        );
      },
    );
  }

  factory PickMethod.customFilterOptions(int maxAssetsCount) {
    return PickMethod(
      icon: '⏳',
      name: 'Custom filter options',
      description: 'Add filter options for the picker.',
      method: (BuildContext context, List<AssetEntity> assets) {
        return AssetPicker.pickAssets(
          context,
          pickerConfig: AssetPickerConfig(
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
      method: (BuildContext context, List<AssetEntity> assets) {
        return AssetPicker.pickAssets(
          context,
          pickerConfig: AssetPickerConfig(
            maxAssets: maxAssetsCount,
            selectedAssets: assets,
            specialItemPosition: SpecialItemPosition.prepend,
            specialItemBuilder: (
              BuildContext context,
              AssetPathEntity? path,
              int length,
            ) {
              return const Center(
                child: Text('Custom Widget', textAlign: TextAlign.center),
              );
            },
          ),
        );
      },
    );
  }

  factory PickMethod.noPreview(int maxAssetsCount) {
    return PickMethod(
      icon: '👁️‍🗨️',
      name: 'No preview',
      description: 'Pick assets like the WhatsApp/MegaTok pattern.',
      method: (BuildContext context, List<AssetEntity> assets) {
        return AssetPicker.pickAssets(
          context,
          pickerConfig: AssetPickerConfig(
            maxAssets: maxAssetsCount,
            selectedAssets: assets,
            specialPickerType: SpecialPickerType.noPreview,
          ),
        );
      },
    );
  }

  factory PickMethod.keepScrollOffset({
    required DefaultAssetPickerBuilderDelegate Function() delegate,
    required Function(PermissionState state) onPermission,
    GestureLongPressCallback? onLongPress,
  }) {
    return PickMethod(
      icon: '💾',
      name: 'Keep scroll offset',
      description: 'Pick assets from same scroll position.',
      method: (BuildContext context, List<AssetEntity> assets) async {
        final PermissionState ps = await PhotoManager.requestPermissionExtend();
        if (ps != PermissionState.authorized && ps != PermissionState.limited) {
          throw StateError('Permission state error with $ps.');
        }
        onPermission(ps);
        return AssetPicker.pickAssetsWithDelegate(
          context,
          delegate: delegate(),
        );
      },
      onLongPress: onLongPress,
    );
  }

  factory PickMethod.changeLanguages(int maxAssetsCount) {
    return PickMethod(
      icon: '🔤',
      name: 'Change Languages',
      description: 'Pass text delegates to change between languages. '
          '(e.g. EnglishTextDelegate)',
      method: (BuildContext context, List<AssetEntity> assets) {
        return AssetPicker.pickAssets(
          context,
          pickerConfig: AssetPickerConfig(
            maxAssets: maxAssetsCount,
            selectedAssets: assets,
            textDelegate: const EnglishAssetPickerTextDelegate(),
          ),
        );
      },
    );
  }

  factory PickMethod.preventGIFPicked(int maxAssetsCount) {
    return PickMethod(
      icon: '🈲',
      name: 'Prevent GIF being picked',
      description: 'Use selectPredicate to banned GIF picking when tapped.',
      method: (BuildContext context, List<AssetEntity> assets) {
        return AssetPicker.pickAssets(
          context,
          pickerConfig: AssetPickerConfig(
            maxAssets: maxAssetsCount,
            selectedAssets: assets,
            selectPredicate: (BuildContext c, AssetEntity a, bool isSelected) {
              debugPrint('Asset title: ${a.title}');
              return a.title?.endsWith('.gif') != true;
            },
          ),
        );
      },
    );
  }

  factory PickMethod.customizableTheme(int maxAssetsCount) {
    return PickMethod(
      icon: '🎨',
      name: 'Customizable theme',
      description: 'Picking assets with the light theme with different color.',
      method: (BuildContext context, List<AssetEntity> assets) {
        return AssetPicker.pickAssets(
          context,
          pickerConfig: AssetPickerConfig(
            maxAssets: maxAssetsCount,
            selectedAssets: assets,
            pickerTheme: AssetPicker.themeData(
              Colors.lightBlueAccent,
              light: true,
            ),
          ),
        );
      },
    );
  }

  factory PickMethod.pathNameBuilder(int maxAssetsCount) {
    return PickMethod(
      icon: '🈸',
      name: 'Path name builder',
      description: 'Add 🍭 after paths name.',
      method: (BuildContext context, List<AssetEntity> assets) {
        return AssetPicker.pickAssets(
          context,
          pickerConfig: AssetPickerConfig(
            maxAssets: maxAssetsCount,
            selectedAssets: assets,
            pathNameBuilder: (AssetPathEntity path) => '${path.name}🍭',
          ),
        );
      },
    );
  }

  final String icon;
  final String name;
  final String description;

  /// The core function that defines how to use the picker.
  final Future<List<AssetEntity>?> Function(
    BuildContext context,
    List<AssetEntity> selectedAssets,
  ) method;

  final GestureLongPressCallback? onLongPress;
}
