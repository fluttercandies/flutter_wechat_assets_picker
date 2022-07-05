// Copyright 2019 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by an Apache license that can be found
// in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

void main() {
  PhotoManager.withPlugin(TestPhotoManagerPlugin());
  AssetPicker.setPickerDelegate(TestAssetPickerDelegate());

  final Finder defaultButtonFinder = find.byType(TextButton);

  Widget _defaultApp({void Function(BuildContext)? onButtonPressed}) {
    return MaterialApp(
      home: Builder(
        builder: (BuildContext context) => Scaffold(
          body: Center(
            child: TextButton(
              onPressed: () => onButtonPressed?.call(context),
              child: const Text('Press'),
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('PathNameBuilder called correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      _defaultApp(
        onButtonPressed: (BuildContext context) {
          AssetPicker.pickAssets(
            context,
            pickerConfig: AssetPickerConfig(
              pathNameBuilder: (AssetPathEntity p) => 'testPathNameBuilder',
            ),
          );
        },
      ),
    );
    await tester.tap(defaultButtonFinder);
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.keyboard_arrow_down));
    await tester.pumpAndSettle();
    expect(find.text('testPathNameBuilder'), findsOneWidget);
  });
}

class TestPhotoManagerPlugin extends PhotoManagerPlugin {
  @override
  Future<PermissionState> requestPermissionExtend(
    PermissionRequestOption requestOption,
  ) {
    return SynchronousFuture<PermissionState>(PermissionState.authorized);
  }
}

class TestAssetPickerDelegate extends AssetPickerDelegate {
  @override
  Future<PermissionState> permissionCheck() async {
    return SynchronousFuture<PermissionState>(PermissionState.authorized);
  }

  @override
  Future<List<AssetEntity>?> pickAssets(
    BuildContext context, {
    Key? key,
    AssetPickerConfig pickerConfig = const AssetPickerConfig(),
    bool useRootNavigator = true,
    AssetPickerPageRouteBuilder<List<AssetEntity>>? pageRouteBuilder,
  }) async {
    final PermissionState ps = await permissionCheck();
    final AssetPathEntity pathEntity = AssetPathEntity(
      id: 'test',
      name: 'pathEntity',
    );
    final DefaultAssetPickerProvider provider =
        DefaultAssetPickerProvider.forTest(
      maxAssets: pickerConfig.maxAssets,
      pageSize: pickerConfig.pageSize,
      pathThumbnailSize: pickerConfig.pathThumbnailSize,
      selectedAssets: pickerConfig.selectedAssets,
      requestType: pickerConfig.requestType,
      sortPathDelegate: pickerConfig.sortPathDelegate,
      filterOptions: pickerConfig.filterOptions,
    );
    provider
      ..currentAssets = <AssetEntity>[
        const AssetEntity(id: 'test', typeInt: 0, width: 0, height: 0),
      ]
      ..currentPath = PathWrapper<AssetPathEntity>(
        path: pathEntity,
        assetCount: 1,
      )
      ..hasAssetsToDisplay = true
      ..totalAssetsCount = 1;
    final Widget picker = AssetPicker<AssetEntity, AssetPathEntity>(
      key: key,
      builder: DefaultAssetPickerBuilderDelegate(
        provider: provider,
        initialPermission: ps,
        gridCount: pickerConfig.gridCount,
        pickerTheme: pickerConfig.pickerTheme,
        gridThumbnailSize: pickerConfig.gridThumbnailSize,
        previewThumbnailSize: pickerConfig.previewThumbnailSize,
        specialPickerType: pickerConfig.specialPickerType,
        specialItemPosition: pickerConfig.specialItemPosition,
        specialItemBuilder: pickerConfig.specialItemBuilder,
        loadingIndicatorBuilder: pickerConfig.loadingIndicatorBuilder,
        selectPredicate: pickerConfig.selectPredicate,
        shouldRevertGrid: pickerConfig.shouldRevertGrid,
        limitedPermissionOverlayPredicate:
            pickerConfig.limitedPermissionOverlayPredicate,
        pathNameBuilder: pickerConfig.pathNameBuilder,
        textDelegate: pickerConfig.textDelegate,
        themeColor: pickerConfig.themeColor,
        locale: Localizations.maybeLocaleOf(context),
      ),
    );
    final List<AssetEntity>? result = await Navigator.of(
      context,
      rootNavigator: useRootNavigator,
    ).push<List<AssetEntity>>(
      pageRouteBuilder?.call(picker) ??
          AssetPickerPageRoute<List<AssetEntity>>(builder: (_) => picker),
    );
    return result;
  }
}
