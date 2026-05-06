import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lowgos_app/core/theme/app_colors.dart';
import 'package:lowgos_app/core/theme/app_text_styles.dart';
import 'package:lowgos_app/core/utilities/assets_data.dart';
import 'package:lowgos_app/core/widgets/custom_image.dart';
import 'package:lowgos_app/core/widgets/custom_svgImage.dart';
import 'package:lowgos_app/core/widgets/highlight_text.dart';

class OnBoardingSecondItem extends StatelessWidget {
  const OnBoardingSecondItem({super.key});

  @override
  Widget build(BuildContext context) {
    double scaleFactor = MediaQuery.of(context).textScaleFactor;
    return Column(
      children: [
        SizedBox(height: 80.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: MultiStyledText(
            textAlign: TextAlign.center,
            defaultStyle: AppTextStyles.h1Bold.copyWith(color: AppColors.white),
            text: 'اتعلم وانت بتلعب',
            highlightedWords: {
              'بتلعب': AppTextStyles.h1Bold.copyWith(
                color: AppColors.primary500,
              ),
            },
          ),
        ),
        CustomSvgimage(path: AssetsData.waveLine, hight: 20.h, width: 300.w),
        SizedBox(height: 20.h),
        scaleFactor > 1.2
            ? const Text('')
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.w),
                child: Text(
                  'حل أسئلة، عدّي مستويات، واختبر نفسك في كل مرحلة لحد ما توصل لأعلى مستوى.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body1SemiBold.copyWith(
                    color: AppColors.gold50,
                  ),
                ),
              ),
        Center(
          child: CustomImage(path: AssetsData.onBoarding_2, hight: 350.h),
        ),
      ],
    );
  }
}
