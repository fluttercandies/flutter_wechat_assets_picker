///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2021/5/10 16:56
///
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
