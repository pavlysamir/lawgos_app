import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lowgos_app/core/theme/app_colors.dart';
import 'package:lowgos_app/core/theme/app_text_styles.dart';
import 'package:lowgos_app/features/home/domain/entities/leaderboard_entry.dart';

class LeaderboardRankRow extends StatelessWidget {
  const LeaderboardRankRow({super.key, required this.entry});

  final LeaderboardEntry entry;

  @override
  Widget build(BuildContext context) {
    final isCurrentUser = entry.isCurrentUser;
    return Container(
      height: 68.h,
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      decoration: BoxDecoration(
        color: isCurrentUser ? AppColors.warning0 : AppColors.white,
        border: const Border(
          bottom: BorderSide(color: AppColors.grey100),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 58.w,
            child: Text(
              '${entry.rank}',
              style: AppTextStyles.body3Medium.copyWith(
                color: AppColors.navyBlue900,
              ),
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    entry.displayName,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.body3SemiBold.copyWith(
                      color: AppColors.navyBlue900,
                    ),
                  ),
                ),
                if (isCurrentUser) ...[
                  SizedBox(width: 8.w),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 3.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.gold,
                      borderRadius: BorderRadius.circular(5.r),
                    ),
                    child: Text(
                      'أنت',
                      style: AppTextStyles.body5Regular.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          SizedBox(
            width: 74.w,
            child: Text(
              _formatPoints(entry.points),
              textAlign: TextAlign.center,
              style: AppTextStyles.body3Medium.copyWith(
                color: isCurrentUser ? AppColors.gold : AppColors.navyBlue900,
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
