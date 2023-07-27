// Copyright 2019 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by an Apache license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart'
    show AssetEntity;

import '../constants/picker_method.dart';
import 'page_mixin.dart';

class SingleAssetPage extends StatefulWidget {
  const SingleAssetPage({super.key});

  @override
  State<SingleAssetPage> createState() => _SingleAssetPageState();
}

class _SingleAssetPageState extends State<SingleAssetPage>
    with AutomaticKeepAliveClientMixin, ExamplePageMixin {
  @override
  String get noticeText => 'lib/pages/single_assets_page.dart';

  @override
  int get maxAssetsCount => 1;

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
            Navigator.of(context).pop(<AssetEntity>[result]),
      ),
      PickMethod.cameraAndStay(context, maxAssetsCount),
      PickMethod.changeLanguages(context, maxAssetsCount),
      PickMethod.threeItemsGrid(context, maxAssetsCount),
      PickMethod.prependItem(context, maxAssetsCount),
      PickMethod.customFilterOptions(context, maxAssetsCount),
      PickMethod.preventGIFPicked(context, maxAssetsCount),
      PickMethod.noPreview(context, maxAssetsCount),
      PickMethod.customizableTheme(context, maxAssetsCount),
      PickMethod.pathNameBuilder(context, maxAssetsCount),
    ];
  }

  @override
  bool get wantKeepAlive => true;
}
