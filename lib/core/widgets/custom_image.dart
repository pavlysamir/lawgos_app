import 'package:flutter/material.dart';

class CustomImage extends StatelessWidget {
  const CustomImage({super.key, this.path, this.hight, this.color, this.width});
  final String? path;
  final double? hight;
  final double? width;

  final Color? color;

  @override
  Widget build(BuildContext context) {
    if (path == null) return const SizedBox.shrink();
    return Image.asset(path!, height: hight, width: width, fit: BoxFit.contain);
  }
}
