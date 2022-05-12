// Copyright 2019 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by an Apache license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart'
    show AssetEntity;

import '../constants/page_mixin.dart';
import '../constants/picker_method.dart';

class SingleAssetPage extends StatefulWidget {
  const SingleAssetPage({super.key});

  @override
  State<SingleAssetPage> createState() => _SingleAssetPageState();
}

class _SingleAssetPageState extends State<SingleAssetPage>
    with AutomaticKeepAliveClientMixin, ExamplePageMixin {
  @override
  int get maxAssetsCount => 1;

  /// Check each method's source code for more details.
  @override
  List<PickMethod> get pickMethods {
    return <PickMethod>[
      PickMethod.common(maxAssetsCount),
      PickMethod.image(maxAssetsCount),
      PickMethod.video(maxAssetsCount),
      PickMethod.audio(maxAssetsCount),
      PickMethod.camera(
        maxAssetsCount: maxAssetsCount,
        handleResult: (BuildContext context, AssetEntity result) =>
            Navigator.of(context).pop(<AssetEntity>[result]),
      ),
      PickMethod.cameraAndStay(maxAssetsCount: maxAssetsCount),
      PickMethod.changeLanguages(maxAssetsCount),
      PickMethod.threeItemsGrid(maxAssetsCount),
      PickMethod.prependItem(maxAssetsCount),
      PickMethod.customFilterOptions(maxAssetsCount),
      PickMethod.preventGIFPicked(maxAssetsCount),
      PickMethod.noPreview(maxAssetsCount),
      PickMethod.customizableTheme(maxAssetsCount),
    ];
  }

  @override
  bool get wantKeepAlive => true;
}
