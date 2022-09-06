import 'package:flutter/material.dart';
import 'package:muntorial/muntorial.dart';

class ConfirmButton extends StatelessWidget {
  const ConfirmButton({
    Key? key,
    required this.onPressed,
    required this.text,
    required this.isActive,
  }) : super(key: key);

  final VoidCallback? onPressed;
  final String text;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        //height: 32,
        decoration: ShapeDecoration(
          color: isActive ? MuntorialColors.red : MuntorialColors.grey700,
          shape: const StadiumBorder(),
        ),
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 12),
        child: Text(
          text,
          style: MuntorialTextStyles.size14SemiBold.singleLine.copyWith(
            color: isActive ? MuntorialColors.white : MuntorialColors.grey500,
          ),
        ),
      ),
    );
  }
}
