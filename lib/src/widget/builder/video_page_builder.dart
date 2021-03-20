///
/// [Author] Alex (https://github.com/Alex525)
/// [Date] 2020/4/6 18:58
///
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'package:wechat_assets_picker/src/constants/constants.dart';

class VideoPageBuilder extends StatefulWidget {
  const VideoPageBuilder({
    Key? key,
    required this.asset,
    required this.state,
  }) : super(key: key);

  /// Asset currently displayed.
  /// 展示的资源
  final AssetEntity asset;

  /// [State] for asset picker viewer.
  /// 资源查看器的状态[State]
  final AssetPickerViewerState<AssetEntity, AssetPathEntity> state;

  @override
  _VideoPageBuilderState createState() => _VideoPageBuilderState();
}

class _VideoPageBuilderState extends State<VideoPageBuilder> {
  /// Controller for the video player.
  /// 视频播放的控制器
  late final VideoPlayerController _controller;

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
  bool get isControllerPlaying => _controller.value.isPlaying;

  DefaultAssetPickerViewerBuilderDelegate get builder =>
      widget.state.builder as DefaultAssetPickerViewerBuilderDelegate;

  @override
  void initState() {
    super.initState();
    initializeVideoPlayerController();
  }

  @override
  void dispose() {
    /// Remove listener from the controller and dispose it when widget dispose.
    /// 部件销毁时移除控制器的监听并销毁控制器。
    _controller.removeListener(videoPlayerListener);
    _controller.pause();
    _controller.dispose();
    super.dispose();
  }

  /// Get media url from the asset, then initialize the controller and add with a listener.
  /// 从资源获取媒体url后初始化，并添加监听。
  Future<void> initializeVideoPlayerController() async {
    final String? url = await widget.asset.getMediaUrl();
    if (url == null) {
      hasErrorWhenInitializing = true;
      if (mounted) {
        setState(() {});
      }
      return;
    }
    _controller = VideoPlayerController.network(Uri.parse(url).toString());
    try {
      await _controller.initialize();
      hasLoaded = true;
      _controller.addListener(videoPlayerListener);
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
      _controller.pause();
    } else {
      if (builder.isDisplayingDetail.value) {
        builder.switchDisplayingDetail(value: false);
      }
      if (_controller.value.duration == _controller.value.position) {
        _controller
          ..seekTo(Duration.zero)
          ..play();
      } else {
        _controller.play();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (hasErrorWhenInitializing) {
      return Center(child: Text(Constants.textDelegate.loadFailed));
    }
    if (!hasLoaded) {
      return const SizedBox.shrink();
    }
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Positioned.fill(
          child: Center(
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),
          ),
        ),
        ValueListenableBuilder<bool>(
          valueListenable: isPlaying,
          builder: (_, bool value, __) => GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: value ? playButtonCallback : builder.switchDisplayingDetail,
            child: Center(
              child: AnimatedOpacity(
                duration: kThemeAnimationDuration,
                opacity: value ? 0.0 : 1.0,
                child: GestureDetector(
                  onTap: playButtonCallback,
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                      boxShadow: <BoxShadow>[BoxShadow(color: Colors.black12)],
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
}
