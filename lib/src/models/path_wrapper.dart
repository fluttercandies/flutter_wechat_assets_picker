//
// [Author] Alex (https://github.com/AlexV525)
// [Date] 2022/6/30 22:55
//

import 'dart:typed_data';

import 'package:flutter/foundation.dart';

/// A wrapper that holds [Path] with it's nullable (late initialize) fields.
///
/// The asset count usually backed by [AssetPathEntity.assetCountAsync],
/// and the thumbnail usually backed by [AssetEntity.thumbnailData].
/// These methods are asynchronous and called separately for better performance.
/// After calls, use [copyWith] to update paths to avoid unnecessary waits.
///
/// [Path] is typically an [AssetPathEntity].
@immutable
class PathWrapper<Path> {
  const PathWrapper({
    required this.path,
    this.assetCount,
    this.thumbnailData,
  });

  final Path path;
  final int? assetCount;
  final Uint8List? thumbnailData;

  PathWrapper<Path> copyWith({
    int? assetCount,
    Uint8List? thumbnailData,
  }) {
    return PathWrapper<Path>(
      path: path,
      assetCount: assetCount ?? this.assetCount,
      thumbnailData: thumbnailData ?? this.thumbnailData,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is PathWrapper<Path> &&
        other.path == path &&
        other.assetCount == assetCount &&
        other.thumbnailData == thumbnailData;
  }

  @override
  int get hashCode =>
      path.hashCode ^ assetCount.hashCode ^ thumbnailData.hashCode;
}
