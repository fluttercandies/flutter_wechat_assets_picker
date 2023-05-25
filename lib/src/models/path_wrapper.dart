// Copyright 2019 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by an Apache license that can be found
// in the LICENSE file.

import 'dart:typed_data' as typed_data;

import 'package:flutter/foundation.dart';

/// A wrapper that holds [Path] with it's nullable (late initialize) fields.
///
/// The asset count usually backed by [AssetPathEntity.assetCountAsync],
/// and the thumbnail usually backed by [AssetEntity.thumbnailData].
/// These methods are asynchronous and called separately for better performance.
/// After calls, use [copyWith] to update paths to avoid unnecessary waits.
@immutable
class PathWrapper<Path> {
  const PathWrapper({
    required this.path,
    this.assetCount,
    this.thumbnailData,
  });

  /// Typically an [AssetPathEntity].
  final Path path;

  /// The total asset count of the [path].
  ///
  /// Nullability represents whether it's initialized.
  ///
  /// See also:
  ///  * [AssetPathEntity.assetCountAsync] API document:
  ///    https://pub.dev/documentation/photo_manager/latest/photo_manager/AssetPathEntity/assetCountAsync.html
  final int? assetCount;

  /// The thumbnail (first asset) data of the [path].
  ///
  /// Nullability represents whether it's initialized.
  ///
  /// See also:
  ///  * [AssetEntity.thumbnailData] API document:
  ///    https://pub.dev/documentation/photo_manager/latest/photo_manager/AssetEntity/thumbnailData.html
  final typed_data.Uint8List? thumbnailData;

  /// Creates a modified copy of the object.
  ///
  /// Explicitly specified fields get the specified value, all other fields get
  /// the same value of the current object.
  PathWrapper<Path> copyWith({
    int? assetCount,
    typed_data.Uint8List? thumbnailData,
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

  @override
  String toString() {
    return '$runtimeType('
        'path: $path, '
        'assetCount: $assetCount, '
        'thumbnailData: ${thumbnailData?.runtimeType}'
        ')';
  }
}
