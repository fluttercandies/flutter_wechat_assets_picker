// Copyright 2019 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by an Apache license that can be found
// in the LICENSE file.

import 'package:flutter/widgets.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart'
    show
        AssetEntity,
        DefaultAssetPickerProvider,
        DefaultAssetPickerBuilderDelegate;

import '../constants/extensions.dart';
import '../constants/picker_method.dart';
import '../widgets/method_list_view.dart';
import '../widgets/selected_assets_list_view.dart';

@optionalTypeArgs
mixin ExamplePageMixin<T extends StatefulWidget> on State<T> {
  final ValueNotifier<bool> isDisplayingDetail = ValueNotifier<bool>(true);

  @override
  void dispose() {
    isDisplayingDetail.dispose();
    super.dispose();
  }

  int get maxAssetsCount;

  List<AssetEntity> assets = <AssetEntity>[];

  int get assetsLength => assets.length;

  List<PickMethod> pickMethods(BuildContext context);

  String get noticeText;

  /// These fields are for the keep scroll position feature.
  late DefaultAssetPickerProvider keepScrollProvider =
      DefaultAssetPickerProvider();
  DefaultAssetPickerBuilderDelegate? keepScrollDelegate;

  Future<void> selectAssets(PickMethod model) async {
    final List<AssetEntity>? result = await model.method(context, assets);
    if (result != null) {
      assets = result.toList();
      if (mounted) {
        setState(() {});
      }
    }
  }

  void removeAsset(int index) {
    assets.removeAt(index);
    if (assets.isEmpty) {
      isDisplayingDetail.value = false;
    }
    setState(() {});
  }

  void onResult(List<AssetEntity>? result) {
    if (result != null && result != assets) {
      assets = result.toList();
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  @mustCallSuper
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(context.l10n.pickMethodNotice(noticeText)),
        ),
        Expanded(
          child: MethodListView(
            pickMethods: pickMethods(context),
            onSelectMethod: selectAssets,
          ),
        ),
        if (assets.isNotEmpty)
          SelectedAssetsListView(
            assets: assets,
            isDisplayingDetail: isDisplayingDetail,
            onResult: onResult,
            onRemoveAsset: removeAsset,
          ),
      ],
    );
  }
}
