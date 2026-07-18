import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lowgos_app/core/theme/app_colors.dart';
import 'package:lowgos_app/core/theme/app_text_styles.dart';
import 'package:lowgos_app/features/home/domain/entities/leaderboard_entry.dart';

class CurrentUserRankCard extends StatelessWidget {
  const CurrentUserRankCard({super.key, required this.entry});

  final LeaderboardEntry entry;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 74.h,
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.warning50),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey200.withValues(alpha: 0.38),
            blurRadius: 24,
            offset: Offset(0, 12.h),
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _formatPoints(entry.points),
                style: AppTextStyles.h4Bold.copyWith(color: AppColors.gold),
              ),
              Text(
                'نقطة',
                style: AppTextStyles.body5Regular.copyWith(
                  color: AppColors.navyBlue300,
                ),
              ),
            ],
          ),
          const Spacer(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'أنت',
                style: AppTextStyles.body5Regular.copyWith(
                  color: AppColors.gold,
                ),
              ),
              Text(
                entry.displayName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.body2SemiBold.copyWith(
                  color: AppColors.navyBlue900,
                ),
              ),
            ],
          ),
          SizedBox(width: 14.w),
          Container(
            width: 38.w,
            height: 38.w,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.gold50,
            ),
            child: Text(
              '${entry.rank}',
              style: AppTextStyles.body3SemiBold.copyWith(
                color: AppColors.gold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatPoints(int points) {
    return points.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (_) => ',',
    );
  }
}
