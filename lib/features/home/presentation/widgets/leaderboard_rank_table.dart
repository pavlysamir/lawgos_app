import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lowgos_app/core/theme/app_colors.dart';
import 'package:lowgos_app/core/theme/app_text_styles.dart';
import 'package:lowgos_app/features/home/domain/entities/leaderboard_entry.dart';
import 'package:lowgos_app/features/home/presentation/widgets/leaderboard_rank_row.dart';

class LeaderboardRankTable extends StatelessWidget {
  const LeaderboardRankTable({
    super.key,
    required this.entries,
    required this.isLoadingMore,
  });

  final List<LeaderboardEntry> entries;
  final bool isLoadingMore;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: AppColors.grey100),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            Container(
              height: 66.h,
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: AppColors.grey100),
                ),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 58.w,
                    child: Text(
                      'الترتيب',
                      style: AppTextStyles.body3Medium.copyWith(
                        color: AppColors.navyBlue300,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'المستخدم',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.body3Medium.copyWith(
                        color: AppColors.navyBlue300,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 74.w,
                    child: Text(
                      'النقاط',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.body3Medium.copyWith(
                        color: AppColors.navyBlue300,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (entries.isEmpty)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 34.h),
                child: Text(
                  'لا توجد نتائج بعد',
                  style: AppTextStyles.body2Regular.copyWith(
                    color: AppColors.navyBlue300,
                  ),
                ),
              )
            else
              ...entries.map((entry) => LeaderboardRankRow(entry: entry)),
            if (isLoadingMore)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                child: SizedBox(
                  width: 22.w,
                  height: 22.w,
                  child: const CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
