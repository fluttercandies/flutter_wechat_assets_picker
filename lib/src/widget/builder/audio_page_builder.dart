///
/// [Author] Alex (https://github.com/Alex525)
/// [Date] 2020/5/21 14:18
///
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:video_player/video_player.dart';

import '../../constants/extensions.dart';
import '../../internal/methods.dart';
import '../../internal/singleton.dart';
import '../scale_text.dart';

class AudioPageBuilder extends StatefulWidget {
  const AudioPageBuilder({Key? key, required this.asset}) : super(key: key);

  /// Asset currently displayed.
  /// 展示的资源
  final AssetEntity asset;

  @override
  State<StatefulWidget> createState() => _AudioPageBuilderState();
}

class _AudioPageBuilderState extends State<AudioPageBuilder> {
  /// A [StreamController] for current position of the [_controller].
  /// 控制器当前的播放进度
  final StreamController<Duration> durationStreamController =
      StreamController<Duration>.broadcast();

  /// Create a [VideoPlayerController] instance for the page builder state.
  /// 创建一个 [VideoPlayerController] 的实例
  late final VideoPlayerController _controller;

  /// Whether the audio loaded.
  /// 音频是否已经加载完成
  bool isLoaded = false;

  /// Whether the player is playing.
  /// 播放器是否在播放
  bool isPlaying = false;

  /// Whether the controller is playing.
  /// 播放控制器是否在播放
  bool get isControllerPlaying => _controller.value.isPlaying;

  /// Duration of the audio.
  /// 音频的时长
  late final Duration assetDuration;

  @override
  void initState() {
    super.initState();
    openAudioFile();
  }

  @override
  void dispose() {
    /// Stop and dispose player instance to stop playing
    /// when dispose (e.g. page switched).
    /// 状态销毁时停止并销毁实例（例如页面切换时）
    _controller.pause();
    _controller.removeListener(audioPlayerListener);
    _controller.dispose();
    super.dispose();
  }

  /// Load content url from the asset.
  /// 通过content地址加载资源
  Future<void> openAudioFile() async {
    try {
      final String? url = await widget.asset.getMediaUrl();
      assetDuration = Duration(seconds: widget.asset.duration);
      _controller = VideoPlayerController.network(url!);
      await _controller.initialize();
      _controller.addListener(audioPlayerListener);
    } catch (e) {
      realDebugPrint('Error when opening audio file: $e');
    } finally {
      isLoaded = true;
      if (mounted) {
        setState(() {});
      }
    }
  }

  /// Listener for the player.
  /// 播放器的监听方法
  void audioPlayerListener() {
    if (isControllerPlaying != isPlaying) {
      isPlaying = isControllerPlaying;
      if (mounted) {
        setState(() {});
      }
    }

    /// Add the current position into the stream.
    durationStreamController.add(_controller.value.position);
  }

  void playButtonCallback() {
    if (isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
    }
  }

  /// Title widget.
  /// 标题组件
  Widget get titleWidget {
    return ScaleText(
      widget.asset.title ?? '',
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
    );
  }

  /// Button to control audio play/pause.
  /// 控制音频播放或暂停的按钮
  Widget get audioControlButton {
    return GestureDetector(
      onTap: playButtonCallback,
      child: Container(
        margin: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          boxShadow: <BoxShadow>[BoxShadow(color: Colors.black12)],
          shape: BoxShape.circle,
        ),
        child: Icon(
          isPlaying ? Icons.pause_circle_outline : Icons.play_circle_filled,
          size: 70,
        ),
      ),
    );
  }

  /// Duration indicator for the audio.
  /// 音频的时长指示器
  Widget get durationIndicator {
    final String Function(Duration) durationBuilder =
        Singleton.textDelegate.durationIndicatorBuilder;
    final String Function(Duration) semanticsDurationBuilder =
        Singleton.textDelegate.semanticsTextDelegate.durationIndicatorBuilder;
    return StreamBuilder<Duration>(
      initialData: Duration.zero,
      stream: durationStreamController.stream,
      builder: (BuildContext _, AsyncSnapshot<Duration> data) {
        return ScaleText(
          '${durationBuilder(data.data!)} / ${durationBuilder(assetDuration)}',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.normal,
          ),
          semanticsLabel: '${semanticsDurationBuilder(data.data!)}'
              ' / '
              '${semanticsDurationBuilder(assetDuration)}',
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      onLongPress: playButtonCallback,
      onLongPressHint:
          Singleton.textDelegate.semanticsTextDelegate.sActionPlayHint,
      child: ColoredBox(
        color: context.themeData.backgroundColor,
        child: isLoaded
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  titleWidget,
                  audioControlButton,
                  durationIndicator,
                ],
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}
