// Copyright 2019 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by an Apache license that can be found
// in the LICENSE file.

import 'dart:developer';

import 'package:flutter/foundation.dart';

import '../constants/typedefs.dart';
import 'singleton.dart';

/// Log only when debugging.
/// 只在调试模式打印
void realDebugPrint(dynamic message) {
  if (!kReleaseMode) {
    log('[wechat_assets_picker] $message');
  }
}

/// @nodoc
void handleException(Object e, StackTrace s) {
  final ExceptionHandler? handler = Singleton.internalExceptionHandler;
  if (handler == null) {
    FlutterError.presentError(
      FlutterErrorDetails(
        exception: e,
        stack: s,
        library: 'wechat_assets_picker',
        silent: true,
        informationCollector: () => <DiagnosticsNode>[
          ErrorHint(
            'Note: Use `AssetPickerConfig.internalExceptionHandler` '
            'to handle exceptions manually.',
          ),
        ],
      ),
    );
  } else {
    handler(e, s);
  }
}
