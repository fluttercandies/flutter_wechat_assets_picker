///
/// [Author] Alex (https://github.com/AlexVincent525)
/// [Date] 2020/4/20 10:36
///
import 'dart:developer';

import 'package:flutter/foundation.dart';

/// Print message only if at [kDebugMode].
/// 仅在debug模式下输出消息
void realDebugPrint(dynamic message) {
  if (kDebugMode) {
    log('$message');
  }
}
