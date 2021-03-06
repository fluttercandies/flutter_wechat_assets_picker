///
/// [Author] Alex (https://github.com/Alex525)
/// [Date] 2020-05-31 21:36
///
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../constants/extensions.dart';
import '../constants/resource.dart';
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
    SchedulerBinding.instance?.addPostFrameCallback(
      (Duration _) {
        Future<void>.delayed(
          const Duration(seconds: 2),
          () {
            Navigator.of(context).pushReplacement(
              PageRouteBuilder<void>(
                pageBuilder: (_, __, ___) => const HomePage(),
                transitionsBuilder: (
                  _,
                  Animation<double> animation,
                  Animation<double> secondaryAnimation,
                  Widget child,
                ) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
                transitionDuration: const Duration(seconds: 1),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.themeData.canvasColor,
      child: Center(
        child: Hero(
          tag: 'LOGO',
          child: Image.asset(
            R.ASSETS_FLUTTER_CANDIES_LOGO_PNG,
            width: 150.0,
          ),
        ),
      ),
    );
  }
}
