// Copyright 2019 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by an Apache license that can be found
// in the LICENSE file.

import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:video_player/video_player.dart';

import '../../delegates/asset_picker_viewer_builder_delegate.dart';
import 'locally_available_builder.dart';

class ImagePageBuilder extends StatefulWidget {
  const ImagePageBuilder({
    super.key,
    required this.asset,
    required this.delegate,
    this.previewThumbnailSize,
  });

  /// Asset currently displayed.
  /// 展示的资源
  final AssetEntity asset;

  final AssetPickerViewerBuilderDelegate<AssetEntity, AssetPathEntity> delegate;

  final ThumbnailSize? previewThumbnailSize;

  @override
  State<ImagePageBuilder> createState() => _ImagePageBuilderState();
}

class _ImagePageBuilderState extends State<ImagePageBuilder> {
  bool _isLocallyAvailable = false;
  VideoPlayerController? _controller;

  bool get _isOriginal => widget.previewThumbnailSize == null;

  bool get _isLivePhoto => widget.asset.isLivePhoto;

  @override
  void dispose() {
    _controller?.dispose();
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
    setState(() => _controller = c);
    c
      ..initialize()
      ..setVolume(0)
      ..addListener(() {
        if (mounted) {
          setState(() {});
        }
      });
  }

  void _play() {
    if (_controller?.value.isInitialized ?? false) {
      // Only impact when initialized.
      HapticFeedback.lightImpact();
      _controller?.play();
    }
  }

  Future<void> _stop() async {
    await _controller?.pause();
    await _controller?.seekTo(Duration.zero);
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
      ),
      loadStateChanged: (ExtendedImageState state) {
        return widget.delegate.previewWidgetLoadStateChanged(
          context,
          state,
          hasLoaded: state.extendedImageLoadState == LoadState.completed,
        );
      },
    );
  }

  Widget _buildLivePhotosWrapper(BuildContext context, AssetEntity asset) {
    return Stack(
      children: <Widget>[
        if (_controller?.value.isInitialized ?? false)
          Center(
            child: AspectRatio(
              aspectRatio: _controller!.value.aspectRatio,
              child: ValueListenableBuilder<VideoPlayerValue>(
                valueListenable: _controller!,
                builder: (_, VideoPlayerValue value, Widget? child) {
                  return Opacity(
                    opacity: value.isPlaying ? 1 : 0,
                    child: child,
                  );
                },
                child: VideoPlayer(_controller!),
              ),
            ),
          ),
        if (_controller == null)
          Positioned.fill(child: _imageBuilder(context, asset))
        else
          Positioned.fill(
            child: ValueListenableBuilder<VideoPlayerValue>(
              valueListenable: _controller!,
              builder: (_, VideoPlayerValue value, Widget? child) {
                return Opacity(
                  opacity: value.isPlaying ? 0 : 1,
                  child: child,
                );
              },
              child: _imageBuilder(context, asset),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return LocallyAvailableBuilder(
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
          onLongPress: _isLivePhoto ? () => _play() : null,
          onLongPressEnd: _isLivePhoto ? (_) => _stop() : null,
          child: Builder(
            builder: (BuildContext context) {
              if (!_isLivePhoto) {
                return _imageBuilder(context, asset);
              }
              return _buildLivePhotosWrapper(context, asset);
            },
          ),
        );
      },
    );
  }
}
