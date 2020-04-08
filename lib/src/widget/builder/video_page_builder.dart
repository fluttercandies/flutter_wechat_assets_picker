///
/// [Author] Alex (https://github.com/AlexVincent525)
/// [Date] 2020/4/6 18:58
///
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart';
import 'package:video_player/video_player.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../../constants/constants.dart';

class VideoPageBuilder extends StatefulWidget {
  const VideoPageBuilder({Key key, this.asset, this.state}) : super(key: key);

  /// Asset currently displayed.
  /// 展示的资源
  final AssetEntity asset;

  /// [State] for asset picker viewer.
  /// 资源查看器的状态[State]
  final AssetPickerViewerState state;

  @override
  _VideoPageBuilderState createState() => _VideoPageBuilderState();
}

class _VideoPageBuilderState extends State<VideoPageBuilder> {
  /// Controller for video player.
  /// 视频播放的控制器
  VideoPlayerController _controller;

  /// Whether the player is playing.
  /// 播放器是否在播放
  bool isPlaying = false;

  /// Whether the controller is playing.
  /// 播放控制器是否在播放
  bool get isControllerPlaying => _controller?.value?.isPlaying ?? false;

  @override
  void initState() {
    super.initState();

    /// Get media url from asset, then initialize the controller and add with listener.
    /// 从资源获取媒体url后初始化，并添加监听。
    widget.asset.getMediaUrl().then((String url) {
      _controller = VideoPlayerController.network(Uri.parse(url).toString())
        ..initialize()
        ..addListener(videoPlayerListener);
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    /// Remove listener from the controller and dispose it when widget dispose.
    /// 部件销毁时移除控制器的监听并销毁控制器。
    _controller?.removeListener(videoPlayerListener);
    _controller?.dispose();
    super.dispose();
  }

  /// Listener for the video player.
  /// 播放器的监听方法
  ///
  /// Set [allowSwitchPages] in state to false if the video is playing.
  /// 当视频正在播放时禁止切换页面
  void videoPlayerListener() {
    widget.state.allowSwitchPages(!(_controller.value?.isPlaying ?? false));
    if (isControllerPlaying != isPlaying) {
      isPlaying = isControllerPlaying;
      if (mounted) {
        setState(() {});
      }
    }
  }

  /// Callback for the play button.
  /// 播放按钮的回调
  ///
  /// Normally it only switch play state for the player. If the video reaches the end, then click
  /// the button will make the video replay.
  /// 一般来说按钮只切换播放暂停。当视频播放结束时，点击按钮将从头开始播放。
  Future<void> playButtonCallback() async {
    if (_controller.value != null) {
      if (isPlaying) {
        _controller.pause();
      } else {
        if (_controller.value.duration == _controller.value.position) {
          _controller
            ..seekTo(Duration.zero)
            ..play();
        } else {
          _controller.play();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: ExtendedImage(
            image: AssetEntityImageProvider(
              widget.asset,
              thumbSize: math.min(Screens.widthPixels, widget.asset.width),
              isOriginal: false,
            ),
            fit: BoxFit.contain,
            loadStateChanged: widget.state.previewWidgetLoadStateChanged,
          ),
        ),
        if (_controller != null)
          Positioned.fill(
            child: Center(
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
            ),
          ),
        if (_controller != null)
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: isPlaying
                ? _controller.pause
                : widget.state.switchDisplayingDetail,
            child: Center(
              child: AnimatedOpacity(
                duration: kThemeAnimationDuration,
                opacity: isControllerPlaying ? 0.0 : 1.0,
                child: GestureDetector(
                  onTap: playButtonCallback,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      boxShadow: <BoxShadow>[BoxShadow(color: Colors.black12)],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      (_controller?.value?.isPlaying ?? false)
                          ? Icons.pause_circle_outline
                          : Icons.play_circle_filled,
                      size: 70.0,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
