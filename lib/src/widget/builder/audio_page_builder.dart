///
/// [Author] Alex (https://github.com/AlexVincent525)
/// [Date] 2020/5/21 14:18
///
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

import 'package:wechat_assets_picker/src/constants/constants.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class AudioPageBuilder extends StatefulWidget {
  const AudioPageBuilder({
    Key key,
    this.asset,
    this.state,
  }) : super(key: key);

  /// Asset currently displayed.
  /// 展示的资源
  final AssetEntity asset;

  /// [State] for asset picker viewer.
  /// 资源查看器的状态[State]
  final AssetPickerViewerState state;

  @override
  State<StatefulWidget> createState() => _AudioPageBuilderState();
}

class _AudioPageBuilderState extends State<AudioPageBuilder> {
  /// Create an [AssetsAudioPlayer] instance for the page builder state.
  /// 创建一个[AssetsAudioPlayer]的实例
  final AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();

  /// Whether the audio is loaded.
  /// 音频是否已经加载完成
  bool isLoaded = false;

  /// Whether there's some error when loading the audio.
  /// 加载音频时是否有错误
  bool isError = false;

  /// Duration of the audio.
  /// 音频的时长
  Duration assetDuration;

  /// Audio instance.
  /// 音频实例
  Audio audio;

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
    audioPlayer
      ..stop()
      ..dispose();
    super.dispose();
  }

  /// Using [audioPlayer] to load content url from asset.
  /// 使用[audioPlayer]通过content地址加载资源
  Future<void> openAudioFile() async {
    try {
      assetDuration = Duration(seconds: widget.asset.duration);
      audio = Audio.file(await widget.asset.getMediaUrl());
      audioPlayer.open(audio, autoStart: false);
    } catch (e) {
      realDebugPrint('Error when opening audio file: $e');
      isError = true;
    } finally {
      isLoaded = true;
      if (mounted) {
        setState(() {});
      }
    }
  }

  /// Title widget.
  /// 标题组件
  Widget get titleWidget => Text(
        widget.asset.title,
        style: const TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.normal,
        ),
      );

  /// Button to control audio play/pause.
  /// 控制音频播放或暂停的按钮
  Widget get audioControlButton => StreamBuilder<bool>(
        initialData: false,
        stream: audioPlayer.isPlaying,
        builder: (BuildContext _, AsyncSnapshot<bool> data) {
          final bool isPlaying = data.data;
          return GestureDetector(
            onTap: () {
              if (isPlaying) {
                audioPlayer.pause();
              } else {
                audioPlayer.play();
              }
            },
            child: Container(
              margin: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                boxShadow: <BoxShadow>[BoxShadow(color: Colors.black12)],
                shape: BoxShape.circle,
              ),
              child: Icon(
                isPlaying
                    ? Icons.pause_circle_outline
                    : Icons.play_circle_filled,
                size: 70.0,
              ),
            ),
          );
        },
      );

  /// Duration indicator for the audio.
  /// 音频的时长指示器
  Widget get durationIndicator => StreamBuilder<Duration>(
        initialData: Duration.zero,
        stream: audioPlayer.currentPosition,
        builder: (BuildContext _, AsyncSnapshot<Duration> data) {
          return Text(
            '${Constants.textDelegate.durationIndicatorBuilder(data.data)}'
            ' / '
            '${Constants.textDelegate.durationIndicatorBuilder(assetDuration)}',
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.normal,
            ),
          );
        },
      );

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.themeData.backgroundColor,
      child: isLoaded
          ? AudioWidget(
              audio: audio,
              play: audioPlayer.isPlaying.value,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  titleWidget,
                  audioControlButton,
                  durationIndicator,
                ],
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
