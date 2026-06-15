// Copyright 2019 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by an Apache license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import 'test_utils.dart';

void main() {
  group(AssetPickerTextDelegate, () {
    test('returns the default when available', () {
      expect(
        assetPickerTextDelegateFromLocale(null),
        equals(const AssetPickerTextDelegate()),
      );
      expect(
        assetPickerTextDelegateFromLocale(const Locale('zh')),
        equals(const AssetPickerTextDelegate()),
      );
      expect(
        assetPickerTextDelegateFromLocale(const Locale('zxx')),
        equals(const AssetPickerTextDelegate()),
      );
    });

    test('each delegate can be obtained by its locale definition', () {
      for (final delegate in assetPickerTextDelegates) {
        final locale = Locale.fromSubtags(
          languageCode: delegate.languageCode,
          scriptCode: delegate.scriptCode,
          countryCode: delegate.countryCode,
        );
        final matchedDelegate = assetPickerTextDelegateFromLocale(locale);
        expect(matchedDelegate, equals(delegate));
      }
    });
  });

  test('Sort paths correctly', () {
    final List<PathWrapper<AssetPathEntity>> paths =
        <PathWrapper<AssetPathEntity>>[
      PathWrapper<AssetPathEntity>(
        path: AssetPathEntity(id: 'id2', name: 'Screenshots'),
      ),
      PathWrapper<AssetPathEntity>(
        path: AssetPathEntity(id: 'id1', name: 'Camera'),
      ),
      PathWrapper<AssetPathEntity>(
        path: AssetPathEntity(id: 'id0', name: 'All', isAll: true),
      ),
    ];
    SortPathDelegate.common.sort(paths);
    expect(paths[0], (PathWrapper<AssetPathEntity> e) => e.path.isAll);
    expect(
      paths[1],
      (PathWrapper<AssetPathEntity> e) => e.path.name == 'Camera',
    );
    expect(
      paths[2],
      (PathWrapper<AssetPathEntity> e) => e.path.name == 'Screenshots',
    );
  });

  group(AssetPickerViewerBuilderDelegate, () {
    test('notifies the picker provider when selecting the last allowed asset',
        () {
      final DefaultAssetPickerProvider selectorProvider =
          DefaultAssetPickerProvider.forTest(maxAssets: 1);
      addTearDown(selectorProvider.dispose);
      int notificationCount = 0;
      selectorProvider.addListener(() {
        notificationCount++;
      });
      final AssetPickerViewerProvider<AssetEntity> viewerProvider =
          AssetPickerViewerProvider<AssetEntity>(
        selectorProvider.selectedAssets,
        maxAssets: selectorProvider.maxAssets,
      );
      addTearDown(viewerProvider.dispose);
      final DefaultAssetPickerViewerBuilderDelegate<
              AssetPickerViewerProvider<AssetEntity>,
              DefaultAssetPickerProvider> delegate =
          DefaultAssetPickerViewerBuilderDelegate<
              AssetPickerViewerProvider<AssetEntity>,
              DefaultAssetPickerProvider>(
        currentIndex: 0,
        previewAssets: <AssetEntity>[testAssetEntity],
        themeData: ThemeData(),
        provider: viewerProvider,
        selectedAssets: selectorProvider.selectedAssets,
        selectorProvider: selectorProvider,
        maxAssets: selectorProvider.maxAssets,
      );

      delegate.selectAsset(testAssetEntity);

      expect(selectorProvider.selectedAssets, <AssetEntity>[testAssetEntity]);
      expect(
        viewerProvider.currentlySelectedAssets,
        <AssetEntity>[testAssetEntity],
      );
      expect(notificationCount, 1);
    });

    test('does not add unselected assets beyond maxAssets', () {
      final AssetEntity extraAsset = AssetEntity(
        id: 'test-extra',
        typeInt: 0,
        width: 0,
        height: 0,
      );
      final List<AssetEntity> selectedAssets = <AssetEntity>[testAssetEntity];
      final AssetPickerViewerProvider<AssetEntity> viewerProvider =
          AssetPickerViewerProvider<AssetEntity>(
        selectedAssets,
        maxAssets: 1,
      );
      addTearDown(viewerProvider.dispose);
      final DefaultAssetPickerViewerBuilderDelegate<
              AssetPickerViewerProvider<AssetEntity>,
              DefaultAssetPickerProvider> delegate =
          DefaultAssetPickerViewerBuilderDelegate<
              AssetPickerViewerProvider<AssetEntity>,
              DefaultAssetPickerProvider>(
        currentIndex: 0,
        previewAssets: <AssetEntity>[testAssetEntity, extraAsset],
        themeData: ThemeData(),
        provider: viewerProvider,
        selectedAssets: selectedAssets,
        maxAssets: 1,
      );

      delegate.selectAsset(extraAsset);

      expect(selectedAssets, <AssetEntity>[testAssetEntity]);
      expect(
        viewerProvider.currentlySelectedAssets,
        <AssetEntity>[testAssetEntity],
      );
    });
  });
}
