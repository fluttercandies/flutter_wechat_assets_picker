// Copyright 2019 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by an Apache license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../constants/extensions.dart';
import '../constants/picker_method.dart';
import 'page_mixin.dart';

class MultiAssetsPage extends StatefulWidget {
  const MultiAssetsPage({super.key});

  @override
  State<MultiAssetsPage> createState() => _MultiAssetsPageState();
}

class _MultiAssetsPageState extends State<MultiAssetsPage>
    with AutomaticKeepAliveClientMixin, ExamplePageMixin {
  @override
  String get noticeText => 'lib/pages/multi_assets_page.dart';

  @override
  int get maxAssetsCount => 9;

  /// Check each method's source code for more details.
  @override
  List<PickMethod> pickMethods(BuildContext context) {
    return <PickMethod>[
      PickMethod.common(context, maxAssetsCount),
      PickMethod.image(context, maxAssetsCount),
      PickMethod.video(context, maxAssetsCount),
      PickMethod.audio(context, maxAssetsCount),
      PickMethod.camera(
        context: context,
        maxAssetsCount: maxAssetsCount,
        handleResult: (BuildContext context, AssetEntity result) =>
            Navigator.of(context).pop(<AssetEntity>[...assets, result]),
      ),
      PickMethod.cameraAndStay(context, maxAssetsCount),
      PickMethod.changeLanguages(context, maxAssetsCount),
      PickMethod.threeItemsGrid(context, maxAssetsCount),
      PickMethod.prependItem(context, maxAssetsCount),
      PickMethod(
        icon: '🎭',
        name: context.l10n.pickMethodWeChatMomentName,
        description: context.l10n.pickMethodWeChatMomentDescription,
        method: (BuildContext context, List<AssetEntity> assets) {
          return AssetPicker.pickAssets(
            context,
            pickerConfig: AssetPickerConfig(
              maxAssets: maxAssetsCount,
              specialPickerType: SpecialPickerType.wechatMoment,
            ),
          );
        },
      ),
      PickMethod.noPreview(context, maxAssetsCount),
      PickMethod.customizableTheme(context, maxAssetsCount),
      PickMethod.pathNameBuilder(context, maxAssetsCount),
      PickMethod.customFilterOptions(context, maxAssetsCount),
      PickMethod.preventGIFPicked(context, maxAssetsCount),
      PickMethod.keepScrollOffset(
        context: context,
        delegate: () => keepScrollDelegate!,
        onPermission: (PermissionState state) {
          keepScrollDelegate ??= DefaultAssetPickerBuilderDelegate(
            provider: keepScrollProvider,
            initialPermission: state,
            keepScrollOffset: true,
          );
        },
        onLongPress: () {
          keepScrollProvider.dispose();
          keepScrollProvider = DefaultAssetPickerProvider();
          keepScrollDelegate?.dispose();
          keepScrollDelegate = null;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Resources have been released')),
          );
        },
      ),
      PickMethod(
        icon: '🎚',
        name: context.l10n.pickMethodCustomImagePreviewThumbSizeName,
        description:
            context.l10n.pickMethodCustomImagePreviewThumbSizeDescription,
        method: (BuildContext context, List<AssetEntity> assets) {
          return AssetPicker.pickAssets(
            context,
            pickerConfig: AssetPickerConfig(
              maxAssets: maxAssetsCount,
              selectedAssets: assets,
              requestType: RequestType.image,
              gridThumbnailSize: const ThumbnailSize.square(80),
              previewThumbnailSize: const ThumbnailSize.square(150),
            ),
          );
        },
      ),
    ];
  }

  @override
  bool get wantKeepAlive => true;
}
