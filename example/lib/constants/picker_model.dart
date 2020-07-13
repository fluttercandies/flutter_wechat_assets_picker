///
/// [Author] Alex (https://github.com/Alex525)
/// [Date] 2020-05-30 20:56
///
import 'package:flutter/material.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../main.dart';

class PickMethodModel {
  const PickMethodModel({
    this.icon,
    this.name,
    this.description,
    this.method,
  });

  final String icon;
  final String name;
  final String description;
  final Future<List<AssetEntity>> Function(BuildContext, List<AssetEntity>)
      method;

  static PickMethodModel common = PickMethodModel(
    icon: '🖼️',
    name: 'Image picker',
    description: 'Simply pick image from device.',
    method: (
      BuildContext context,
      List<AssetEntity> assets,
    ) async {
      return await AssetPicker.pickAssets(
        context,
        maxAssets: 9,
        pathThumbSize: 84,
        gridCount: 4,
        selectedAssets: assets,
        themeColor: themeColor,
        requestType: RequestType.image,
      );
    },
  );
}
