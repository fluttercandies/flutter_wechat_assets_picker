///
/// [Author] Alex (https://github.com/AlexVincent525)
/// [Date] 2020/3/31 17:34
///
import 'package:flutter/cupertino.dart';
import 'package:flutter/physics.dart';

class CustomScrollPhysics extends BouncingScrollPhysics {
  const CustomScrollPhysics({ScrollPhysics parent}) : super(parent: parent);

  @override
  CustomScrollPhysics applyTo(ScrollPhysics ancestor) {
    return CustomScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  SpringDescription get spring => SpringDescription.withDampingRatio(
        mass: 0.5,
        stiffness: 400.0,
        ratio: 1.1,
      );
}
