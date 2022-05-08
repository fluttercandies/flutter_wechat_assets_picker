// Copyright 2019 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by an Apache license that can be found
// in the LICENSE file.

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../internal/singleton.dart';
import '../../widget/scale_text.dart';

class AssetEntityGridItemBuilder extends StatefulWidget {
  const AssetEntityGridItemBuilder({
    Key? key,
    required this.image,
    required this.failedItemBuilder,
  }) : super(key: key);

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
      loadStateChanged: (ExtendedImageState state) {
        Widget loader = const SizedBox.shrink();
        switch (state.extendedImageLoadState) {
          case LoadState.loading:
            loader = const ColoredBox(color: Color(0x10ffffff));
            break;
          case LoadState.completed:
            loader = RepaintBoundary(child: state.completedWidget);
            break;
          case LoadState.failed:
            loader = widget.failedItemBuilder(context);
            break;
        }
        return loader;
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
  @mustCallSuper
  Widget build(BuildContext context) {
    child ??= newChild;
    return child!;
  }
}
