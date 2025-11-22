// Copyright 2019 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by an Apache license that can be found
// in the LICENSE file.

import 'package:flutter/widgets.dart' show ScrollPosition;

import '../delegates/asset_picker_text_delegate.dart';
import '../delegates/sort_path_delegate.dart';

/// Define an inner static singleton for picker libraries.
class Singleton {
  const Singleton._();

  static AssetPickerTextDelegate textDelegate = const AssetPickerTextDelegate();
  static SortPathDelegate<dynamic> sortPathDelegate = SortPathDelegate.common;

  /// The last scroll position where the picker scrolled.
  ///
  /// See also:
  ///  * [AssetPickerBuilderDelegate.keepScrollOffset]
  static ScrollPosition? scrollPosition;
}
