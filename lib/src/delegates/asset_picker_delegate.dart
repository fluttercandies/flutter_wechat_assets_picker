// Copyright 2019 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by an Apache license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_manager/photo_manager.dart';

import '../constants/config.dart';
import '../constants/constants.dart';
import '../provider/asset_picker_provider.dart';
import '../widget/asset_picker.dart';
import '../widget/asset_picker_page_route.dart';
import 'asset_picker_builder_delegate.dart';

class AssetPickerDelegate {
  const AssetPickerDelegate();

  /// {@template wechat_assets_picker.delegates.AssetPickerDelegate.permissionCheck}
  /// Request the current [PermissionState] of required permissions.
  /// 请求所需权限的 [PermissionState]。
  ///
  /// Throws a [StateError] when the state is not [PermissionState.authorized]
  /// or [PermissionState.limited],
  /// which means the picker can not perform further actions.
  /// 当权限状态不是 [PermissionState.authorized] 或 [PermissionState.limited] 时，
  /// 将抛出 [StateError]，此时选择器无法执行其他操作。
  ///
  /// See also:
  ///  * [PermissionState] which defined all states of required permissions.
  /// {@endtemplate}
  Future<PermissionState> permissionCheck({
    PermissionRequestOption requestOption = const PermissionRequestOption(),
  }) async {
    final PermissionState ps = await PhotoManager.requestPermissionExtend(
      requestOption: requestOption,
    );
    if (ps != PermissionState.authorized && ps != PermissionState.limited) {
      throw StateError('Permission state error with $ps.');
    }
    return ps;
  }

  /// {@template wechat_assets_picker.delegates.AssetPickerDelegate.pickAssets}
  /// Pick assets with the given [pickerConfig].
  /// 根据给定的 [pickerConfig] 选择资源。
  ///
  /// Set [useRootNavigator] to determine
  /// whether the picker route should use the root [Navigator].
  /// 使用 [useRootNavigator] 来控制选择器的路由是否使用最顶层的 [Navigator]。
  ///
  /// By extending the [AssetPickerPageRoute], users can customize the route
  /// and use it with the [pageRouteBuilder].
  /// 继承 [AssetPickerPageRoute] 可以自定义路由，
  /// 并且通过 [pageRouteBuilder] 进行使用。
  ///
  /// See also:
  ///  * [AssetPickerConfig] which holds all configurations for basic picking.
  ///  * [DefaultAssetPickerProvider] which is the default provider that
  ///    manages assets during the picking process.
  ///  * [DefaultAssetPickerBuilderDelegate] which is the default builder that
  ///    builds all widgets during the picking process.
  /// {@endtemplate}
  Future<List<AssetEntity>?> pickAssets(
    BuildContext context, {
    Key? key,
    AssetPickerConfig pickerConfig = const AssetPickerConfig(),
    bool useRootNavigator = true,
    AssetPickerPageRouteBuilder<List<AssetEntity>>? pageRouteBuilder,
  }) async {
    final PermissionState ps = await permissionCheck(
      requestOption: PermissionRequestOption(
        androidPermission: AndroidPermission(
          type: pickerConfig.requestType,
          mediaLocation: false,
        ),
      ),
    );
    final AssetPickerPageRoute<List<AssetEntity>> route =
        pageRouteBuilder?.call(const SizedBox.shrink()) ??
            AssetPickerPageRoute<List<AssetEntity>>(
              builder: (_) => const SizedBox.shrink(),
            );
    final DefaultAssetPickerProvider provider = DefaultAssetPickerProvider(
      maxAssets: pickerConfig.maxAssets,
      pageSize: pickerConfig.pageSize,
      pathThumbnailSize: pickerConfig.pathThumbnailSize,
      selectedAssets: pickerConfig.selectedAssets,
      requestType: pickerConfig.requestType,
      sortPathDelegate: pickerConfig.sortPathDelegate,
      filterOptions: pickerConfig.filterOptions,
      initializeDelayDuration: route.transitionDuration,
    );
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

  /// {@template wechat_assets_picker.delegates.AssetPickerDelegate.pickAssetsWithDelegate}
  /// Pick assets with the given [delegate].
  /// 根据给定的 [delegate] 选择资源。
  ///
  /// Set [useRootNavigator] to determine
  /// whether the picker route should use the root [Navigator].
  /// 使用 [useRootNavigator] 来控制选择器的路由是否使用最顶层的 [Navigator]。
  ///
  /// By extending the [AssetPickerPageRoute], users can customize the route
  /// and use it with the [pageRouteBuilder].
  /// 继承 [AssetPickerPageRoute] 可以自定义路由，
  /// 并且通过 [pageRouteBuilder] 进行使用。
  ///
  /// See also:
  ///  * [AssetPickerBuilderDelegate] for how to customize/override widgets
  ///    during the picking process.
  /// {@endtemplate}
  Future<List<Asset>?> pickAssetsWithDelegate<Asset, Path,
      PickerProvider extends AssetPickerProvider<Asset, Path>>(
    BuildContext context, {
    required AssetPickerBuilderDelegate<Asset, Path> delegate,
    PermissionRequestOption permissionRequestOption =
        const PermissionRequestOption(),
    Key? key,
    bool useRootNavigator = true,
    AssetPickerPageRouteBuilder<List<Asset>>? pageRouteBuilder,
  }) async {
    await permissionCheck(requestOption: permissionRequestOption);
    final Widget picker = AssetPicker<Asset, Path>(
      key: key,
      builder: delegate,
    );
    final List<Asset>? result = await Navigator.of(
      context,
      rootNavigator: useRootNavigator,
    ).push<List<Asset>>(
      pageRouteBuilder?.call(picker) ??
          AssetPickerPageRoute<List<Asset>>(builder: (_) => picker),
    );
    return result;
  }

  /// {@template wechat_assets_picker.delegates.AssetPickerDelegate.registerObserve}
  /// Register observe callback with assets changes.
  /// 注册资源（图库）变化的监听回调
  /// {@endtemplate}
  void registerObserve([ValueChanged<MethodCall>? callback]) {
    if (callback == null) {
      return;
    }
    try {
      PhotoManager.addChangeCallback(callback);
      PhotoManager.startChangeNotify();
    } catch (e, s) {
      FlutterError.presentError(
        FlutterErrorDetails(
          exception: e,
          stack: s,
          library: packageName,
          silent: true,
        ),
      );
    }
  }

  /// {@template wechat_assets_picker.delegates.AssetPickerDelegate.unregisterObserve}
  /// Unregister the observation callback with assets changes.
  /// 取消注册资源（图库）变化的监听回调
  /// {@endtemplate}
  void unregisterObserve([ValueChanged<MethodCall>? callback]) {
    if (callback == null) {
      return;
    }
    try {
      PhotoManager.removeChangeCallback(callback);
      PhotoManager.stopChangeNotify();
    } catch (e, s) {
      FlutterError.presentError(
        FlutterErrorDetails(
          exception: e,
          stack: s,
          library: packageName,
          silent: true,
        ),
      );
    }
  }

  /// {@template wechat_assets_picker.delegates.AssetPickerDelegate.themeData}
  /// Build a [ThemeData] with the given [themeColor] for the picker.
  /// 为选择器构建基于 [themeColor] 的 [ThemeData]。
  ///
  /// If [themeColor] is null, the color will use the fallback
  /// [defaultThemeColorWeChat] which is the default color in the WeChat design.
  /// 如果 [themeColor] 为 null，主题色将回落使用 [defaultThemeColorWeChat]，
  /// 即微信设计中的绿色主题色。
  ///
  /// Set [light] to true if pickers require a light version of the theme.
  /// 设置 [light] 为 true 时可以获取浅色版本的主题。
  /// {@endtemplate}
  ThemeData themeData(Color? themeColor, {bool light = false}) {
    themeColor ??= defaultThemeColorWeChat;
    if (light) {
      return ThemeData.light().copyWith(
        primaryColor: Colors.grey[50],
        primaryColorLight: Colors.grey[50],
        primaryColorDark: Colors.grey[50],
        canvasColor: Colors.grey[100],
        scaffoldBackgroundColor: Colors.grey[50],
        cardColor: Colors.grey[50],
        highlightColor: Colors.transparent,
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: themeColor,
          selectionColor: themeColor.withAlpha(100),
          selectionHandleColor: themeColor,
        ),
        indicatorColor: themeColor,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[100],
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.dark,
          ),
          iconTheme: IconThemeData(color: Colors.grey[900]),
          elevation: 0,
        ),
        bottomAppBarTheme: BottomAppBarTheme(
          color: Colors.grey[100],
        ),
        buttonTheme: ButtonThemeData(buttonColor: themeColor),
        iconTheme: IconThemeData(color: Colors.grey[900]),
        checkboxTheme: CheckboxThemeData(
          checkColor: MaterialStateProperty.all(Colors.black),
          fillColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return themeColor;
            }
            return null;
          }),
          side: const BorderSide(color: Colors.black),
        ),
        colorScheme: ColorScheme(
          primary: Colors.grey[50]!,
          secondary: themeColor,
          background: Colors.grey[50]!,
          surface: Colors.grey[50]!,
          brightness: Brightness.light,
          error: const Color(0xffcf6679),
          onPrimary: Colors.white,
          onSecondary: Colors.grey[100]!,
          onSurface: Colors.black,
          onBackground: Colors.black,
          onError: Colors.white,
        ),
      );
    }
    return ThemeData.dark().copyWith(
      primaryColor: Colors.grey[900],
      primaryColorLight: Colors.grey[900],
      primaryColorDark: Colors.grey[900],
      canvasColor: Colors.grey[850],
      scaffoldBackgroundColor: Colors.grey[900],
      cardColor: Colors.grey[900],
      highlightColor: Colors.transparent,
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: themeColor,
        selectionColor: themeColor.withAlpha(100),
        selectionHandleColor: themeColor,
      ),
      indicatorColor: themeColor,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.grey[850],
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.light,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      bottomAppBarTheme: BottomAppBarTheme(
        color: Colors.grey[850],
      ),
      buttonTheme: ButtonThemeData(buttonColor: themeColor),
      iconTheme: const IconThemeData(color: Colors.white),
      checkboxTheme: CheckboxThemeData(
        checkColor: MaterialStateProperty.all(Colors.white),
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return themeColor;
          }
          return null;
        }),
        side: const BorderSide(color: Colors.white),
      ),
      colorScheme: ColorScheme(
        primary: Colors.grey[900]!,
        secondary: themeColor,
        background: Colors.grey[900]!,
        surface: Colors.grey[900]!,
        brightness: Brightness.dark,
        error: const Color(0xffcf6679),
        onPrimary: Colors.black,
        onSecondary: Colors.grey[850]!,
        onSurface: Colors.white,
        onBackground: Colors.white,
        onError: Colors.black,
      ),
    );
  }
}
