///
/// [Author] Alex (https://github.com/Alex525)
/// [Date] 2020/3/31 16:02
///
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../delegates/asset_picker_text_delegate.dart';
import '../delegates/sort_path_delegate.dart';

class Constants {
  const Constants._();

  static GlobalKey pickerKey = GlobalKey();

  static AssetPickerTextDelegate textDelegate = AssetPickerTextDelegate();
  static SortPathDelegate<dynamic> sortPathDelegate = SortPathDelegate.common;

  /// The last scroll position where the picker scrolled.
  ///
  /// See also:
  ///  * [AssetPickerBuilderDelegate.keepScrollOffset]
  static ScrollPosition? scrollPosition;

  static const int defaultGridThumbSize = 200;
}

/// Log only in debug mode.
/// 只在调试模式打印
void realDebugPrint(dynamic message) {
  if (!kReleaseMode) {
    log('$message');
  }
}
