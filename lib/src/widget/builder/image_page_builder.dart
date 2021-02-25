///
/// [Author] Alex (https://github.com/Alex525)
/// [Date] 2020/4/6 15:07
///
import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart';

import 'package:wechat_assets_picker/src/constants/constants.dart';

class ImagePageBuilder extends StatefulWidget {
  const ImagePageBuilder({
    Key? key,
    required this.asset,
    required this.state,
    this.previewThumbSize,
  }) : super(key: key);

  /// Asset currently displayed.
  /// 展示的资源
  final AssetEntity asset;

  /// [State] for asset picker viewer.
  /// 资源查看器的状态[State]
  final AssetPickerViewerState<AssetEntity, AssetPathEntity> state;

  final List<int>? previewThumbSize;

  @override
  _ImagePageBuilderState createState() => _ImagePageBuilderState();
}

class _ImagePageBuilderState extends State<ImagePageBuilder> {
  DefaultAssetPickerViewerBuilderDelegate get builder =>
      widget.state.builder as DefaultAssetPickerViewerBuilderDelegate;

  bool loaded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: builder.switchDisplayingDetail,
      child: ExtendedImage(
        image: AssetEntityImageProvider(
          widget.asset,
          isOriginal: widget.previewThumbSize == null,
          thumbSize: widget.previewThumbSize,
        ),
        fit: BoxFit.contain,
        mode: ExtendedImageMode.gesture,
        onDoubleTap: builder.updateAnimation,
        initGestureConfigHandler: (ExtendedImageState state) {
          return GestureConfig(
            initialScale: 1.0,
            minScale: 1.0,
            maxScale: 3.0,
            animationMinScale: 0.6,
            animationMaxScale: 4.0,
            cacheGesture: false,
            inPageView: true,
          );
        },
        loadStateChanged: (ExtendedImageState state) {
          if (state.extendedImageLoadState == LoadState.completed) {
            loaded = true;
          }
          return builder.previewWidgetLoadStateChanged(
            context,
            state,
            hasLoaded: loaded,
          );
        },
      ),
    );
  }
}
