///
/// [Author] Alex (https://github.com/Alex525)
/// [Date] 2020/3/31 15:39
///

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/constants.dart';

class AssetPicker<A, P> extends StatelessWidget {
  const AssetPicker({
    Key? key,
    required this.builder,
  }) : super(key: key);

  final AssetPickerBuilderDelegate<A, P> builder;

  /// Static method to push with the navigator.
  /// 跳转至选择器的静态方法
  static Future<List<AssetEntity>?> pickAssets(
    BuildContext context, {
    List<AssetEntity>? selectedAssets,
    int maxAssets = 9,
    int pageSize = 80,
    int gridThumbSize = Constants.defaultGridThumbSize,
    int pathThumbSize = 80,
    int gridCount = 4,
    RequestType requestType = RequestType.image,
    List<int>? previewThumbSize,
    SpecialPickerType? specialPickerType,
    Color? themeColor,
    ThemeData? pickerTheme,
    SortPathDelegate? sortPathDelegate,
    AssetsPickerTextDelegate? textDelegate,
    FilterOptionGroup? filterOptions,
    WidgetBuilder? specialItemBuilder,
    IndicatorBuilder? loadingIndicatorBuilder,
    SpecialItemPosition specialItemPosition = SpecialItemPosition.none,
    bool allowSpecialItemWhenEmpty = false,
    bool useRootNavigator = true,
    Curve routeCurve = Curves.easeIn,
    Duration routeDuration = const Duration(milliseconds: 300),
  }) async {
    if (maxAssets < 1) {
      throw ArgumentError(
        'maxAssets must be greater than 1.',
      );
    }
    if (pageSize % gridCount != 0) {
      throw ArgumentError(
        'pageSize must be a multiple of gridCount.',
      );
    }
    if (pickerTheme != null && themeColor != null) {
      throw ArgumentError(
        'Theme and theme color cannot be set at the same time.',
      );
    }
    if (specialPickerType == SpecialPickerType.wechatMoment) {
      if (requestType != RequestType.image) {
        throw ArgumentError(
          'SpecialPickerType.wechatMoment and requestType cannot be set at the same time.',
        );
      }
      requestType = RequestType.common;
    }
    if ((specialItemBuilder == null &&
            specialItemPosition != SpecialItemPosition.none) ||
        (specialItemBuilder != null &&
            specialItemPosition == SpecialItemPosition.none)) {
      throw ArgumentError('Custom item did not set properly.');
    }

    try {
      final PermissionState _ps = await PhotoManager.requestPermissionExtend();
      if (_ps == PermissionState.authorized || _ps == PermissionState.limited) {
        final DefaultAssetPickerProvider provider = DefaultAssetPickerProvider(
          maxAssets: maxAssets,
          pageSize: pageSize,
          pathThumbSize: pathThumbSize,
          selectedAssets: selectedAssets,
          requestType: requestType,
          sortPathDelegate: sortPathDelegate,
          filterOptions: filterOptions,
          routeDuration: routeDuration,
        );
        final Widget picker =
            ChangeNotifierProvider<DefaultAssetPickerProvider>.value(
          value: provider,
          child: AssetPicker<AssetEntity, AssetPathEntity>(
            key: Constants.pickerKey,
            builder: DefaultAssetPickerBuilderDelegate(
              provider: provider,
              gridCount: gridCount,
              textDelegate: textDelegate,
              themeColor: themeColor,
              pickerTheme: pickerTheme,
              gridThumbSize: gridThumbSize,
              previewThumbSize: previewThumbSize,
              specialPickerType: specialPickerType,
              specialItemPosition: specialItemPosition,
              specialItemBuilder: specialItemBuilder,
              loadingIndicatorBuilder: loadingIndicatorBuilder,
              allowSpecialItemWhenEmpty: allowSpecialItemWhenEmpty,
            ),
          ),
        );
        final List<AssetEntity>? result = await Navigator.of(
          context,
          rootNavigator: useRootNavigator,
        ).push<List<AssetEntity>>(
          AssetPickerPageRoute<List<AssetEntity>>(
            builder: picker,
            transitionCurve: routeCurve,
            transitionDuration: routeDuration,
          ),
        );
        return result;
      }
      return null;
    } catch (e) {
      realDebugPrint('Error when calling assets picker: $e');
      return null;
    }
  }

  /// Register observe callback with assets changes.
  /// 注册资源（图库）变化的监听回调
  static void registerObserve([ValueChanged<MethodCall>? callback]) {
    if (callback == null) {
      return;
    }
    try {
      PhotoManager.addChangeCallback(callback);
      PhotoManager.startChangeNotify();
    } catch (e) {
      realDebugPrint('Error when registering assets callback: $e');
    }
  }

  /// Unregister the observation callback with assets changes.
  /// 取消注册资源（图库）变化的监听回调
  static void unregisterObserve([ValueChanged<MethodCall>? callback]) {
    if (callback == null) {
      return;
    }
    try {
      PhotoManager.removeChangeCallback(callback);
      PhotoManager.stopChangeNotify();
    } catch (e) {
      realDebugPrint('Error when unregistering assets callback: $e');
    }
  }

  /// Build a dark theme according to the theme color.
  /// 通过主题色构建一个默认的暗黑主题
  static ThemeData themeData(Color themeColor) {
    return ThemeData.dark().copyWith(
      buttonColor: themeColor,
      brightness: Brightness.dark,
      primaryColor: Colors.grey[900],
      primaryColorBrightness: Brightness.dark,
      primaryColorLight: Colors.grey[900],
      primaryColorDark: Colors.grey[900],
      accentColor: themeColor,
      accentColorBrightness: Brightness.dark,
      canvasColor: Colors.grey[850],
      scaffoldBackgroundColor: Colors.grey[900],
      bottomAppBarColor: Colors.grey[900],
      cardColor: Colors.grey[900],
      highlightColor: Colors.transparent,
      toggleableActiveColor: themeColor,
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: themeColor,
        selectionColor: themeColor.withAlpha(100),
        selectionHandleColor: themeColor,
      ),
      indicatorColor: themeColor,
      appBarTheme: const AppBarTheme(
        brightness: Brightness.dark,
        elevation: 0,
      ),
      colorScheme: ColorScheme(
        primary: Colors.grey[900]!,
        primaryVariant: Colors.grey[900]!,
        secondary: themeColor,
        secondaryVariant: themeColor,
        background: Colors.grey[900]!,
        surface: Colors.grey[900]!,
        brightness: Brightness.dark,
        error: const Color(0xffcf6679),
        onPrimary: Colors.black,
        onSecondary: Colors.black,
        onSurface: Colors.white,
        onBackground: Colors.white,
        onError: Colors.black,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return builder.build(context);
  }
}
