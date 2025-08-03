// Copyright 2019 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by an Apache license that can be found
// in the LICENSE file.

import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:wechat_picker_library/wechat_picker_library.dart';

import '../../constants/constants.dart';
import '../../delegates/asset_picker_text_delegate.dart';
import '../../delegates/asset_picker_viewer_builder_delegate.dart';

class ImagePageBuilder extends StatefulWidget {
  const ImagePageBuilder({
    super.key,
    required this.asset,
    required this.delegate,
    this.previewThumbnailSize,
    this.shouldAutoplayPreview = false,
  });

  /// Asset currently displayed.
  /// 展示的资源
  final AssetEntity asset;

  final AssetPickerViewerBuilderDelegate<AssetEntity, AssetPathEntity> delegate;

  final ThumbnailSize? previewThumbnailSize;

  /// Whether the preview should auto play.
  /// 预览是否自动播放
  final bool shouldAutoplayPreview;

  @override
  State<ImagePageBuilder> createState() => _ImagePageBuilderState();
}

class _ImagePageBuilderState extends State<ImagePageBuilder> {
  bool _isLocallyAvailable = false;
  VideoPlayerController? _livePhotoVideoController;

  bool get _isOriginal => widget.previewThumbnailSize == null;

  bool get _isLivePhoto => widget.asset.isLivePhoto;

  @override
  void didUpdateWidget(ImagePageBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.asset != oldWidget.asset ||
        widget.previewThumbnailSize != oldWidget.previewThumbnailSize) {
      _isLocallyAvailable = false;
      _livePhotoVideoController
        ?..pause()
        ..dispose();
      _livePhotoVideoController = null;
    }
  }

  @override
  void dispose() {
    _livePhotoVideoController?.dispose();
    super.dispose();
  }

  Future<void> _initializeLivePhoto() async {
    final File? file;
    if (_isOriginal) {
      file = await widget.asset.originFileWithSubtype;
    } else {
      file = await widget.asset.fileWithSubtype;
    }
    if (!mounted || file == null) {
      return;
    }
    final VideoPlayerController c = VideoPlayerController.file(
      file,
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );
    await c.initialize();
    safeSetState(() {
      _livePhotoVideoController = c;
    });
    c.addListener(() {
      safeSetState(() {});
    });
  }

  Widget _imageBuilder(BuildContext context, AssetEntity asset) {
    return ExtendedImage(
      image: AssetEntityImageProvider(
        asset,
        isOriginal: _isOriginal,
        thumbnailSize: widget.previewThumbnailSize,
      ),
      fit: BoxFit.contain,
      mode: ExtendedImageMode.gesture,
      onDoubleTap: widget.delegate.updateAnimation,
      initGestureConfigHandler: (ExtendedImageState state) => GestureConfig(
        minScale: 1.0,
        maxScale: 3.0,
        animationMinScale: 0.6,
        animationMaxScale: 4.0,
        inPageView: true,
        initialAlignment: InitialAlignment.center,
      ),
      loadStateChanged: (ExtendedImageState state) {
        final imageWidget = widget.delegate.previewWidgetLoadStateChanged(
          context,
          state,
          hasLoaded: state.extendedImageLoadState == LoadState.completed,
        );
        if (_isLivePhoto && _livePhotoVideoController != null) {
          return _LivePhotoWidget(
            controller: _livePhotoVideoController!,
            fit: BoxFit.contain,
            state: state,
            textDelegate: widget.delegate.textDelegate,
          );
        }
        return imageWidget;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return LocallyAvailableBuilder(
      key: ValueKey<String>(widget.asset.id),
      asset: widget.asset,
      isOriginal: _isOriginal,
      withSubtype: _isOriginal,
      thumbnailOption: switch (widget.previewThumbnailSize) {
        final size? => ThumbnailOption(size: size),
        _ => null,
      },
      builder: (BuildContext context, AssetEntity asset) {
        // Initialize the video controller when the asset is a Live photo
        // and available for further use.
        if (!_isLocallyAvailable && _isLivePhoto) {
          _initializeLivePhoto();
        }
        _isLocallyAvailable = true;
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.delegate.switchDisplayingDetail,
          child: _imageBuilder(context, asset),
        );
      },
    );
  }
}

class _LivePhotoWidget extends StatefulWidget {
  const _LivePhotoWidget({
    required this.controller,
    required this.state,
    required this.fit,
    required this.textDelegate,
  });

  final VideoPlayerController controller;
  final ExtendedImageState state;
  final BoxFit fit;
  final AssetPickerTextDelegate textDelegate;

  @override
  State<_LivePhotoWidget> createState() => _LivePhotoWidgetState();
}

class _LivePhotoWidgetState extends State<_LivePhotoWidget> {
  final _showVideo = ValueNotifier<bool>(false);
  late final _controller = widget.controller;

  ScrollNotificationObserverState? _scrollNotificationObserver;
  bool _scrolling = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_notify);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scrollNotificationObserver?.removeListener(_handleScrollNotification);
    _scrollNotificationObserver = ScrollNotificationObserver.maybeOf(context);
    _scrollNotificationObserver?.addListener(_handleScrollNotification);
  }

  @override
  void dispose() {
    _scrollNotificationObserver?.removeListener(_handleScrollNotification);
    _controller.pause();
    _controller.removeListener(_notify);
    _showVideo.dispose();
    super.dispose();
  }

  void _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollStartNotification) {
      _scrolling = true;
    } else if (notification is ScrollEndNotification) {
      _scrolling = false;
    }
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    final fraction = info.visibleFraction;
    if (fraction == 1 && !_showVideo.value && !_scrolling) {
      _showVideoAndPlay();
    } else if (fraction < 1 && _showVideo.value) {
      _hideVideoAndStop();
    }
  }

  Future<void> _notify() async {
    if (_controller.value.position >= _controller.value.duration) {
      await _controller.pause();
      await _controller.seekTo(Duration.zero);
      _showVideo.value = false;
    }
  }

  Future<void> _showVideoAndPlay() async {
    if (_controller.value.isPlaying) {
      return;
    }
    HapticFeedback.lightImpact();
    _showVideo.value = true;
    await _controller.play();
  }

  Future<void> _hideVideoAndStop() async {
    _showVideo.value = false;
    await Future.delayed(kThemeChangeDuration);
    await _controller.pause();
    await _controller.seekTo(Duration.zero);
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: ValueKey(widget.state),
      onVisibilityChanged: _onVisibilityChanged,
      child: GestureDetector(
        onLongPress: () {
          _showVideoAndPlay();
        },
        onLongPressUp: () {
          _hideVideoAndStop();
        },
        child: ExtendedImageGesture(
          widget.state,
          imageBuilder: (
            Widget image, {
            ExtendedImageGestureState? imageGestureState,
          }) {
            return ValueListenableBuilder(
              valueListenable: _showVideo,
              builder: (context, showVideo, child) {
                if (imageGestureState == null ||
                    widget.state.extendedImageInfo == null) {
                  return child!;
                }
                final scaled = imageGestureState.gestureDetails?.totalScale !=
                    imageGestureState.imageGestureConfig?.initialScale;
                final size = MediaQuery.sizeOf(context);
                final imageRect =
                    GestureWidgetDelegateFromState.getRectFormState(
                  Offset.zero & size,
                  imageGestureState,
                  copy: true,
                );
                final videoRect =
                    GestureWidgetDelegateFromState.getRectFormState(
                  Offset.zero & size,
                  imageGestureState,
                  width: _controller.value.size.width,
                  height: _controller.value.size.height,
                  copy: true,
                );
                return Stack(
                  children: <Widget>[
                    imageGestureState.wrapGestureWidget(
                      FittedBox(
                        fit: BoxFit.cover,
                        clipBehavior: Clip.hardEdge,
                        child: SizedBox(
                          width: videoRect.width,
                          height: videoRect.height,
                          child: VideoPlayer(_controller),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: AnimatedOpacity(
                        duration: kThemeChangeDuration,
                        opacity: showVideo ? 0.0 : 1.0,
                        child: child!,
                      ),
                    ),
                    Positioned.fromRect(
                      rect: imageRect,
                      child: AnimatedOpacity(
                        duration: kThemeChangeDuration,
                        opacity: showVideo || scaled ? 0.0 : 1.0,
                        child: _buildLivePhotoIndicator(context),
                      ),
                    ),
                  ],
                );
              },
              child: image,
            );
          },
        ),
      ),
    );
  }

  Widget _buildLivePhotoIndicator(BuildContext context) {
    return Container(
      alignment: AlignmentDirectional.bottomStart,
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/icon/indicator-live-photos.png',
            width: 24.0,
            height: 24.0,
            package: packageName,
            gaplessPlayback: true,
            color: Colors.white,
          ),
          const SizedBox(width: 2.0),
          Text(
            widget.textDelegate.livePhotoIndicator,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14.0,
            ),
            semanticsLabel:
                widget.textDelegate.semanticsTextDelegate.livePhotoIndicator,
            strutStyle: const StrutStyle(forceStrutHeight: true, height: 1),
          ),
        ],
      ),
    );
  }
}
