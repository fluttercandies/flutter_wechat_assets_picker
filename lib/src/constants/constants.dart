///
/// [Author] Alex (https://github.com/Alex525)
/// [Date] 2020/3/31 16:02
///
import 'package:flutter/widgets.dart';

import 'constants.dart';

export 'package:flutter_common_exports/flutter_common_exports.dart';

export '../delegates/assets_picker_text_delegate.dart';
export '../delegates/sort_path_delegate.dart';

export 'colors.dart';
export 'custom_scroll_physics.dart';
export 'enums.dart';

class Constants {
  const Constants._();

  static GlobalKey pickerKey = GlobalKey();

  static AssetsPickerTextDelegate textDelegate =
      DefaultAssetsPickerTextDelegate();
  static SortPathDelegate sortPathDelegate = SortPathDelegate.common;
}
