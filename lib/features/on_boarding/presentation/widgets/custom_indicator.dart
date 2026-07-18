import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomIndicator extends StatelessWidget {
  final int activeIndex;
  final Color activeColor;
  final Color inactiveColor;

  const CustomIndicator({
    super.key,
    required this.activeIndex,
    required this.activeColor,
    required this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
      child: Row(
        children: List.generate(3, (index) {
          return Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              height: 3.h,
              decoration: BoxDecoration(
                color: index == activeIndex ? activeColor : inactiveColor,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          );
        }),
      ),
    );
  }
}
