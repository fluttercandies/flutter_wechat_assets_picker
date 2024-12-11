// Copyright 2019 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by an Apache license that can be found
// in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

void main() {
  test('Sort paths correctly', () {
    final List<PathWrapper<AssetPathEntity>> paths =
        <PathWrapper<AssetPathEntity>>[
      PathWrapper<AssetPathEntity>(
        path: AssetPathEntity(id: 'id2', name: 'Screenshots'),
      ),
      PathWrapper<AssetPathEntity>(
        path: AssetPathEntity(id: 'id1', name: 'Camera'),
      ),
      PathWrapper<AssetPathEntity>(
        path: AssetPathEntity(id: 'id0', name: 'All', isAll: true),
      ),
    ];
    SortPathDelegate.common.sort(paths);
    expect(paths[0], (PathWrapper<AssetPathEntity> e) => e.path.isAll);
    expect(
      paths[1],
      (PathWrapper<AssetPathEntity> e) => e.path.name == 'Camera',
    );
    expect(
      paths[2],
      (PathWrapper<AssetPathEntity> e) => e.path.name == 'Screenshots',
    );
  });
}
