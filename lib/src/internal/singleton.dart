///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2022/2/6 14:54
///
/// Define an inner static singleton for picker libraries.
import 'package:flutter/widgets.dart';

import '../delegates/asset_picker_text_delegate.dart';
import '../delegates/sort_path_delegate.dart';

class Singleton {
  const Singleton._();

  static GlobalKey pickerKey = GlobalKey();

  static AssetPickerTextDelegate textDelegate = const AssetPickerTextDelegate();
  static SortPathDelegate<dynamic> sortPathDelegate = SortPathDelegate.common;

  /// The last scroll position where the picker scrolled.
  ///
  /// See also:
  ///  * [AssetPickerBuilderDelegate.keepScrollOffset]
  static ScrollPosition? scrollPosition;
}
