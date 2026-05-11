import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lowgos_app/core/helpers/enums.dart';
import 'package:lowgos_app/core/theme/app_colors.dart';
import 'package:lowgos_app/core/theme/app_text_styles.dart';
import 'package:lowgos_app/core/utilities/assets_data.dart';
import 'package:lowgos_app/core/widgets/custom_image.dart';
import 'package:lowgos_app/features/home/domain/entities/law_level.dart';

class LawLevelCard extends StatelessWidget {
  const LawLevelCard({
    super.key,
    required this.level,
    required this.color,
    required this.onTap,
    required this.isLoading,
    required this.isLast,
  });

  final LawLevel level;
  final Color color;
  final VoidCallback onTap;
  final bool isLoading;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        height: isLoading ? 160.h : 120.h,
        padding: EdgeInsets.fromLTRB(22.w, 13.h, 22.w, 13.h),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(18.r),
            topRight: Radius.circular(18.r),
            bottomLeft: Radius.circular(isLast ? 18.r : 0.r),
            bottomRight: Radius.circular(isLast ? 18.r : 0.r),
          ),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: .24),
              blurRadius: 14,
              offset: Offset(0, 7.h),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              textDirection: TextDirection.rtl,
              children: [
                Expanded(
                  child: Text(
                    level.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                    style: AppTextStyles.h3Regular.copyWith(
                      color: AppColors.white,
                      height: 1,
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                _RewardBadge(points: level.rewardPoints),
              ],
            ),
            SizedBox(height: 22.h),
            Row(
              textDirection: TextDirection.rtl,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _LevelMeta(
                  icon: AssetsData.questionIcon,
                  label: '${level.questionsCount} سؤال',
                ),
                _LevelMeta(
                  icon: AssetsData.timeIcon,
                  label: '${level.expectedDurationMinutes} دقائق',
                ),
                _LevelMeta(
                  icon: AssetsData.statusIcon,
                  label: _statusLabel,
                  isLoading: isLoading,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String get _statusLabel {
    switch (level.status) {
      case LevelProgressStatus.completed:
        return 'مكتمل';
      case LevelProgressStatus.inProgress:
        return 'قيد التقدم';
      case LevelProgressStatus.notStarted:
        return 'لم يبدأ';
    }
  }
}

class _RewardBadge extends StatelessWidget {
  const _RewardBadge({required this.points});

  final int points;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: AppColors.gold50,
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star, size: 13.sp, color: AppColors.gold),
          SizedBox(width: 4.w),
          Text(
            '+$points نقطة',
            style: AppTextStyles.body5Regular.copyWith(color: AppColors.gold),
          ),
        ],
      ),
    );
  }
}

class _LevelMeta extends StatelessWidget {
  const _LevelMeta({
    required this.icon,
    required this.label,
    this.isLoading = false,
  });

  final String icon;
  final String label;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isLoading)
          SizedBox(
            width: 13.w,
            height: 13.w,
            child: const CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.gold,
            ),
          )
        else
          CustomImage(path: icon, width: 18.w),
        SizedBox(width: 4.w),
        Text(
          label,
          style: AppTextStyles.body4Regular.copyWith(
            color: AppColors.white.withValues(alpha: .9),
          ),
        ),
      ],
    );
  }
}
