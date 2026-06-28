import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lowgos_app/core/theme/app_colors.dart';
import 'package:lowgos_app/core/theme/app_text_styles.dart';
import 'package:lowgos_app/core/utilities/assets_data.dart';
import 'package:lowgos_app/core/widgets/custom_image.dart';
import 'package:lowgos_app/features/home/domain/entities/law_material.dart';
import 'package:lowgos_app/features/home/presentation/widgets/exam_flow_scaffold.dart';

class MaterialTextView extends StatelessWidget {
  const MaterialTextView({
    super.key,
    required this.levelColor,
    required this.material,
    required this.isStarting,
    required this.onStart,
  });

  final Color levelColor;
  final LawMaterial material;
  final bool isStarting;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return ExamFlowScaffold(
      backgroundColor: levelColor,
      child: Column(
        children: [
          Row(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomImage(path: AssetsData.bookIcon, width: 44.w),
                  SizedBox(width: 8.w),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'نص المادة',
                        style: AppTextStyles.h4Medium.copyWith(
                          color: AppColors.white,
                        ),
                      ),

                      Text(
                        'المادة ${material.order}',
                        style: AppTextStyles.body3Regular.copyWith(
                          color: AppColors.white.withValues(alpha: .78),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),

              const ExamBackButton(),
            ],
          ),
          if (material.title != null && material.title!.trim().isNotEmpty) ...[
            Text(
              material.title!,
              textAlign: TextAlign.center,
              style: AppTextStyles.h3Bold.copyWith(color: AppColors.gold400),
            ),
          ],
          SizedBox(height: 58.h),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              decoration: BoxDecoration(
                color: AppColors.gold400,
                borderRadius: BorderRadius.circular(22.r),
              ),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // if (material.title != null &&
                      //     material.title!.trim().isNotEmpty) ...[
                      //   Text(
                      //     material.title!,
                      //     textAlign: TextAlign.center,
                      //     style: AppTextStyles.h3Bold.copyWith(
                      //       color: AppColors.primaryColor,
                      //     ),
                      //   ),
                      //   SizedBox(height: 16.h),
                      // ],
                      Text(
                        material.content,
                        textAlign: TextAlign.justify,
                        style: AppTextStyles.h4Medium.copyWith(
                          color: AppColors.primaryColor,
                          height: 1.7,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 46.h),
          ExamPrimaryButton(
            label: 'ابدأ الأسئلة',
            onPressed: onStart,
            isLoading: isStarting,
            backgroundColor: AppColors.gold50,
          ),
        ],
      ),
    );
  }
}
