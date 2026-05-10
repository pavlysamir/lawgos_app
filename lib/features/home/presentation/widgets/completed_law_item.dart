import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lowgos_app/core/theme/app_colors.dart';
import 'package:lowgos_app/core/theme/app_text_styles.dart';
import 'package:lowgos_app/features/home/domain/entities/law.dart';
import 'package:lowgos_app/features/home/presentation/widgets/progress_ring.dart';

class CompletedLawItem extends StatelessWidget {
  const CompletedLawItem({super.key, required this.law});

  final Law law;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 112.h,
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(26.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey100,
            blurRadius: 26,
            offset: Offset(10.w, 12.h),
          ),
        ],
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          ProgressRing(percentage: law.completionPercentage),
          SizedBox(width: 20.w),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  law.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                  style: AppTextStyles.body1SemiBold.copyWith(
                    color: AppColors.grey900,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  '${law.totalLevels} مستويات  ◇  ${law.totalQuestions} سؤال',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                  style: AppTextStyles.body4Regular.copyWith(
                    color: AppColors.grey300,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 16.w),
          _CompleteButton(onTap: () {}),
        ],
      ),
    );
  }
}

class _CompleteButton extends StatelessWidget {
  const _CompleteButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72.w,
      height: 36.h,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppColors.primaryColor,
          foregroundColor: AppColors.white,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22.r),
          ),
        ),
        child: Text(
          'كمل',
          style: AppTextStyles.body3Medium.copyWith(color: AppColors.white),
        ),
      ),
    );
  }
}
