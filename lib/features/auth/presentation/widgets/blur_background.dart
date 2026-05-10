import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BlurredBackground extends StatelessWidget {
  final Widget child;
  final double sigmaX;
  final double sigmaY;
  final double hight;

  final Color? overlayColor;

  const BlurredBackground({
    super.key,
    required this.child,
    this.sigmaX = 10.0,
    this.sigmaY = 10.0,
    this.hight = 450,
    this.overlayColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: sigmaX, sigmaY: sigmaY),
          child: RepaintBoundary(
            child: Container(
              padding: const EdgeInsets.all(24.0),
              // height: hight.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: overlayColor ?? Colors.white.withOpacity(0.5),
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
