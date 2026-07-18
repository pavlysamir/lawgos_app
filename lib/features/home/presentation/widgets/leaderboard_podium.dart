import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lowgos_app/core/theme/app_colors.dart';
import 'package:lowgos_app/core/theme/app_text_styles.dart';
import 'package:lowgos_app/features/home/domain/entities/leaderboard_entry.dart';

class LeaderboardPodium extends StatelessWidget {
  const LeaderboardPodium({super.key, required this.entries});

  final List<LeaderboardEntry> entries;

  @override
  Widget build(BuildContext context) {
    final first = _entryAtRank(1);
    final second = _entryAtRank(2);
    final third = _entryAtRank(3);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Column(
        children: [
          Text(
            '🏆 لوحة المتصدرين',
            textAlign: TextAlign.center,
            style: AppTextStyles.h4Bold.copyWith(color: AppColors.navyBlue900),
          ),
          Text(
            'نافس وحقق أعلى ترتيب',
            textAlign: TextAlign.center,
            style: AppTextStyles.body3Regular.copyWith(
              color: AppColors.navyBlue300,
            ),
          ),
          SizedBox(height: 20.h),
          SizedBox(
            height: 250.h,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: _PodiumUserCard(
                    entry: third,
                    rank: 3,
                    height: 215.h,
                    color: AppColors.primaryColor,
                  ),
                ),
                SizedBox(width: 5.w),
                Expanded(
                  child: _PodiumUserCard(
                    entry: first,
                    rank: 1,
                    height: 230.h,
                    color: AppColors.blue,
                    isWinner: true,
                  ),
                ),
                SizedBox(width: 5.w),
                Expanded(
                  child: _PodiumUserCard(
                    entry: second,
                    rank: 2,
                    height: 215.h,
                    color: AppColors.gold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  LeaderboardEntry? _entryAtRank(int rank) {
    for (final entry in entries) {
      if (entry.rank == rank) return entry;
    }
    return entries.length >= rank ? entries[rank - 1] : null;
  }
}

class _PodiumUserCard extends StatelessWidget {
  const _PodiumUserCard({
    required this.entry,
    required this.rank,
    required this.height,
    required this.color,
    this.isWinner = false,
  });

  final LeaderboardEntry? entry;
  final int rank;
  final double height;
  final Color color;
  final bool isWinner;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned.fill(
            top: 50.h,
            child: Container(
              padding: EdgeInsets.fromLTRB(8.w, 62.h, 8.w, 10.h),
              decoration: BoxDecoration(
                color: isWinner ? AppColors.warning0 : AppColors.white,
                border: Border.all(
                  color: isWinner ? AppColors.gold400 : AppColors.grey100,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.grey200.withValues(alpha: 0.24),
                    blurRadius: 14,
                    offset: Offset(0, 8.h),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    entry?.displayName ?? 'لا يوجد',
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.body3SemiBold.copyWith(
                      color: AppColors.navyBlue900,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    _formatPoints(entry?.points ?? 0),
                    style: AppTextStyles.h5Bold.copyWith(color: AppColors.gold),
                  ),
                  Text(
                    'نقطة',
                    style: AppTextStyles.body5Regular.copyWith(
                      color: AppColors.navyBlue300,
                    ),
                  ),
                ],
              ),
            ),
          ),
          _RankMedal(rank: rank, color: color, isWinner: isWinner),
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

class _RankMedal extends StatelessWidget {
  const _RankMedal({
    required this.rank,
    required this.color,
    required this.isWinner,
  });

  final int rank;
  final Color color;
  final bool isWinner;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isWinner ? 104.w : 80.w,
      height: isWinner ? 104.w : 80.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.gold50,
        border: Border.all(color: color, width: 4.w),
      ),
      alignment: Alignment.center,
      child: Text(
        '$rank',
        style: TextStyle(
          fontSize: isWinner ? 76.sp : 54.sp,
          height: 1,
          fontWeight: FontWeight.w800,
          color: AppColors.gold,
          shadows: const [
            Shadow(color: AppColors.white, blurRadius: 1, offset: Offset(1, 1)),
          ],
        ),
      ),
    );
  }
}
