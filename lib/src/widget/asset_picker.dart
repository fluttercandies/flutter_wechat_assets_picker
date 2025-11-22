// Copyright 2019 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by an Apache license that can be found
// in the LICENSE file.

import 'dart:async' show Completer;
import 'dart:io' as io show Platform;

import 'package:flutter/material.dart' hide Path;
import 'package:flutter/services.dart' show MethodCall;
import 'package:photo_manager/photo_manager.dart';
import 'package:wechat_picker_library/wechat_picker_library.dart';

import '../constants/config.dart';
import '../delegates/asset_picker_builder_delegate.dart';
import '../delegates/asset_picker_delegate.dart';
import '../provider/asset_picker_provider.dart';
import 'asset_picker_page_route.dart';

AssetPickerDelegate _pickerDelegate = const AssetPickerDelegate();

class AssetPicker<Asset, Path,
        Delegate extends AssetPickerBuilderDelegate<Asset, Path>>
    extends StatefulWidget {
  const AssetPicker({
    super.key,
    required this.permissionRequestOption,
    required this.builder,
  });

  final PermissionRequestOption permissionRequestOption;
  final Delegate builder;

  /// Provide another [AssetPickerDelegate] which override with
  /// custom methods during handling the picking,
  /// e.g. to verify if arguments are properly set during picking calls.
  ///
  /// See also:
  ///  * [AssetPickerDelegate] which is the default picker delegate.
  @visibleForTesting
  static void setPickerDelegate(AssetPickerDelegate delegate) {
    _pickerDelegate = delegate;
  }

  /// {@macro wechat_assets_picker.delegates.AssetPickerDelegate.permissionCheck}
  static Future<PermissionState> permissionCheck({
    PermissionRequestOption requestOption = const PermissionRequestOption(),
  }) {
    return _pickerDelegate.permissionCheck(requestOption: requestOption);
  }

  /// {@macro wechat_assets_picker.delegates.AssetPickerDelegate.pickAssets}
  static Future<List<AssetEntity>?> pickAssets(
    BuildContext context, {
    Key? key,
    PermissionRequestOption? permissionRequestOption,
    AssetPickerConfig pickerConfig = const AssetPickerConfig(),
    bool useRootNavigator = true,
    RouteSettings? pageRouteSettings,
    AssetPickerPageRouteBuilder<List<AssetEntity>>? pageRouteBuilder,
  }) {
    return _pickerDelegate.pickAssets(
      context,
      key: key,
      pickerConfig: pickerConfig,
      permissionRequestOption: permissionRequestOption,
      useRootNavigator: useRootNavigator,
      pageRouteSettings: pageRouteSettings,
      pageRouteBuilder: pageRouteBuilder,
    );
  }

  /// {@macro wechat_assets_picker.delegates.AssetPickerDelegate.pickAssetsWithDelegate}
  static Future<List<Asset>?> pickAssetsWithDelegate<
      Asset,
      Path,
      PickerProvider extends AssetPickerProvider<Asset, Path>,
      Delegate extends AssetPickerBuilderDelegate<Asset, Path>>(
    BuildContext context, {
    required Delegate delegate,
    PermissionRequestOption permissionRequestOption =
        const PermissionRequestOption(),
    Key? key,
    RouteSettings? pageRouteSettings,
    AssetPickerPageRouteBuilder<List<Asset>>? pageRouteBuilder,
    bool useRootNavigator = true,
  }) {
    return _pickerDelegate
        .pickAssetsWithDelegate<Asset, Path, PickerProvider, Delegate>(
      context,
      key: key,
      delegate: delegate,
      permissionRequestOption: permissionRequestOption,
      useRootNavigator: useRootNavigator,
      pageRouteSettings: pageRouteSettings,
      pageRouteBuilder: pageRouteBuilder,
    );
  }

  /// {@macro wechat_assets_picker.delegates.AssetPickerDelegate.registerObserve}
  static void registerObserve([ValueChanged<MethodCall>? callback]) {
    _pickerDelegate.registerObserve(callback);
  }

  /// {@macro wechat_assets_picker.delegates.AssetPickerDelegate.unregisterObserve}
  static void unregisterObserve([ValueChanged<MethodCall>? callback]) {
    _pickerDelegate.unregisterObserve(callback);
  }

  /// {@macro wechat_assets_picker.delegates.AssetPickerDelegate.themeData}
  static ThemeData themeData(Color? themeColor, {bool light = false}) {
    return _pickerDelegate.themeData(themeColor, light: light);
  }

  @override
  AssetPickerState<Asset, Path, Delegate> createState() =>
      AssetPickerState<Asset, Path, Delegate>();
}

class AssetPickerState<Asset, Path,
        Delegate extends AssetPickerBuilderDelegate<Asset, Path>>
    extends State<AssetPicker<Asset, Path, Delegate>>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  Completer<PermissionState>? permissionStateLock;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    AssetPicker.registerObserve(_onAssetsUpdated);
    widget.builder.initState(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      requestPermission().then((ps) {
        if (!mounted) {
          return;
        }
        widget.builder.permissionNotifier.value = ps;
        if (ps == PermissionState.limited && io.Platform.isAndroid) {
          _onAssetsUpdated(const MethodCall(''));
        }
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    AssetPicker.unregisterObserve(_onAssetsUpdated);
    widget.builder.dispose();
    super.dispose();
  }

  Future<void> _onAssetsUpdated(MethodCall call) {
    return widget.builder.onAssetsChanged(call, (VoidCallback fn) {
      fn();
      safeSetState(() {});
    });
  }

  Future<PermissionState> requestPermission() {
    if (permissionStateLock != null) {
      return permissionStateLock!.future;
    }
    final lock = Completer<PermissionState>();
    permissionStateLock = lock;
    Future(
      () => PhotoManager.requestPermissionExtend(
        requestOption: widget.permissionRequestOption,
      ),
    ).then(lock.complete).catchError(lock.completeError).whenComplete(() {
      permissionStateLock = null;
    });
    return lock.future;
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder.build(context);
  }
}
