//
// [Author] Alex (https://github.com/AlexV525)
// [Date] 2022/09/20 17:09
//

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wechat_assets_picker/src/internals/singleton.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import 'test_utils.dart';

void main() {
  PhotoManager.withPlugin(TestPhotoManagerPlugin());
  AssetPicker.setPickerDelegate(TestAssetPickerDelegate());

  group('Confirm button', () {
    group('when enabled preview', () {
      testWidgets('with multiple assets picking', (WidgetTester tester) async {
        await tester.pumpWidget(
          defaultPickerTestApp(
            onButtonPressed: (BuildContext context) {
              AssetPicker.pickAssets(
                context,
                pickerConfig: const AssetPickerConfig(
                  maxAssets: 10,
                  specialPickerType: null, // Explicitly null.
                ),
              );
            },
          ),
        );
        await tester.tap(defaultButtonFinder);
        await tester.pumpAndSettle();
        expect(
          find.text(const AssetPickerTextDelegate().confirm),
          findsOneWidget,
        );
      });
      testWidgets('with single asset picking', (WidgetTester tester) async {
        await tester.pumpWidget(
          defaultPickerTestApp(
            onButtonPressed: (BuildContext context) {
              AssetPicker.pickAssets(
                context,
                pickerConfig: const AssetPickerConfig(
                  maxAssets: 1,
                  specialPickerType: null, // Explicitly null.
                ),
              );
            },
          ),
        );
        await tester.tap(defaultButtonFinder);
        await tester.pumpAndSettle();
        expect(
          find.text(const AssetPickerTextDelegate().confirm),
          findsOneWidget,
        );
      });
    });
    group('when disabled preview', () {
      testWidgets('with multiple assets picker', (WidgetTester tester) async {
        await tester.pumpWidget(
          defaultPickerTestApp(
            onButtonPressed: (BuildContext context) {
              AssetPicker.pickAssets(
                context,
                pickerConfig: const AssetPickerConfig(
                  maxAssets: 2,
                  specialPickerType: SpecialPickerType.noPreview,
                ),
              );
            },
          ),
        );
        await tester.tap(defaultButtonFinder);
        await tester.pumpAndSettle();
        expect(
          find.text(const AssetPickerTextDelegate().confirm),
          findsOneWidget,
        );
      });
      testWidgets('with single asset picker', (WidgetTester tester) async {
        await tester.pumpWidget(
          defaultPickerTestApp(
            onButtonPressed: (BuildContext context) {
              AssetPicker.pickAssets(
                context,
                pickerConfig: const AssetPickerConfig(
                  maxAssets: 1,
                  specialPickerType: SpecialPickerType.noPreview,
                ),
              );
            },
          ),
        );
        await tester.tap(defaultButtonFinder);
        await tester.pumpAndSettle();
        expect(
          find.text(const AssetPickerTextDelegate().confirm),
          findsNothing,
        );
      });
    });
    group('when disabled selection', () {
      testWidgets('selection is not possible in asset picker',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          defaultPickerTestApp(
            onButtonPressed: (BuildContext context) {
              AssetPicker.pickAssets(
                context,
                pickerConfig: const AssetPickerConfig(
                  specialPickerType: SpecialPickerType.noSelection,
                ),
              );
            },
          ),
        );
        await tester.tap(defaultButtonFinder);
        await tester.pumpAndSettle();
        expect(
          find.byWidgetPredicate((w) =>
              w is AnimatedContainer &&
              (w.decoration as BoxDecoration).shape == BoxShape.circle),
          findsNothing,
        );
        await tester.tap(find.byWidgetPredicate(
            (w) => w is Semantics && w.properties.sortKey?.name == 'GridItem'));
        await tester.pumpAndSettle();
        expect(
          find.bySemanticsLabel(
              Singleton.textDelegate.semanticsTextDelegate.select),
          findsNothing,
        );
      });
    });
  });
}
