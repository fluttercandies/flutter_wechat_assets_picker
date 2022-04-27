///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2022/04/27 12:14
///
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

void main() {
  PhotoManager.withPlugin(TestPhotoManagerPlugin());
  final Finder _defaultButtonFinder = find.byType(TextButton);
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
    final AssetPathEntity pathEntity = AssetPathEntity(
      id: 'test',
      name: 'pathEntity',
    );
    final PathNameBuilder<AssetPathEntity> pathNameBuilder =
        (AssetPathEntity p) => 'testPathNameBuilder';
    final AssetPickerConfig config = AssetPickerConfig(
      pathNameBuilder: pathNameBuilder,
    );
    final DefaultAssetPickerProvider provider =
        DefaultAssetPickerProvider.forTest(
      maxAssets: config.maxAssets,
      pageSize: config.pageSize,
      pathThumbnailSize: config.pathThumbnailSize,
      selectedAssets: config.selectedAssets,
      requestType: config.requestType,
      sortPathDelegate: config.sortPathDelegate,
      filterOptions: config.filterOptions,
    );
    provider
      ..currentAssets = <AssetEntity>[
        const AssetEntity(id: 'test', typeInt: 0, width: 0, height: 0),
      ]
      ..currentPath = pathEntity
      ..hasAssetsToDisplay = true
      ..setPathThumbnail(pathEntity, null);
    final DefaultAssetPickerBuilderDelegate delegate =
        DefaultAssetPickerBuilderDelegate(
      provider: provider,
      initialPermission: PermissionState.authorized,
      pathNameBuilder: pathNameBuilder,
    );
    await tester.pumpWidget(
      _defaultApp(
        onButtonPressed: (BuildContext context) {
          AssetPicker.pickAssetsWithDelegate(context, delegate: delegate);
        },
      ),
    );
    await tester.tap(_defaultButtonFinder);
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.keyboard_arrow_down));
    await tester.pumpAndSettle();
    expect(find.text('testPathNameBuilder'), findsNWidgets(2));
  });
}

class TestPhotoManagerPlugin extends PhotoManagerPlugin {
  @override
  Future<PermissionState> requestPermissionExtend(
    PermisstionRequestOption requestOption,
  ) {
    return SynchronousFuture<PermissionState>(PermissionState.authorized);
  }
}
