// Copyright 2019 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by an Apache license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';

import '../constants/extensions.dart';
import '../customs/custom_picker_page.dart';
import '../main.dart';
import 'multi_assets_page.dart';
import 'single_assets_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
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
                  context.l10n.appTitle,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Semantics(
                sortKey: const OrdinalSortKey(0.1),
                child: Text(
                  context.l10n.appVersion(
                    packageVersion ?? context.l10n.appVersionUnknown,
                  ),
                  style: Theme.of(context).textTheme.bodySmall,
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
      value: Theme.of(context).brightness == Brightness.dark
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
                  children: const <Widget>[
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
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: const Icon(Icons.photo_library),
              label: context.l10n.navMulti,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.photo),
              label: context.l10n.navSingle,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.explore),
              label: context.l10n.navCustom,
            ),
          ],
        ),
      ),
    );
  }
}
