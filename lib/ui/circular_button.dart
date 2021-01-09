import 'package:flutter/material.dart';

class CircularButton extends StatelessWidget {
  const CircularButton(
      {this.color, this.width, this.height, this.icon, this.onClick});

  final double width;
  final double height;
  final Color color;
  final Icon icon;
  final Function() onClick;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
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
