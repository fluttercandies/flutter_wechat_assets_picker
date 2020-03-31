///
/// [Author] Alex (https://github.com/AlexVincent525)
/// [Date] 2020/3/20 14:07
///
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:extended_image/extended_image.dart';
import 'package:photo_manager/photo_manager.dart';

class AssetEntityImageProvider extends ImageProvider<AssetEntityImageProvider>
    with ExtendedImageProvider {
  AssetEntityImageProvider(
    this.entity, {
    this.scale = 1.0,
    this.isOriginal = true,
  });

  final AssetEntity entity;
  final double scale;
  final bool isOriginal;

  ImageFileType _imageFileType;

  ImageFileType get imageFileType => _imageFileType ?? _getType();

  @override
  Future<ui.Codec> instantiateImageCodec(Uint8List data, DecoderCallback decode) async {
    rawImageData = data;
    return await decode(data);
  }

  @override
  ImageStreamCompleter load(AssetEntityImageProvider key, DecoderCallback decode) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key, decode),
      scale: key.scale,
      informationCollector: () {
        return <DiagnosticsNode>[
          DiagnosticsProperty<ImageProvider>('Image provider', this),
          DiagnosticsProperty<AssetEntityImageProvider>('Image key', key),
        ];
      },
    );
  }

  @override
  Future<AssetEntityImageProvider> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<AssetEntityImageProvider>(this);
  }

  Future<ui.Codec> _loadAsync(AssetEntityImageProvider key, DecoderCallback decode) async {
    assert(key == this);
    Uint8List data;
    if (isOriginal ?? false) {
      data = await key.entity.originBytes;
    } else {
      data = await key.entity.thumbData;
    }
    return instantiateImageCodec(data, decode);
  }

  ImageFileType _getType() {
    ImageFileType type;
    final String extension = entity.title?.split('.')?.last;
    if (extension != null) {
      switch (extension.toLowerCase()) {
        case 'jpg':
        case 'jpeg':
          type = ImageFileType.jpg;
          break;
        case 'png':
          type = ImageFileType.png;
          break;
        case 'gif':
          type = ImageFileType.gif;
          break;
        case 'tiff':
          type = ImageFileType.tiff;
          break;
        default:
          type = ImageFileType.other;
          break;
      }
    }
    return type;
  }

  @override
  bool operator ==(dynamic other) {
    if (other is! AssetEntityImageProvider) {
      return false;
    } else {
      final AssetEntityImageProvider typedOther = other as AssetEntityImageProvider;
      final bool result = entity == typedOther.entity &&
          scale == typedOther.scale &&
          isOriginal == typedOther.isOriginal;
      if (result) {
        rawImageData ??= typedOther.rawImageData;
      }
      return result;
    }
  }

  @override
  int get hashCode => hashValues(entity, scale, isOriginal);
}

enum ImageFileType { jpg, png, gif, tiff, other }

enum SpecialAssetType { video, audio, gif }
