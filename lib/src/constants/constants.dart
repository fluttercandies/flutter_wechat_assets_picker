///
/// [Author] Alex (https://github.com/AlexVincent525)
/// [Date] 2020/3/31 16:02
///
import 'constants.dart';

export '../delegates/sort_path_delegate.dart';
export '../delegates/text_delegate.dart';
export '../utils/real_debug_print.dart';

export 'colors.dart';
export 'custom_scroll_physics.dart';
export 'screens.dart';

class Constants {
  const Constants._();

  static TextDelegate textDelegate = DefaultTextDelegate();
  static SortPathDelegate sortPathDelegate = SortPathDelegate.common;
}
