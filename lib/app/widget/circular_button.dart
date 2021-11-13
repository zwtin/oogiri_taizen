import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CircularButton extends HookWidget {
  const CircularButton({
    required this.color,
    required this.width,
    required this.height,
    required this.icon,
    required this.onClick,
  });

  final double width;
  final double height;
  final Color color;
  final Icon icon;
  final Function() onClick;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      width: width,
      height: height,
      child: IconButton(
        icon: icon,
        enableFeedback: true,
        onPressed: onClick,
      ),
    );
  }
}
