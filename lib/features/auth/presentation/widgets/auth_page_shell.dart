import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lowgos_app/core/theme/app_colors.dart';
import 'package:lowgos_app/core/utilities/assets_data.dart';
import 'package:lowgos_app/core/widgets/custom_image.dart';
import 'package:lowgos_app/features/auth/presentation/widgets/blur_background.dart';

class AuthPageShell extends StatelessWidget {
  const AuthPageShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primaryColor40,
              AppColors.whiteLight,
              AppColors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 23.w, vertical: 30.h),
            child: Column(
              children: [
                CustomImage(
                  path: AssetsData.logoName,
                  width: 90.w,
                  hight: 110.h,
                ),
                SizedBox(height: 27.h),
                BlurredBackground(sigmaX: 0.5, sigmaY: 0.5, child: child),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
