// Copyright 2019 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by an Apache license that can be found
// in the LICENSE file.

import 'package:flutter/widgets.dart';

@immutable
class CustomPickMethod {
  const CustomPickMethod({
    required this.icon,
    required this.name,
    required this.description,
    required this.method,
  });

  final String icon;
  final String name;
  final String description;
  final void Function(BuildContext context) method;
}
