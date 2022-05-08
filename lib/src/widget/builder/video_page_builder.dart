// Copyright 2019 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by an Apache license that can be found
// in the LICENSE file.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:video_player/video_player.dart';

import '../../delegates/asset_picker_viewer_builder_delegate.dart';
import '../../internal/methods.dart';
import '../../internal/singleton.dart';
import '../scale_text.dart';
import 'locally_available_builder.dart';

class VideoPageBuilder extends StatefulWidget {
  const VideoPageBuilder({
    Key? key,
    required this.asset,
    required this.delegate,
    this.hasOnlyOneVideoAndMoment = false,
  }) : super(key: key);

  /// Asset currently displayed.
  /// 展示的资源
  final AssetEntity asset;

  final AssetPickerViewerBuilderDelegate<AssetEntity, AssetPathEntity> delegate;

  /// Only previewing one video and with the [SpecialPickerType.wechatMoment].
  /// 是否处于 [SpecialPickerType.wechatMoment] 且只有一个视频
  final bool hasOnlyOneVideoAndMoment;

  @override
  _VideoPageBuilderState createState() => _VideoPageBuilderState();
}

class _VideoPageBuilderState extends State<VideoPageBuilder> {
  /// Controller for the video player.
  /// 视频播放的控制器
  VideoPlayerController get controller => _controller!;
  VideoPlayerController? _controller;

  /// Whether the controller has initialized.
  /// 控制器是否已初始化
  bool hasLoaded = false;

  /// Whether there's any error when initialize the video controller.
  /// 初始化视频控制器时是否发生错误
  bool hasErrorWhenInitializing = false;

  /// Whether the player is playing.
  /// 播放器是否在播放
  final ValueNotifier<bool> isPlaying = ValueNotifier<bool>(false);

  /// Whether the controller is playing.
  /// 播放控制器是否在播放
  bool get isControllerPlaying => _controller?.value.isPlaying ?? false;

  bool _isInitializing = false;
  bool _isLocallyAvailable = false;

  @override
  void dispose() {
    /// Remove listener from the controller and dispose it when widget dispose.
    /// 部件销毁时移除控制器的监听并销毁控制器。
    _controller
      ?..removeListener(videoPlayerListener)
      ..pause()
      ..dispose();
    super.dispose();
  }

  /// Get media url from the asset, then initialize the controller and add with a listener.
  /// 从资源获取媒体url后初始化，并添加监听。
  Future<void> initializeVideoPlayerController() async {
    _isInitializing = true;
    _isLocallyAvailable = true;
    final String? url = await widget.asset.getMediaUrl();
    if (url == null) {
      hasErrorWhenInitializing = true;
      if (mounted) {
        setState(() {});
      }
      return;
    }
    if (Platform.isAndroid) {
      _controller = VideoPlayerController.contentUri(Uri.parse(url));
    } else {
      _controller = VideoPlayerController.network(url);
    }
    try {
      await controller.initialize();
      hasLoaded = true;
      controller
        ..addListener(videoPlayerListener)
        ..setLooping(widget.hasOnlyOneVideoAndMoment);
      if (widget.hasOnlyOneVideoAndMoment) {
        controller.play();
      }
    } catch (e) {
      realDebugPrint('Error when initialize video controller: $e');
      hasErrorWhenInitializing = true;
    } finally {
      if (mounted) {
        setState(() {});
      }
    }
  }

  /// Listener for the video player.
  /// 播放器的监听方法
  void videoPlayerListener() {
    if (isControllerPlaying != isPlaying.value) {
      isPlaying.value = isControllerPlaying;
    }
  }

  /// Callback for the play button.
  /// 播放按钮的回调
  ///
  /// Normally it only switches play state for the player. If the video reaches the end,
  /// then click the button will make the video replay.
  /// 一般来说按钮只切换播放暂停。当视频播放结束时，点击按钮将从头开始播放。
  Future<void> playButtonCallback() async {
    if (isPlaying.value) {
      controller.pause();
      return;
    }
    if (widget.delegate.isDisplayingDetail.value) {
      widget.delegate.switchDisplayingDetail(value: false);
    }
    if (controller.value.duration == controller.value.position) {
      controller
        ..seekTo(Duration.zero)
        ..play();
      return;
    }
    controller.play();
  }

  Widget _contentBuilder(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Positioned.fill(
          child: Center(
            child: AspectRatio(
              aspectRatio: controller.value.aspectRatio,
              child: VideoPlayer(controller),
            ),
          ),
        ),
        if (!widget.hasOnlyOneVideoAndMoment)
          ValueListenableBuilder<bool>(
            valueListenable: isPlaying,
            builder: (_, bool value, __) => GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: value
                  ? playButtonCallback
                  : widget.delegate.switchDisplayingDetail,
              child: Center(
                child: AnimatedOpacity(
                  duration: kThemeAnimationDuration,
                  opacity: value ? 0.0 : 1.0,
                  child: GestureDetector(
                    onTap: playButtonCallback,
                    child: DecoratedBox(
                      decoration: const BoxDecoration(
                        boxShadow: <BoxShadow>[
                          BoxShadow(color: Colors.black12)
                        ],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        value
                            ? Icons.pause_circle_outline
                            : Icons.play_circle_filled,
                        size: 70.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return LocallyAvailableBuilder(
      asset: widget.asset,
      builder: (BuildContext context, AssetEntity asset) {
        if (hasErrorWhenInitializing) {
          return Center(
            child: ScaleText(
              Singleton.textDelegate.loadFailed,
              semanticsLabel:
                  Singleton.textDelegate.semanticsTextDelegate.loadFailed,
            ),
          );
        }
        if (!_isLocallyAvailable && !_isInitializing) {
          initializeVideoPlayerController();
        }
        if (!hasLoaded) {
          return const SizedBox.shrink();
        }
        return Semantics(
          onLongPress: playButtonCallback,
          onLongPressHint:
              Singleton.textDelegate.semanticsTextDelegate.sActionPlayHint,
          child: GestureDetector(
            onLongPress: MediaQuery.of(context).accessibleNavigation
                ? playButtonCallback
                : null,
            child: _contentBuilder(context),
          ),
        );
      },
    );
  }
}
