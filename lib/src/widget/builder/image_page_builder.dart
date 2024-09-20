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
import 'package:wechat_picker_library/wechat_picker_library.dart';

import '../../constants/constants.dart';
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
  bool _showLivePhotoIndicator = true;
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
    safeSetState(() {
      _livePhotoVideoController = c;
    });
    c
      ..initialize().then((_) {
        _play();
      })
      ..setVolume(0)
      ..addListener(() {
        safeSetState(() {});
      });
  }

  void _play() {
    if (_livePhotoVideoController?.value.isInitialized ?? false) {
      // Only impact when initialized.
      HapticFeedback.lightImpact();
      _livePhotoVideoController?.play();
    }
  }

  Future<void> _stop() async {
    await _livePhotoVideoController?.pause();
    await _livePhotoVideoController?.seekTo(Duration.zero);
  }

  Widget _buildLivePhotoIndicator(BuildContext context) {
    return Row(
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
          widget.delegate.textDelegate.livePhotoIndicator,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14.0,
          ),
          semanticsLabel:
              widget.delegate.semanticsTextDelegate.livePhotoIndicator,
          strutStyle: const StrutStyle(forceStrutHeight: true, height: 1),
        ),
      ],
    );
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
        gestureDetailsIsChanged: (details) {
          final scale = details?.totalScale;
          if (scale == null) {
            return;
          }
          if (scale != 1.0 && _showLivePhotoIndicator) {
            safeSetState(() {
              _showLivePhotoIndicator = false;
            });
          } else if (scale == 1.0 && !_showLivePhotoIndicator) {
            safeSetState(() {
              _showLivePhotoIndicator = true;
            });
          }
        },
      ),
      loadStateChanged: (ExtendedImageState state) {
        final Size? imageSize;
        final double? aspectRatio;
        if (state.extendedImageInfo case final imageInfo?) {
          final dpr = MediaQuery.devicePixelRatioOf(context);
          imageSize = Size(
            imageInfo.image.width / dpr,
            imageInfo.image.height / dpr,
          );
          aspectRatio = imageSize.aspectRatio;
        } else {
          imageSize = null;
          aspectRatio = _livePhotoVideoController?.value.aspectRatio;
        }
        Widget imageWidget = widget.delegate.previewWidgetLoadStateChanged(
          context,
          state,
          hasLoaded: state.extendedImageLoadState == LoadState.completed,
        );
        if (_isLivePhoto && _showLivePhotoIndicator) {
          imageWidget = Stack(
            alignment: Alignment.center,
            children: [
              imageWidget,
              PositionedDirectional(
                start: 20.0,
                bottom: 20.0,
                child: _buildLivePhotoIndicator(context),
              ),
            ],
          );
        }
        if (imageSize case final size?) {
          imageWidget = Center(
            child: AspectRatio(
              aspectRatio: size.aspectRatio,
              child: imageWidget,
            ),
          );
        }
        return Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: [
            if (_livePhotoVideoController case final controller?) ...[
              ValueListenableBuilder(
                valueListenable: controller,
                builder: (context, value, child) => AnimatedSwitcher(
                  duration: kThemeChangeDuration,
                  child: AspectRatio(
                    aspectRatio: aspectRatio!,
                    child: child,
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    PositionedDirectional(
                      start: 0,
                      end: 0,
                      child: AspectRatio(
                        aspectRatio: controller.value.aspectRatio,
                        child: IgnorePointer(child: VideoPlayer(controller)),
                      ),
                    ),
                  ],
                ),
              ),
              ValueListenableBuilder(
                valueListenable: controller,
                builder: (context, value, child) => AnimatedOpacity(
                  opacity: value.isPlaying ? 0 : 1,
                  duration: kThemeChangeDuration,
                  child: child,
                ),
                child: imageWidget,
              ),
            ] else
              imageWidget,
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return LocallyAvailableBuilder(
      key: ValueKey<String>(widget.asset.id),
      asset: widget.asset,
      isOriginal: _isOriginal,
      builder: (BuildContext context, AssetEntity asset) {
        // Initialize the video controller when the asset is a Live photo
        // and available for further use.
        if (!_isLocallyAvailable && _isLivePhoto) {
          _initializeLivePhoto();
        }
        _isLocallyAvailable = true;
        // TODO(Alex): Wait until `extended_image` support synchronized zooming.
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.delegate.switchDisplayingDetail,
          onLongPress: _isLivePhoto ? _play : null,
          onLongPressEnd: _isLivePhoto
              ? (_) {
                  _stop();
                }
              : null,
          child: Builder(
            builder: (context) => _imageBuilder(context, asset),
          ),
        );
      },
    );
  }
}
