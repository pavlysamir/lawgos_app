import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lowgos_app/core/theme/app_colors.dart';
import 'package:lowgos_app/core/theme/app_text_styles.dart';
import 'package:lowgos_app/core/utilities/assets_data.dart';
import 'package:lowgos_app/core/widgets/custom_image.dart';
import 'package:lowgos_app/core/widgets/highlight_text.dart';

class OnBoardingFirstItem extends StatelessWidget {
  const OnBoardingFirstItem({super.key});

  @override
  Widget build(BuildContext context) {
    double scaleFactor = MediaQuery.of(context).textScaleFactor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 80.h),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 11.0),
          child: Align(
            alignment: Alignment.topRight,

            child: MultiStyledText(
              textAlign: TextAlign.center,
              defaultStyle: AppTextStyles.h2Bold.copyWith(
                color: AppColors.white,
              ),
              text: 'طوّر مستواك في القانون',
              highlightedWords: {
                'القانون': AppTextStyles.h2Bold.copyWith(color: AppColors.gold),
              },
            ),
          ),
        ),
        SizedBox(height: 20.h),
        Align(
          alignment: Alignment.centerRight,
          child: CustomImage(path: AssetsData.onBoarding_1, hight: 370.h),
        ),
        scaleFactor > 1.2
            ? const Text('')
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 10.h),
                child: Text(
                  'ابدأ تتعلم القوانين بطريقة سهلة من خلال أسئلة بسيطة تساعدك تفهم وتثبت المعلومة.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body1Regular.copyWith(
                    color: AppColors.primaryColor100,
                  ),
                ),
              ),
      ],
    );
  }
}
