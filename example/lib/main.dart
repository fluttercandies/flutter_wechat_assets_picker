import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      if (mounted) {
        setState(() {});
      }
    }
  }

  void removeAsset(int index) {
    setState(() {
      assets.remove(assets.elementAt(index));
    });
  }

  Widget get textField => Expanded(
        child: TextField(
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(16.0),
            hintText: 'Type something here...',
            isDense: true,
          ),
          style: const TextStyle(fontSize: 18.0),
          maxLines: null,
        ),
      );

  Widget assetItemBuilder(BuildContext _, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
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
      child: Image(
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
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_library),
            onPressed: selectAssets,
            tooltip: 'Select Assets',
          ),
        ],
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
    );
  }
}
