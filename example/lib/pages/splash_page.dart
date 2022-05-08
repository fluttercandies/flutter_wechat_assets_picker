///
/// @Author Alex (https://github.com/AlexV525)
/// [Date] 2020-05-31 21:36
///
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../main.dart';
import 'home_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage();

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    await PackageInfo.fromPlatform()
        .then((PackageInfo p) => packageVersion = p.version)
        .catchError((Object _) {});
    await Future<void>.delayed(const Duration(seconds: 1));
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder<void>(
          pageBuilder: (_, __, ___) => const HomePage(),
          transitionsBuilder: (_, Animation<double> a, __, Widget child) {
            return FadeTransition(opacity: a, child: child);
          },
          transitionDuration: const Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).canvasColor,
      child: Center(
        child: Hero(
          tag: 'LOGO',
          child: Image.asset('assets/flutter_candies_logo.png', width: 150.0),
        ),
      ),
    );
  }
}
