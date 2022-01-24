///
/// [Author] Alex (https://github.com/Alex525)
/// [Date] 2020/5/30 15:39
///
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import 'constants/extensions.dart';
import 'constants/screens.dart';
import 'pages/splash_page.dart';

const Color themeColor = Color(0xff00bc56);

String? packageVersion;

void main() {
  runApp(MyApp());
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
  );
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
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: themeColor,
        ),
      ),
      home: const SplashPage(),
      builder: (BuildContext c, Widget? w) {
        return ScrollConfiguration(
          behavior: const NoGlowScrollBehavior(),
          child: w!,
        );
      },
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const <Locale>[
        Locale('zh'), // Chinese
        // Locale('iw'), // Hebrew
      ],
      locale: const Locale('zh'),
    );
  }
}

class NoGlowScrollBehavior extends ScrollBehavior {
  const NoGlowScrollBehavior();

  @override
  Widget buildViewportChrome(
    BuildContext context,
    Widget child,
    AxisDirection axisDirection,
  ) =>
      child;
}
