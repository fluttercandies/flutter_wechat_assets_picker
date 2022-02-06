///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2022/2/6 14:57
///
import 'dart:developer';

import 'package:flutter/foundation.dart';

/// Log only when debugging.
/// 只在调试模式打印
void realDebugPrint(dynamic message) {
  if (!kReleaseMode) {
    log('$message');
  }
}
