///
/// [Author] Alex (https://github.com/Alex525)
/// [Date] 2020/3/31 16:02
///
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'constants.dart';

export '../delegates/assets_picker_text_delegate.dart';
export '../delegates/sort_path_delegate.dart';
export '../widget/platform_progress_indicator.dart';

export 'colors.dart';
export 'custom_scroll_physics.dart';
export 'enums.dart';
export 'extensions.dart';
export 'screens.dart';

class Constants {
  const Constants._();

  static GlobalKey pickerKey = GlobalKey();

  static AssetsPickerTextDelegate textDelegate =
      DefaultAssetsPickerTextDelegate();
  static SortPathDelegate sortPathDelegate = SortPathDelegate.common;

  static const List<int> defaultPreviewThumbSize = <int>[200, 200];
}

/// Log only in debug mode.
/// 只在调试模式打印
void realDebugPrint(dynamic message) {
  if (!kReleaseMode) {
    log('$message');
  }
}
