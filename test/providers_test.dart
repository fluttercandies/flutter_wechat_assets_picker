// Copyright 2019 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by an Apache license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import 'test_utils.dart';

void main() async {
  PhotoManager.withPlugin(TestPhotoManagerPlugin());
  AssetPicker.setPickerDelegate(TestAssetPickerDelegate());

  group('AssetPickerProvider', () {
    testWidgets('disposed correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        defaultPickerTestApp(
          onButtonPressed: (BuildContext context) {
            AssetPicker.pickAssets(context);
          },
        ),
      );
      await tester.tap(defaultButtonFinder);
      await tester.pumpAndSettle();
      final Finder pickerFinder = find.byType(
        AssetPicker<AssetEntity, AssetPathEntity>,
      );
      final AssetPicker<AssetEntity, AssetPathEntity> picker = tester.widget(
        pickerFinder,
      );
      final DefaultAssetPickerProvider provider =
          (picker.builder as DefaultAssetPickerBuilderDelegate).provider;
      expect(provider, isA<DefaultAssetPickerProvider>());
      await tester.tap(find.widgetWithIcon(IconButton, Icons.close));
      await tester.pumpAndSettle();
      expect(
        () {
          provider.addListener(() {});
        },
        throwsA(isA<AssertionError>()),
      );
    });

    /// Regression: https://github.com/fluttercandies/flutter_wechat_assets_picker/issues/427
    testWidgets(
      'does not clear selected assets',
      (WidgetTester tester) async {
        final List<AssetEntity> selectedAssets = <AssetEntity>[testAssetEntity];
        await tester.pumpWidget(
          defaultPickerTestApp(
            onButtonPressed: (BuildContext context) {
              AssetPicker.pickAssets(
                context,
                pickerConfig: AssetPickerConfig(selectedAssets: selectedAssets),
              );
            },
          ),
        );
        await tester.tap(defaultButtonFinder);
        await tester.pumpAndSettle();
        await tester.tap(find.widgetWithIcon(IconButton, Icons.close));
        await tester.pumpAndSettle();
        expect(selectedAssets, contains(testAssetEntity));
      },
    );
  });
}
