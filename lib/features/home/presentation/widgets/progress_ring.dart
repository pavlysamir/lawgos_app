import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lowgos_app/core/theme/app_colors.dart';
import 'package:lowgos_app/core/theme/app_text_styles.dart';

class ProgressRing extends StatelessWidget {
  const ProgressRing({super.key, required this.percentage});

  final int percentage;

  @override
  Widget build(BuildContext context) {
    final value = percentage.clamp(0, 100).toDouble() / 100;
    return SizedBox(
      width: 62.w,
      height: 62.w,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 58.w,
            height: 58.w,
            child: CircularProgressIndicator(
              value: value,
              strokeWidth: 5.w,
              backgroundColor: AppColors.gold50,
              valueColor: const AlwaysStoppedAnimation(AppColors.gold),
            ),
          ),
          Text(
            '${percentage.clamp(0, 100)}%',
            style: AppTextStyles.body2Medium.copyWith(color: AppColors.gold),
          ),
        ],
      ),
    );
  }
}
