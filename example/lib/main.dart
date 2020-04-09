import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:extended_image/extended_image.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import 'package:example/color_extension.dart';

const Color themeColor = Color(0xff00bc56);

void main() {
  runApp(MyApp());
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
    statusBarColor: Colors.transparent,
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WeChat Asset Picker Demo',
      theme: ThemeData(
        primarySwatch: themeColor.swatch,
        cursorColor: themeColor,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<AssetEntity> assets = <AssetEntity>[];

  Future<void> selectAssets() async {
    final List<AssetEntity> result = await AssetPicker.pickAssets(
      context,
      maxAssets: 9,
      pathThumbSize: 84,
      gridCount: 4,
      selectedAssets: assets,
      requestType: RequestType.common,
    );
    if (result != null) {
      assets = List<AssetEntity>.from(result);
    }
  }

  void removeAsset(int index) {
    setState(() {
      assets.remove(assets.elementAt(index));
    });
  }

  Widget get textField => Expanded(
        child: TextField(
          autofocus: true,
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(16.0),
            isDense: true,
          ),
          style: const TextStyle(fontSize: 18.0),
          maxLines: null,
        ),
      );

  Widget assetItemBuilder(BuildContext _, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 5.0,
        vertical: 10.0,
      ),
      child: AspectRatio(
        aspectRatio: 1.0,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Stack(
            children: <Widget>[
              imageWidget(index),
              deleteButton(index),
            ],
          ),
        ),
      ),
    );
  }

  Widget imageWidget(int index) {
    return Positioned.fill(
      child: ExtendedImage(
        image: AssetEntityImageProvider(
          assets.elementAt(index),
          isOriginal: false,
        ),
        fit: BoxFit.cover,
      ),
    );
  }

  Widget deleteButton(int index) {
    return Positioned(
      top: 6.0,
      right: 6.0,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => removeAsset(index),
        child: Container(
          padding: const EdgeInsets.all(2.0),
          decoration: BoxDecoration(
            color: Theme.of(context).dividerColor.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.close, size: 14.0, color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Asset Picker Example'),
      ),
      body: Column(
        children: <Widget>[
          textField,
          AnimatedContainer(
            duration: kThemeAnimationDuration,
            curve: Curves.easeInOut,
            width: MediaQuery.of(context).size.width,
            height: assets.isNotEmpty ? 100.0 : 0.0,
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
            ),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: assets.length,
              itemBuilder: assetItemBuilder,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: selectAssets,
        tooltip: 'Select Asset',
        child: Icon(Icons.photo_library),
      ),
      floatingActionButtonLocation:
          CustomFloatingActionButtonLocation(assets.isNotEmpty),
    );
  }
}

class CustomFloatingActionButtonLocation extends FloatingActionButtonLocation {
  const CustomFloatingActionButtonLocation(this.isAssetNotEmpty);

  final bool isAssetNotEmpty;

  double _leftOffset(ScaffoldPrelayoutGeometry scaffoldGeometry,
      {double offset = 0.0}) {
    return kFloatingActionButtonMargin +
        scaffoldGeometry.minInsets.left -
        offset;
  }

  double _rightOffset(ScaffoldPrelayoutGeometry scaffoldGeometry,
      {double offset = 0.0}) {
    return scaffoldGeometry.scaffoldSize.width -
        kFloatingActionButtonMargin -
        scaffoldGeometry.minInsets.right -
        scaffoldGeometry.floatingActionButtonSize.width +
        offset;
  }

  double _endOffset(ScaffoldPrelayoutGeometry scaffoldGeometry,
      {double offset = 0.0}) {
    assert(scaffoldGeometry.textDirection != null);
    switch (scaffoldGeometry.textDirection) {
      case TextDirection.rtl:
        return _leftOffset(scaffoldGeometry, offset: offset);
      case TextDirection.ltr:
        return _rightOffset(scaffoldGeometry, offset: offset);
    }
    return null;
  }

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    // Compute the x-axis offset.
    final double fabX = _endOffset(scaffoldGeometry);

    // Compute the y-axis offset.
    final double contentBottom = scaffoldGeometry.contentBottom;
    final double bottomSheetHeight = scaffoldGeometry.bottomSheetSize.height;
    final double fabHeight = scaffoldGeometry.floatingActionButtonSize.height;
    final double snackBarHeight = scaffoldGeometry.snackBarSize.height;

    double fabY = contentBottom - fabHeight - kFloatingActionButtonMargin;
    if (snackBarHeight > 0.0)
      fabY = math.min(
          fabY,
          contentBottom -
              snackBarHeight -
              fabHeight -
              kFloatingActionButtonMargin);
    if (bottomSheetHeight > 0.0)
      fabY =
          math.min(fabY, contentBottom - bottomSheetHeight - fabHeight / 2.0);
    if (isAssetNotEmpty)
      fabY -= 100.0;

    return Offset(fabX, fabY);
  }
}
