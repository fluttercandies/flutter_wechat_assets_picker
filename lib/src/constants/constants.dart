///
/// [Author] Alex (https://github.com/Alex525)
/// [Date] 2020/3/31 16:02
///
import 'constants.dart';

export 'package:flutter_common_exports/flutter_common_exports.dart';

export '../delegates/sort_path_delegate.dart';
export '../delegates/text_delegate.dart';

export 'colors.dart';
export 'custom_scroll_physics.dart';
export 'enums.dart';

class Constants {
  const Constants._();

  static TextDelegate textDelegate = DefaultTextDelegate();
  static SortPathDelegate sortPathDelegate = SortPathDelegate.common;
}
