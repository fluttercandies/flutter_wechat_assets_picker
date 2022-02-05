///
/// [Author] Alex (https://github.com/Alex525)
/// [Date] 2020-05-31 21:38
///
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';

import '../constants/screens.dart';
import '../customs/custom_picker_page.dart';
import '../main.dart';
import 'multi_assets_page.dart';
import 'single_assets_page.dart';

bool get currentIsDark =>
    Screens.mediaQuery.platformBrightness == Brightness.dark;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController controller = PageController();
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    controller.addListener(pageControllerListener);
  }

  void selectIndex(int index) {
    if (index == currentIndex) {
      return;
    }
    controller.animateToPage(
      index,
      duration: kThemeAnimationDuration,
      curve: Curves.easeInOut,
    );
  }

  void pageControllerListener() {
    final int? currentPage = controller.page?.round();
    if (currentPage != null && currentPage != currentIndex) {
      currentIndex = currentPage;
      if (mounted) {
        setState(() {});
      }
    }
  }

  Widget header(BuildContext context) {
    return Container(
      margin: const EdgeInsetsDirectional.only(top: 30.0),
      height: 60.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          AspectRatio(
            aspectRatio: 1.0,
            child: Hero(
              tag: 'LOGO',
              child: Image.asset('assets/flutter_candies_logo.png'),
            ),
          ),
          const SizedBox(width: 10.0),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Semantics(
                sortKey: const OrdinalSortKey(0),
                child: Text(
                  'WeChat Asset Picker',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              Semantics(
                sortKey: const OrdinalSortKey(0.1),
                child: Text(
                  'Version: ${packageVersion ?? 'unknown'}',
                  style: Theme.of(context).textTheme.caption,
                ),
              ),
            ],
          ),
          const SizedBox(width: 20.0),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: currentIsDark
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: <Widget>[
              header(context),
              Expanded(
                child: PageView(
                  controller: controller,
                  children: <Widget>[
                    MultiAssetsPage(),
                    SingleAssetPage(),
                    CustomPickersPage(),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: selectIndex,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.photo_library),
              label: 'Multi',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.photo),
              label: 'Single',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore),
              label: 'Custom',
            ),
          ],
        ),
      ),
    );
  }
}
