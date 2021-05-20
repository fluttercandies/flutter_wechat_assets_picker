///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2021/5/11 11:37
///
import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart';

import '../../constants/constants.dart';
import '../../provider/asset_entity_image_provider.dart';
import 'fade_image_builder.dart';

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
  AssetEntityImageProvider get imageProvider => widget.image;

  Widget? child;

  Widget get newChild {
    return ExtendedImage(
      image: imageProvider,
      fit: BoxFit.cover,
      loadStateChanged: (ExtendedImageState state) {
        Widget loader = const SizedBox.shrink();
        switch (state.extendedImageLoadState) {
          case LoadState.loading:
            loader = const ColoredBox(color: Color(0x10ffffff));
            break;
          case LoadState.completed:
            loader = FadeImageBuilder(
              child: RepaintBoundary(child: state.completedWidget),
            );
            break;
          case LoadState.failed:
            loader = widget.failedItemBuilder(context);
            break;
        }
        return loader;
      },
    );
  }

  /// Item widgets when the thumb data load failed.
  /// 资源缩略数据加载失败时使用的部件
  Widget failedItemBuilder(BuildContext context) {
    return Center(
      child: Text(
        Constants.textDelegate.loadFailed,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 18.0),
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
