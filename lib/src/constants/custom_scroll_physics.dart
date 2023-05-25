// Copyright 2019 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by an Apache license that can be found
// in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/physics.dart' as physics show SpringDescription;

class CustomBouncingScrollPhysics extends BouncingScrollPhysics {
  const CustomBouncingScrollPhysics({
    super.parent,
  });

  @override
  CustomBouncingScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomBouncingScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  physics.SpringDescription get spring {
    return physics.SpringDescription.withDampingRatio(
      mass: 0.5,
      stiffness: 400.0,
      ratio: 1.1,
    );
  }
}

class CustomClampingScrollPhysics extends ClampingScrollPhysics {
  const CustomClampingScrollPhysics({
    super.parent,
  });

  @override
  CustomClampingScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomClampingScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  physics.SpringDescription get spring {
    return physics.SpringDescription.withDampingRatio(
      mass: 0.5,
      stiffness: 400.0,
      ratio: 1.1,
    );
  }
}
