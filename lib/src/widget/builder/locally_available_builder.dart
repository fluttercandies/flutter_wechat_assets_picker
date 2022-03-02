///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2021/7/23 16:07
///
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../constants/extensions.dart';
import '../../internal/methods.dart';
import '../scale_text.dart';

class LocallyAvailableBuilder extends StatefulWidget {
  const LocallyAvailableBuilder({
    Key? key,
    required this.asset,
    required this.builder,
    this.isOriginal = true,
  }) : super(key: key);

  final AssetEntity asset;
  final Widget Function(BuildContext context, AssetEntity asset) builder;
  final bool isOriginal;

  @override
  _LocallyAvailableBuilderState createState() =>
      _LocallyAvailableBuilderState();
}

class _LocallyAvailableBuilderState extends State<LocallyAvailableBuilder> {
  bool _isLocallyAvailable = false;
  PMProgressHandler? _progressHandler;

  @override
  void initState() {
    super.initState();
    _checkLocallyAvailable();
  }

  Future<void> _checkLocallyAvailable() async {
    _isLocallyAvailable = await widget.asset.isLocallyAvailable(
      isOrigin: widget.isOriginal,
    );
    if (!mounted) {
      return;
    }
    setState(() {});
    if (!_isLocallyAvailable) {
      _progressHandler = PMProgressHandler();
      Future<void>(() async {
        final File? file = await widget.asset.loadFile(
          isOrigin: widget.isOriginal,
          withSubtype: true,
          progressHandler: _progressHandler,
        );
        realDebugPrint('Produced file: $file.');
        if (file != null) {
          _isLocallyAvailable = true;
          if (mounted) {
            setState(() {});
          }
        }
      });
    }
    _progressHandler?.stream.listen((PMProgressState s) {
      realDebugPrint('Handling progress: $s.');
      if (s.state == PMRequestState.success) {
        _isLocallyAvailable = true;
        if (mounted) {
          setState(() {});
        }
      }
    });
  }

  Widget _indicator(BuildContext context) {
    return StreamBuilder<PMProgressState>(
      stream: _progressHandler!.stream,
      initialData: const PMProgressState(0, PMRequestState.prepare),
      builder: (BuildContext c, AsyncSnapshot<PMProgressState> s) {
        if (s.hasData) {
          final double progress = s.data!.progress;
          final PMRequestState state = s.data!.state;
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                state == PMRequestState.failed
                    ? Icons.cloud_off
                    : Icons.cloud_queue,
                color: context.themeData.iconTheme.color?.withOpacity(.4),
                size: 28,
              ),
              if (state != PMRequestState.success &&
                  state != PMRequestState.failed)
                ScaleText(
                  '  iCloud ${(progress * 100).toInt()}%',
                  style: TextStyle(
                    color: context.themeData.textTheme.bodyText2?.color
                        ?.withOpacity(.4),
                  ),
                ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLocallyAvailable) {
      return widget.builder(context, widget.asset);
    }
    if (_progressHandler != null) {
      return Center(child: _indicator(context));
    }
    return const SizedBox.shrink();
  }
}
