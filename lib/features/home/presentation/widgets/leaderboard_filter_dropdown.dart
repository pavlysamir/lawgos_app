import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lowgos_app/core/theme/app_colors.dart';
import 'package:lowgos_app/core/theme/app_text_styles.dart';
import 'package:lowgos_app/features/home/domain/entities/law.dart';

class LeaderboardFilterDropdown extends StatelessWidget {
  const LeaderboardFilterDropdown({
    super.key,
    required this.laws,
    required this.selectedLawId,
    required this.onChanged,
  });

  final List<Law> laws;
  final String? selectedLawId;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45.h,
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: AppColors.grey100),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String?>(
          value: selectedLawId,
          isExpanded: true,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.navyBlue300,
            size: 22.sp,
          ),
          style: AppTextStyles.body2Regular.copyWith(
            color: AppColors.navyBlue900,
          ),
          items: [
            const DropdownMenuItem<String?>(
              value: null,
              child: Text('كل القوانين'),
            ),
            ...laws.map(
              (law) => DropdownMenuItem<String?>(
                value: law.id,
                child: Text(
                  law.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }
}
