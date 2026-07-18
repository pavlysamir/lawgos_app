import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lowgos_app/core/theme/app_colors.dart';
import 'package:lowgos_app/core/theme/app_text_styles.dart';
import 'package:lowgos_app/core/utilities/assets_data.dart';
import 'package:lowgos_app/core/widgets/custom_image.dart';
import 'package:lowgos_app/core/widgets/highlight_text.dart';

class OnBoardingThirdItem extends StatelessWidget {
  const OnBoardingThirdItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 120.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w),
          child: MultiStyledText(
            defaultStyle: AppTextStyles.h3Bold.copyWith(color: AppColors.white),
            text: 'يصنع الملكة القانونية\nويزيد سرعة الفهم\nودقة التحليل.',
            highlightedWords: {
              'ودقة التحليل.': AppTextStyles.h3Bold.copyWith(
                color: AppColors.offWhite,
              ),
            },
          ),
        ),
        SizedBox(height: 30.h),

        Center(
          child: CustomImage(path: AssetsData.onBoarding_3, hight: 350.h),
        ),

        // scaleFactor > 1.2
        //     ? const Text('')
        //     : Padding(
        //         padding: EdgeInsets.symmetric(horizontal: 40.w),
        //         child: Text(
        //           'كل سؤال بيقوّي تفكيرك القانوني ويقربك خطوة من شغلك \nكمحامي محترف',
        //           textAlign: TextAlign.right,
        //           style: AppTextStyles.body1Regular.copyWith(
        //             color: AppColors.white,
        //           ),
        //         ),
        //       ),
      ],
    );
  }
}
