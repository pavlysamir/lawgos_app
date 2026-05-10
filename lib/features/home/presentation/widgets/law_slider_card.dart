import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lowgos_app/core/theme/app_colors.dart';
import 'package:lowgos_app/core/theme/app_text_styles.dart';
import 'package:lowgos_app/core/utilities/assets_data.dart';
import 'package:lowgos_app/core/widgets/custom_image.dart';
import 'package:lowgos_app/features/home/domain/entities/law.dart';

class LawSliderCard extends StatelessWidget {
  const LawSliderCard({
    super.key,
    required this.law,
    required this.onStart,
    required this.isLoading,
    this.color,
  });

  final Law law;
  final VoidCallback onStart;
  final bool isLoading;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onStart,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 18.h),
        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
        decoration: BoxDecoration(
          color: color ?? AppColors.blue,
          borderRadius: BorderRadius.circular(28.r),
        ),
        child: Stack(
          children: [
            Positioned(left: 0, top: 0, child: _FavoriteButton(onTap: () {})),
            Positioned(
              right: 0,
              top: 0,
              child: _StartButton(isLoading: isLoading, onTap: onStart),
            ),
            Positioned.fill(
              top: 58.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    law.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                    style: AppTextStyles.h4Bold.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            ),

            Positioned(
              bottom: 0,
              child: CustomImage(path: AssetsData.lawImg, hight: 180.h),
            ),
          ],
        ),
      ),
    );
  }
}

class _StartButton extends StatelessWidget {
  const _StartButton({required this.isLoading, required this.onTap});

  final bool isLoading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.black,
      borderRadius: BorderRadius.circular(28.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(28.r),
        onTap: onTap,
        child: SizedBox(
          width: 108.w,
          height: 38.h,
          child: Center(
            child: isLoading
                ? SizedBox(
                    width: 16.w,
                    height: 16.w,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.white,
                    ),
                  )
                : Text(
                    'ابدأ المستوى',
                    style: AppTextStyles.body4SemiBold.copyWith(
                      color: AppColors.white,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class _FavoriteButton extends StatelessWidget {
  const _FavoriteButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 34.w,
          height: 34.w,
          child: Icon(Icons.favorite, color: AppColors.blue, size: 19.sp),
        ),
      ),
    );
  }
}
