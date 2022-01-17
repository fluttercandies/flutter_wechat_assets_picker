///
/// [Author] Alex (https://github.com/Alex525)
/// [Date] 2020/4/6 15:07
///
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../delegates/asset_picker_viewer_builder_delegate.dart';
import 'locally_available_builder.dart';

class ImagePageBuilder extends StatefulWidget {
  const ImagePageBuilder({
    Key? key,
    required this.asset,
    required this.delegate,
    this.previewThumbSize,
  }) : super(key: key);

  /// Asset currently displayed.
  /// 展示的资源
  final AssetEntity asset;

  final AssetPickerViewerBuilderDelegate<AssetEntity, AssetPathEntity> delegate;

  final List<int>? previewThumbSize;

  @override
  _ImagePageBuilderState createState() => _ImagePageBuilderState();
}

class _ImagePageBuilderState extends State<ImagePageBuilder> {
  @override
  Widget build(BuildContext context) {
    return LocallyAvailableBuilder(
      asset: widget.asset,
      isOriginal: widget.previewThumbSize == null,
      builder: (BuildContext context, AssetEntity asset) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.delegate.switchDisplayingDetail,
          child: ExtendedImage(
            image: AssetEntityImageProvider(
              asset,
              isOriginal: widget.previewThumbSize == null,
              thumbSize: widget.previewThumbSize,
            ),
            fit: BoxFit.contain,
            mode: ExtendedImageMode.gesture,
            onDoubleTap: widget.delegate.updateAnimation,
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
              return widget.delegate.previewWidgetLoadStateChanged(
                context,
                state,
                hasLoaded: state.extendedImageLoadState == LoadState.completed,
              );
            },
          ),
        );
      },
    );
  }
}
