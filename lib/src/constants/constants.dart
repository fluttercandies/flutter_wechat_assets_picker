///
/// [Author] Alex (https://github.com/Alex525)
/// [Date] 2020/3/31 16:02
///
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'constants.dart';

export 'package:photo_manager/photo_manager.dart';
export 'package:provider/provider.dart';
export 'package:video_player/video_player.dart';

export '../delegates/asset_picker_builder_delegate.dart';
export '../delegates/asset_picker_viewer_builder_delegate.dart';
export '../delegates/assets_picker_text_delegate.dart';
export '../delegates/sort_path_delegate.dart';
export '../provider/asset_entity_image_provider.dart';
export '../provider/asset_picker_provider.dart';
export '../provider/asset_picker_viewer_provider.dart';
export '../widget/asset_picker.dart';
export '../widget/asset_picker_page_route.dart';
export '../widget/asset_picker_viewer.dart';
export '../widget/builder/audio_page_builder.dart';
export '../widget/builder/fade_image_builder.dart';
export '../widget/builder/image_page_builder.dart';
export '../widget/builder/video_page_builder.dart';
export '../widget/fixed_appbar.dart';
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

  static const int defaultGridThumbSize = 200;
}

/// Log only in debug mode.
/// 只在调试模式打印
void realDebugPrint(dynamic message) {
  if (!kReleaseMode) {
    log('$message');
  }
}
