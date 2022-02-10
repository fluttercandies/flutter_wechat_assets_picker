///
/// [Author] Alex (https://github.com/Alex525)
/// [Date] 2020/3/31 15:39
///

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_manager/photo_manager.dart';

import '../constants/constants.dart';
import '../constants/enums.dart';
import '../constants/extensions.dart';
import '../delegates/asset_picker_builder_delegate.dart';
import '../delegates/asset_picker_text_delegate.dart';
import '../delegates/sort_path_delegate.dart';
import '../internal/methods.dart';
import '../internal/singleton.dart';
import '../provider/asset_picker_provider.dart';
import 'asset_picker_page_route.dart';

class AssetPicker<Asset, Path> extends StatefulWidget {
  const AssetPicker({Key? key, required this.builder}) : super(key: key);

  final AssetPickerBuilderDelegate<Asset, Path> builder;

  static Future<PermissionState> permissionCheck() async {
    final PermissionState _ps = await PhotoManager.requestPermissionExtend();
    if (_ps != PermissionState.authorized && _ps != PermissionState.limited) {
      throw StateError('Permission state error with $_ps.');
    }
    return _ps;
  }

  /// Static method to push with the navigator.
  /// 跳转至选择器的静态方法
  static Future<List<AssetEntity>?> pickAssets(
    BuildContext context, {
    List<AssetEntity>? selectedAssets,
    int maxAssets = 9,
    int pageSize = 80,
    int gridThumbSize = defaultAssetGridPreviewSize,
    int pathThumbSize = 80,
    int gridCount = 4,
    RequestType requestType = RequestType.image,
    List<int>? previewThumbSize,
    SpecialPickerType? specialPickerType,
    Color? themeColor,
    ThemeData? pickerTheme,
    SortPathDelegate<AssetPathEntity>? sortPathDelegate,
    AssetPickerTextDelegate? textDelegate,
    FilterOptionGroup? filterOptions,
    WidgetBuilder? specialItemBuilder,
    IndicatorBuilder? loadingIndicatorBuilder,
    SpecialItemPosition specialItemPosition = SpecialItemPosition.none,
    bool allowSpecialItemWhenEmpty = false,
    AssetSelectPredicate<AssetEntity>? selectPredicate,
    bool? shouldRevertGrid,
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

    final PermissionState _ps = await permissionCheck();

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
    final Widget picker = CNP<DefaultAssetPickerProvider>.value(
      value: provider,
      child: AssetPicker<AssetEntity, AssetPathEntity>(
        key: Singleton.pickerKey,
        builder: DefaultAssetPickerBuilderDelegate(
          provider: provider,
          initialPermission: _ps,
          gridCount: gridCount,
          pickerTheme: pickerTheme,
          gridThumbSize: gridThumbSize,
          previewThumbSize: previewThumbSize,
          specialPickerType: specialPickerType,
          specialItemPosition: specialItemPosition,
          specialItemBuilder: specialItemBuilder,
          loadingIndicatorBuilder: loadingIndicatorBuilder,
          allowSpecialItemWhenEmpty: allowSpecialItemWhenEmpty,
          selectPredicate: selectPredicate,
          shouldRevertGrid: shouldRevertGrid,
          textDelegate: textDelegate,
          themeColor: themeColor,
          locale: Localizations.maybeLocaleOf(context),
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

  /// Call the picker with provided [delegate] and [provider].
  /// 通过指定的 [delegate] 和 [provider] 调用选择器
  static Future<List<Asset>?> pickAssetsWithDelegate<Asset, Path,
      PickerProvider extends AssetPickerProvider<Asset, Path>>(
    BuildContext context, {
    required AssetPickerBuilderDelegate<Asset, Path> delegate,
    bool useRootNavigator = true,
    Curve routeCurve = Curves.easeIn,
    Duration routeDuration = const Duration(milliseconds: 300),
  }) async {
    await permissionCheck();

    final Widget picker = AssetPicker<Asset, Path>(
      key: Singleton.pickerKey,
      builder: delegate,
    );
    final List<Asset>? result = await Navigator.of(
      context,
      rootNavigator: useRootNavigator,
    ).push<List<Asset>>(
      AssetPickerPageRoute<List<Asset>>(
        builder: picker,
        transitionCurve: routeCurve,
        transitionDuration: routeDuration,
      ),
    );
    return result;
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
  static ThemeData themeData(Color themeColor, {bool light = false}) {
    if (light) {
      return ThemeData.light().copyWith(
        primaryColor: Colors.grey[50],
        primaryColorLight: Colors.grey[50],
        primaryColorDark: Colors.grey[50],
        canvasColor: Colors.grey[100],
        scaffoldBackgroundColor: Colors.grey[50],
        bottomAppBarColor: Colors.grey[50],
        cardColor: Colors.grey[50],
        highlightColor: Colors.transparent,
        toggleableActiveColor: themeColor,
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: themeColor,
          selectionColor: themeColor.withAlpha(100),
          selectionHandleColor: themeColor,
        ),
        indicatorColor: themeColor,
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.dark,
          ),
          elevation: 0,
        ),
        buttonTheme: ButtonThemeData(buttonColor: themeColor),
        colorScheme: ColorScheme(
          primary: Colors.grey[50]!,
          secondary: themeColor,
          background: Colors.grey[50]!,
          surface: Colors.grey[50]!,
          brightness: Brightness.light,
          error: const Color(0xffcf6679),
          onPrimary: Colors.white,
          onSecondary: Colors.white,
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
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.light,
        ),
        elevation: 0,
      ),
      buttonTheme: ButtonThemeData(buttonColor: themeColor),
      colorScheme: ColorScheme(
        primary: Colors.grey[900]!,
        secondary: themeColor,
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
  AssetPickerState<Asset, Path> createState() =>
      AssetPickerState<Asset, Path>();
}

class AssetPickerState<Asset, Path> extends State<AssetPicker<Asset, Path>>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    AssetPicker.registerObserve(_onLimitedAssetsUpdated);
    widget.builder.initState(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      PhotoManager.requestPermissionExtend().then(
        (PermissionState ps) => widget.builder.permission.value = ps,
      );
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    AssetPicker.unregisterObserve(_onLimitedAssetsUpdated);
    widget.builder.dispose();
    super.dispose();
  }

  Future<void> _onLimitedAssetsUpdated(MethodCall call) async {
    await widget.builder.onAssetsChanged(
      call,
      (VoidCallback fn) {
        fn();
        if (mounted) {
          setState(() {});
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder.build(context);
  }
}
