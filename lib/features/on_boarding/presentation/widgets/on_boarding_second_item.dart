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
    return Column(
      children: [
        SizedBox(height: 120.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: MultiStyledText(
            textAlign: TextAlign.center,
            defaultStyle: AppTextStyles.h3Bold.copyWith(color: AppColors.white),
            text:
                ' لا يساعدك على الحفظ فقط...\nبل يُدرِّب عقلك على التفكير القانوني.',
            highlightedWords: {
              'التفكير القانوني.': AppTextStyles.h3Bold.copyWith(
                color: AppColors.gold,
              ),
            },
          ),
        ),
        SizedBox(height: 10.h),

        CustomSvgimage(path: AssetsData.waveLine, hight: 20.h, width: 300.w),
        SizedBox(height: 10.h),
        // scaleFactor > 1.2
        //     ? const Text('')
        //     : Padding(
        //         padding: EdgeInsets.symmetric(horizontal: 40.w),
        //         child: Text(
        //           'حل أسئلة، عدّي مستويات، واختبر نفسك في كل مرحلة لحد ما توصل لأعلى مستوى.',
        //           textAlign: TextAlign.center,
        //           style: AppTextStyles.body1SemiBold.copyWith(
        //             color: AppColors.gold50,
        //           ),
        //         ),
        //       ),
        Center(
          child: CustomImage(path: AssetsData.onBoarding_2, hight: 300.h),
        ),
      ],
    );
  }
}
