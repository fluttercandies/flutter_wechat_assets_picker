///
/// [Author] Alex (https://github.com/Alex525)
/// [Date] 2020/3/20 14:07
///
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:wechat_assets_picker/src/constants/constants.dart';

@immutable
class AssetEntityImageProvider extends ImageProvider<AssetEntityImageProvider> {
  AssetEntityImageProvider(
    this.entity, {
    this.scale = 1.0,
    this.thumbSize = Constants.defaultPreviewThumbSize,
    this.isOriginal = true,
  }) : assert(
          isOriginal || thumbSize?.length == 2,
          'thumbSize must contain and only contain two integers when it\'s not original',
        ) {
    if (!isOriginal && thumbSize?.length != 2) {
      throw ArgumentError(
        'thumbSize must contain and only contain two integers when it\'s not original',
      );
    }
  }

  final AssetEntity entity;

  /// Scale for image provider.
  /// 缩放
  final double scale;

  /// Size for thumb data.
  /// 缩略图的大小
  final List<int> thumbSize;

  /// Choose if original data or thumb data should be loaded.
  /// 选择载入原数据还是缩略图数据
  final bool isOriginal;

  /// File type for the image asset, use it for some special type detection.
  /// 图片资源的类型，用于某些特殊类型的判断
  ImageFileType get imageFileType => _getType();

  @override
  ImageStreamCompleter load(
    AssetEntityImageProvider key,
    DecoderCallback decode,
  ) {
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

  Future<ui.Codec> _loadAsync(
    AssetEntityImageProvider key,
    DecoderCallback decode,
  ) async {
    assert(key == this);
    Uint8List data;
    if (isOriginal ?? false) {
      if (imageFileType == ImageFileType.heic) {
        data = await (await key.entity.file).readAsBytes();
      } else {
        data = await key.entity.originBytes;
      }
    } else {
      data = await key.entity.thumbDataWithSize(thumbSize[0], thumbSize[1]);
    }
    return decode(data);
  }

  /// Get image type by reading the file extension.
  /// 从图片后缀判断图片类型
  ///
  /// ⚠ Not all the system version support read file name from the entity,
  /// so this method might not work sometime.
  /// 并非所有的系统版本都支持读取文件名，所以该方法有时无法返回正确的type。
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
        case 'heic':
          type = ImageFileType.heic;
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
    if (other.runtimeType != runtimeType) {
      return false;
    }
    final AssetEntityImageProvider typedOther =
        // ignore: test_types_in_equals
        other as AssetEntityImageProvider;
    return entity == typedOther.entity &&
        scale == typedOther.scale &&
        thumbSize == typedOther.thumbSize &&
        isOriginal == typedOther.isOriginal;
  }

  @override
  int get hashCode => hashValues(entity, scale, isOriginal);
}

enum ImageFileType { jpg, png, gif, tiff, heic, other }

enum SpecialImageType { gif, heic }
