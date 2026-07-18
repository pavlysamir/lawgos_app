import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lowgos_app/core/theme/app_colors.dart';
import 'package:lowgos_app/core/theme/app_text_styles.dart';
import 'package:lowgos_app/core/theme/font_weight_helper.dart';

class AuthGoogleButton extends StatelessWidget {
  const AuthGoogleButton({
    super.key,
    required this.onPressed,
    required this.isLoading,
  });

  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 47.h,
      width: 145.w,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.white,
          side: const BorderSide(color: AppColors.grey100),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.r),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'G',
              style: AppTextStyles.h5Bold.copyWith(
                color: const Color(0xFF4285F4),
                fontWeight: FontWeightHelper.bold,
              ),
            ),
            SizedBox(width: 10.w),
            Text(
              'Google',
              style: AppTextStyles.body3Medium.copyWith(
                color: AppColors.blackB90,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
