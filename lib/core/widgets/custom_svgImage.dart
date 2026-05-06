import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomSvgimage extends StatelessWidget {
  const CustomSvgimage({
    super.key,
    this.path,
    this.hight,
    this.color,
    this.width,
  });
  final String? path;
  final double? hight;
  final double? width;

  final Color? color;

  @override
  Widget build(BuildContext context) {
    if (path == null) return const SizedBox.shrink();
    return SvgPicture.asset(
      path!,
      height: hight,
      width: width,
      colorFilter: color != null
          ? ColorFilter.mode(color!, BlendMode.srcIn)
          : null,
      fit: BoxFit.contain,
    );
  }
}
