import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lowgos_app/core/theme/app_colors.dart';
import 'package:lowgos_app/core/theme/app_text_styles.dart';
import 'package:lowgos_app/features/home/presentation/cubit/home_cubit.dart';

class HomeBottomNavBar extends StatelessWidget {
  const HomeBottomNavBar({super.key, required this.selectedIndex});

  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 22.w,
      right: 22.w,
      bottom: 24.h,
      child: Container(
        height: 58.h,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(29.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.grey200,
              blurRadius: 18,
              offset: Offset(0, 8.h),
            ),
          ],
        ),
        child: Row(
          textDirection: TextDirection.rtl,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _NavItem(
              index: 2,
              selectedIndex: selectedIndex,
              icon: Icons.person_outline,
              selectedIcon: Icons.person,
              label: 'الملف الشخصي',
            ),
            _NavItem(
              index: 1,
              selectedIndex: selectedIndex,
              icon: Icons.account_balance_outlined,
              selectedIcon: Icons.account_balance,
              label: 'التصنيف',
            ),
            _NavItem(
              index: 0,
              selectedIndex: selectedIndex,
              icon: Icons.home_outlined,
              selectedIcon: Icons.home,
              label: 'الرئيسية',
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.index,
    required this.selectedIndex,
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });

  final int index;
  final int selectedIndex;
  final IconData icon;
  final IconData selectedIcon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final isSelected = index == selectedIndex;

    return InkWell(
      borderRadius: BorderRadius.circular(22.r),
      onTap: () => context.read<HomeCubit>().changeTab(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 42.h,
        padding: EdgeInsets.symmetric(horizontal: isSelected ? 12.w : 8.w),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.blue : AppColors.transparent,
          borderRadius: BorderRadius.circular(22.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? selectedIcon : icon,
              size: 20.sp,
              color: isSelected ? AppColors.white : AppColors.grey300,
            ),
            if (isSelected) ...[
              SizedBox(width: 6.w),
              Text(
                label,
                style: AppTextStyles.body5Regular.copyWith(
                  color: AppColors.white,
                ),
              ),
            ] else ...[
              SizedBox(width: 4.w),
              Text(
                label,
                style: AppTextStyles.body5Regular.copyWith(
                  color: AppColors.grey300,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
