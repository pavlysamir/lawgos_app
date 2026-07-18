import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lowgos_app/core/theme/app_colors.dart';
import 'package:lowgos_app/features/home/domain/entities/law_level.dart';
import 'package:lowgos_app/features/home/presentation/widgets/law_level_card.dart';

typedef LawLevelTap = void Function(LawLevel level, Color color);

class LawLevelsList extends StatelessWidget {
  const LawLevelsList({
    super.key,
    required this.levels,
    required this.openingLevelNumber,
    required this.onLevelTap,
  });

  final List<LawLevel> levels;
  final int? openingLevelNumber;
  final LawLevelTap onLevelTap;

  static const _colors = [
    AppColors.primaryColor,
    AppColors.gold400,
    AppColors.onboarding3Background,
    AppColors.blue,
    AppColors.error200,
  ];

  static const double _overlap = 14;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(
        20.w,
        0,
        20.w,
        34.h + ((levels.length - 1) * _overlap).h,
      ),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final level = levels[index];
          final color = _colors[index % _colors.length];

          return Padding(
            padding: EdgeInsets.only(
              bottom: index == levels.length - 1 ? 0 : _overlap.h,
            ),
            child: Align(
              heightFactor: 0.70, // controls overlap
              child: LawLevelCard(
                level: level,
                color: color,
                isLoading: openingLevelNumber == level.levelNumber,
                onTap: () => onLevelTap(level, color),
                isLast: index == levels.length - 1,
              ),
            ),
          );
        }, childCount: levels.length),
      ),
    );
  }
}
