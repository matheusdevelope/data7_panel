import 'package:flutter/material.dart';

class IconStyle {
  Color? iconsColor;
  bool? withBackground;
  Color? backgroundColor;
  double? borderRadius;
  // double? size;

  IconStyle({
    this.iconsColor = Colors.white,
    this.withBackground = true,
    this.backgroundColor = Colors.blue,
    borderRadius = 8,
    // size = 16
  }) : borderRadius = double.parse(
          borderRadius!.toString(),
          // this.size = double.parse(size!.toString()
        );
}
