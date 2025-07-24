// Copyright 2019 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by an Apache license that can be found
// in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

const String _testButtonText = 'Picker test press';

final Finder defaultButtonFinder = find.widgetWithText(
  TextButton,
  _testButtonText,
);

Widget defaultPickerTestApp({
  void Function(BuildContext)? onButtonPressed,
  Locale locale = const Locale('zh'),
}) {
  return MaterialApp(
    home: _DefaultHomePage(onButtonPressed),
    localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
      GlobalWidgetsLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: const <Locale>[
      Locale('zh'),
      Locale('en'),
      Locale('he'),
      Locale('de'),
      Locale('ru'),
      Locale('ja'),
      Locale('ar'),
      Locale('fr'),
      Locale('vi'),
      Locale('ko'),
    ],
    locale: locale,
  );
}

class _DefaultHomePage extends StatelessWidget {
  const _DefaultHomePage(this.onButtonPressed);

  final void Function(BuildContext)? onButtonPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () {
            onButtonPressed?.call(context);
          },
          child: const Text(_testButtonText),
        ),
      ),
    );
  }
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
  Future<PermissionState> permissionCheck({
    PermissionRequestOption requestOption = const PermissionRequestOption(),
  }) async {
    return SynchronousFuture<PermissionState>(PermissionState.authorized);
  }

  @override
  Future<List<AssetEntity>?> pickAssets(
    BuildContext context, {
    Key? key,
    AssetPickerConfig pickerConfig = const AssetPickerConfig(),
    PermissionRequestOption? permissionRequestOption,
    bool useRootNavigator = true,
    RouteSettings? pageRouteSettings,
    AssetPickerPageRouteBuilder<List<AssetEntity>>? pageRouteBuilder,
  }) async {
    permissionRequestOption ??= PermissionRequestOption(
      androidPermission: AndroidPermission(
        type: pickerConfig.requestType,
        mediaLocation: false,
      ),
    );
    final PermissionState ps = await permissionCheck(
      requestOption: permissionRequestOption,
    );
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
      ..currentAssets = <AssetEntity>[testAssetEntity]
      ..currentPath = PathWrapper<AssetPathEntity>(
        path: pathEntity,
        assetCount: 1,
      )
      ..hasAssetsToDisplay = true
      ..totalAssetsCount = 1;
    final Widget picker = AssetPicker<AssetEntity, AssetPathEntity>(
      key: key,
      permissionRequestOption: permissionRequestOption,
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
        shouldAutoplayPreview: pickerConfig.shouldAutoplayPreview,
      ),
    );
    final List<AssetEntity>? result = await Navigator.of(
      context,
      rootNavigator: useRootNavigator,
    ).push<List<AssetEntity>>(
      pageRouteBuilder?.call(picker) ??
          AssetPickerPageRoute<List<AssetEntity>>(
            builder: (_) => picker,
            settings: pageRouteSettings,
          ),
    );
    return result;
  }
}

const AssetEntity testAssetEntity = AssetEntity(
  id: 'test',
  typeInt: 0,
  width: 0,
  height: 0,
);
