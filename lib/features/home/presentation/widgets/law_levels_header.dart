import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lowgos_app/core/theme/app_colors.dart';
import 'package:lowgos_app/core/theme/app_text_styles.dart';
import 'package:lowgos_app/features/home/domain/entities/law.dart';

class LawLevelsHeader extends StatelessWidget {
  const LawLevelsHeader({super.key, required this.law});

  final Law law;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(12.w, 22.h, 22.w, 32.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'مستويات',
            textAlign: TextAlign.right,
            style: AppTextStyles.h3Medium.copyWith(
              color: AppColors.navyBlue,
              height: 1.1,
            ),
          ),
          Text(
            law.name,
            textAlign: TextAlign.right,
            style: AppTextStyles.h3Medium.copyWith(
              color: AppColors.navyBlue900,
              height: 1.15,
            ),
          ),
        ],
      ),
    );
  }
}
