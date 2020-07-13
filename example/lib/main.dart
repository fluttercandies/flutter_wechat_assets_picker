///
/// [Author] Alex (https://github.com/Alex525)
/// [Date] 2020/5/30 15:39
///
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_common_exports/flutter_common_exports.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import 'pages/splash_page.dart';

const Color themeColor = Color(0xff00bc56);

bool get currentIsDark => Screens.mediaQuery.platformBrightness.isDark;

void main() {
  runApp(MyApp());
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
    statusBarColor: Colors.transparent,
  ));
  AssetPicker.registerObserve();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WeChat Asset Picker Demo',
      theme: ThemeData(
        brightness: Screens.mediaQuery.platformBrightness,
        primarySwatch: themeColor.swatch,
        cursorColor: themeColor,
      ),
      home: const SplashPage(),
      builder: (BuildContext c, Widget w) {
        return ScrollConfiguration(
          behavior: const NoGlowScrollBehavior(),
          child: w,
        );
      },
    );
  }
}
