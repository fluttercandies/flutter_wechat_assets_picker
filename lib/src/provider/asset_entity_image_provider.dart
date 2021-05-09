///
/// [Author] Alex (https://github.com/Alex525)
/// [Date] 2020/3/20 14:07
///
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../constants/constants.dart';

class AssetEntityImageProvider extends ImageProvider<AssetEntityImageProvider> {
  const AssetEntityImageProvider(
    this.entity, {
    this.scale = 1.0,
    this.thumbSize = const <int>[
      Constants.defaultGridThumbSize,
      Constants.defaultGridThumbSize,
    ],
    this.isOriginal = true,
  }) : assert(
          isOriginal || thumbSize?.length == 2,
          'thumbSize must contain and only contain two integers when it\'s not original',
        );

  final AssetEntity entity;

  /// Scale for image provider.
  /// 缩放
  final double scale;

  /// Size for thumb data.
  /// 缩略图的大小
  final List<int>? thumbSize;

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
    Uint8List? data;
    if (isOriginal) {
      if (key.entity.type == AssetType.audio ||
          key.entity.type == AssetType.other) {
        throw UnsupportedError(
          'Image data for the ${key.entity.type} is not supported.',
        );
      }
      if (key.entity.type == AssetType.video) {
        data = await key.entity.thumbDataWithSize(
          Constants.defaultGridThumbSize,
          Constants.defaultGridThumbSize,
        );
      } else if (imageFileType == ImageFileType.heic) {
        data = await (await key.entity.file)?.readAsBytes();
      } else {
        data = await key.entity.originBytes;
      }
    } else {
      final List<int> _thumbSize = thumbSize!;
      data = await key.entity.thumbDataWithSize(_thumbSize[0], _thumbSize[1]);
    }
    if (data == null) {
      throw AssertionError('Null in entity\'s data.');
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
    ImageFileType? type;
    final String? extension =
        entity.mimeType?.split('/').last ?? entity.title?.split('.').last;
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
    return type ?? ImageFileType.other;
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(dynamic other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    if (identical(this, other)) {
      return true;
    }
    return entity == other.entity &&
        scale == other.scale &&
        thumbSize == other.thumbSize &&
        isOriginal == other.isOriginal;
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode {
    return hashValues(
      entity,
      scale,
      thumbSize?.elementAt(0) ?? 0,
      thumbSize?.elementAt(1) ?? 0,
      isOriginal,
    );
  }
}

enum ImageFileType { jpg, png, gif, tiff, heic, other }

enum SpecialImageType { gif, heic }
