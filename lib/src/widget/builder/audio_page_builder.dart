// Copyright 2019 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by an Apache license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:video_player/video_player.dart';
import 'package:wechat_picker_library/wechat_picker_library.dart';

import '../../constants/constants.dart';
import '../../internals/singleton.dart';

class AudioPageBuilder extends StatefulWidget {
  const AudioPageBuilder({
    super.key,
    required this.asset,
    this.shouldAutoplayPreview = false,
  });

  /// Asset currently displayed.
  /// 展示的资源
  final AssetEntity asset;

  /// Whether the preview should auto play.
  /// 预览是否自动播放
  final bool shouldAutoplayPreview;

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
  VideoPlayerController get controller => _controller!;
  VideoPlayerController? _controller;

  /// Whether the audio loaded.
  /// 音频是否已经加载完成
  bool isLoaded = false;

  /// Whether the player is playing.
  /// 播放器是否在播放
  bool isPlaying = false;

  /// Whether the controller is playing.
  /// 播放控制器是否在播放
  bool get isControllerPlaying => _controller?.value.isPlaying == true;

  /// Duration of the audio.
  /// 音频的时长
  Duration assetDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    openAudioFile();
  }

  @override
  void didUpdateWidget(AudioPageBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.asset != oldWidget.asset) {
      _controller
        ?..removeListener(audioPlayerListener)
        ..pause()
        ..dispose();
      isLoaded = false;
      isPlaying = false;
      assetDuration = Duration.zero;
      openAudioFile();
    }
  }

  @override
  void dispose() {
    /// Stop and dispose player instance to stop playing
    /// when dispose (e.g. page switched).
    /// 状态销毁时停止并销毁实例（例如页面切换时）
    _controller
      ?..removeListener(audioPlayerListener)
      ..pause()
      ..dispose();
    super.dispose();
  }

  /// Load content url from the asset.
  /// 通过content地址加载资源
  Future<void> openAudioFile() async {
    try {
      final String? url = await widget.asset.getMediaUrl();
      assetDuration = Duration(seconds: widget.asset.duration);
      _controller = VideoPlayerController.networkUrl(Uri.parse(url!));
      await controller.initialize();
      controller.addListener(audioPlayerListener);
      if (widget.shouldAutoplayPreview) {
        controller.play();
      }
    } catch (e, s) {
      FlutterError.presentError(
        FlutterErrorDetails(
          exception: e,
          stack: s,
          library: packageName,
          silent: true,
        ),
      );
    } finally {
      isLoaded = true;
      safeSetState(() {});
    }
  }

  /// Listener for the player.
  /// 播放器的监听方法
  void audioPlayerListener() {
    if (isControllerPlaying != isPlaying) {
      isPlaying = isControllerPlaying;
      safeSetState(() {});
    }

    /// Add the current position into the stream.
    durationStreamController.add(controller.value.position);
  }

  void playButtonCallback() {
    if (isPlaying) {
      controller.pause();
    } else {
      controller.play();
    }
  }

  /// Title widget.
  /// 标题组件
  Widget get titleWidget {
    // Excluding audio title from semantics since the label already includes.
    return ExcludeSemantics(
      child: ScaleText(
        widget.asset.title ?? '',
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
      ),
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
        color: context.theme.colorScheme.surface,
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
