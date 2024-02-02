// Copyright 2019 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by an Apache license that can be found
// in the LICENSE file.

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';
import 'package:wechat_picker_library/wechat_picker_library.dart';

import '../../internals/singleton.dart';

class AssetEntityGridItemBuilder extends StatefulWidget {
  const AssetEntityGridItemBuilder({
    super.key,
    required this.image,
    required this.failedItemBuilder,
  });

  final AssetEntityImageProvider image;
  final WidgetBuilder failedItemBuilder;

  @override
  AssetEntityGridItemWidgetState createState() =>
      AssetEntityGridItemWidgetState();
}

class AssetEntityGridItemWidgetState extends State<AssetEntityGridItemBuilder> {
  Widget? child;

  Widget get newChild {
    return ExtendedImage(
      image: widget.image,
      fit: BoxFit.cover,
      loadStateChanged: (ExtendedImageState state) =>
          switch (state.extendedImageLoadState) {
        LoadState.loading => const ColoredBox(color: Color(0x10ffffff)),
        LoadState.completed => RepaintBoundary(child: state.completedWidget),
        LoadState.failed => widget.failedItemBuilder(context),
      },
    );
  }

  /// Item widgets when the thumbnail data load failed.
  /// 资源缩略数据加载失败时使用的部件
  Widget failedItemBuilder(BuildContext context) {
    return Center(
      child: ScaleText(
        Singleton.textDelegate.loadFailed,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 18.0),
        semanticsLabel: Singleton.textDelegate.semanticsTextDelegate.loadFailed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    child ??= newChild;
    return child!;
  }
}
