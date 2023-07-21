// Copyright 2019 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by an Apache license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart'
    show AssetEntity, AssetPicker, AssetPickerViewer;
import 'package:wechat_assets_picker_demo/constants/extensions.dart';

import '../main.dart' show themeColor;
import 'asset_widget_builder.dart';

class SelectedAssetsListView extends StatelessWidget {
  const SelectedAssetsListView({
    super.key,
    required this.assets,
    required this.isDisplayingDetail,
    required this.onResult,
    required this.onRemoveAsset,
  });

  final List<AssetEntity> assets;
  final ValueNotifier<bool> isDisplayingDetail;
  final void Function(List<AssetEntity>? result) onResult;
  final void Function(int index) onRemoveAsset;

  Widget _selectedAssetWidget(BuildContext context, int index) {
    final AssetEntity asset = assets.elementAt(index);
    return ValueListenableBuilder<bool>(
      valueListenable: isDisplayingDetail,
      builder: (_, bool value, __) => GestureDetector(
        onTap: () async {
          if (value) {
            final List<AssetEntity>? result =
                await AssetPickerViewer.pushToViewer(
              context,
              currentIndex: index,
              previewAssets: assets,
              themeData: AssetPicker.themeData(themeColor),
            );
            onResult(result);
          }
        },
        child: RepaintBoundary(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: AssetWidgetBuilder(
              entity: asset,
              isDisplayingDetail: value,
            ),
          ),
        ),
      ),
    );
  }

  Widget _selectedAssetDeleteButton(BuildContext context, int index) {
    return GestureDetector(
      onTap: () => onRemoveAsset(index),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          color: Theme.of(context).canvasColor.withOpacity(0.5),
        ),
        child: const Icon(Icons.close, size: 18.0),
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
        itemCount: assets.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 16.0,
            ),
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Stack(
                children: <Widget>[
                  Positioned.fill(child: _selectedAssetWidget(context, index)),
                  ValueListenableBuilder<bool>(
                    valueListenable: isDisplayingDetail,
                    builder: (_, bool value, __) => AnimatedPositioned(
                      duration: kThemeAnimationDuration,
                      top: value ? 6.0 : -30.0,
                      right: value ? 6.0 : -30.0,
                      child: _selectedAssetDeleteButton(context, index),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isDisplayingDetail,
      builder: (_, bool value, __) => AnimatedContainer(
        duration: kThemeChangeDuration,
        curve: Curves.easeInOut,
        height: assets.isNotEmpty
            ? value
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
                    isDisplayingDetail.value = !isDisplayingDetail.value;
                  }
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(context.l10n.selectedAssetsText),
                    if (assets.isNotEmpty)
                      Padding(
                        padding: const EdgeInsetsDirectional.only(start: 10.0),
                        child: Icon(
                          value ? Icons.arrow_downward : Icons.arrow_upward,
                          size: 18.0,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            selectedAssetsListView(context),
          ],
        ),
      ),
    );
  }
}
