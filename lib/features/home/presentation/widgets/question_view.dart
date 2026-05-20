import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lowgos_app/core/theme/app_colors.dart';
import 'package:lowgos_app/core/theme/app_text_styles.dart';
import 'package:lowgos_app/features/home/domain/entities/law_question.dart';
import 'package:lowgos_app/features/home/presentation/widgets/exam_flow_scaffold.dart';

class QuestionView extends StatelessWidget {
  const QuestionView({
    super.key,
    required this.levelColor,
    required this.lawName,
    required this.question,
    required this.currentQuestionNumber,
    required this.totalQuestions,
    required this.selectedAnswerIndex,
    required this.isAnswerSubmitted,
    required this.isSaving,
    required this.isLastQuestion,
    required this.onSelectAnswer,
    required this.onNext,
  });

  final Color levelColor;
  final String lawName;
  final LawQuestion question;
  final int currentQuestionNumber;
  final int totalQuestions;
  final int? selectedAnswerIndex;
  final bool isAnswerSubmitted;
  final bool isSaving;
  final bool isLastQuestion;
  final ValueChanged<int> onSelectAnswer;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final progress = totalQuestions == 0
        ? 0.0
        : currentQuestionNumber / totalQuestions;

    return ExamFlowScaffold(
      backgroundColor: levelColor,
      child: Column(
        children: [
          _QuestionHeader(
            lawName: lawName,
            currentQuestionNumber: currentQuestionNumber,
            totalQuestions: totalQuestions,
          ),
          SizedBox(height: 16.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: LinearProgressIndicator(
              value: progress.clamp(0, 1).toDouble(),
              minHeight: 12.h,
              color: AppColors.gold400,
              backgroundColor: AppColors.gold50,
            ),
          ),
          SizedBox(height: 36.h),
          Container(
            width: double.infinity,
            constraints: BoxConstraints(minHeight: 206.h),
            padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 26.h),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(24.r),
            ),
            child: Center(
              child: AutoSizeText(
                question.questionText,
                textAlign: TextAlign.center,
                minFontSize: 18,
                maxLines: 5,
                style: AppTextStyles.h4Regular.copyWith(
                  color: AppColors.primaryColor,
                  height: 1.45,
                ),
              ),
            ),
          ),
          SizedBox(height: 34.h),
          ...List.generate(question.answers.length, (index) {
            return Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: QuestionAnswerTile(
                index: index,
                text: question.answers[index].text,
                isSelected: selectedAnswerIndex == index,
                isCorrect: question.answers[index].isCorrect,
                showResult: isAnswerSubmitted,
                onTap: () => onSelectAnswer(index),
              ),
            );
          }),
          const Spacer(),
          ExamPrimaryButton(
            label: isLastQuestion ? 'إنهاء المستوى' : 'السؤال التالي',
            onPressed: selectedAnswerIndex == null ? null : onNext,
            isLoading: isSaving,
          ),
        ],
      ),
    );
  }
}

class _QuestionHeader extends StatelessWidget {
  const _QuestionHeader({
    required this.lawName,
    required this.currentQuestionNumber,
    required this.totalQuestions,
  });

  final String lawName;
  final int currentQuestionNumber;
  final int totalQuestions;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              lawName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.h5Medium.copyWith(color: AppColors.white),
            ),
            Text(
              'السؤال $currentQuestionNumber من $totalQuestions',
              style: AppTextStyles.body2Regular.copyWith(
                color: AppColors.white.withValues(alpha: .75),
              ),
            ),
          ],
        ),
        const Spacer(),

        // Container(
        //   height: 35.h,
        //   padding: EdgeInsets.symmetric(horizontal: 14.w),
        //   decoration: BoxDecoration(
        //     color: AppColors.gold50,
        //     borderRadius: BorderRadius.circular(24.r),
        //   ),
        //   child: Row(
        //     mainAxisSize: MainAxisSize.min,
        //     children: [
        //       Text(
        //         '00:30',
        //         style: AppTextStyles.body2SemiBold.copyWith(
        //           color: AppColors.primaryColor,
        //         ),
        //       ),
        //       SizedBox(width: 8.w),
        //       Icon(Icons.timer, color: AppColors.primaryColor, size: 18.sp),
        //     ],
        //   ),
        // ),
        const Spacer(),

        const ExamBackButton(),
      ],
    );
  }
}

class QuestionAnswerTile extends StatelessWidget {
  const QuestionAnswerTile({
    super.key,
    required this.index,
    required this.text,
    required this.isSelected,
    required this.isCorrect,
    required this.showResult,
    required this.onTap,
  });

  final int index;
  final String text;
  final bool isSelected;
  final bool isCorrect;
  final bool showResult;
  final VoidCallback onTap;

  static const _letters = ['أ', 'ب', 'ج', 'د', 'هـ', 'و'];

  @override
  Widget build(BuildContext context) {
    final resultColor = isCorrect ? AppColors.success700 : AppColors.error100;
    final shouldRevealCorrectAnswer = showResult && isCorrect;
    final shouldRevealSelectedAnswer = showResult && isSelected;
    final shouldHighlight =
        shouldRevealCorrectAnswer || shouldRevealSelectedAnswer;
    final borderColor = shouldHighlight ? resultColor : AppColors.transparent;
    final badgeColor = shouldHighlight ? resultColor : AppColors.navyBlue50;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOut,
      height: 58.h,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(28.r),
        border: Border.all(color: borderColor, width: 2),
      ),
      child: InkWell(
        onTap: showResult ? null : onTap,
        borderRadius: BorderRadius.circular(28.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 240),
                width: 44.w,
                height: 44.w,
                decoration: BoxDecoration(
                  color: badgeColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    index < _letters.length ? _letters[index] : '${index + 1}',
                    style: AppTextStyles.body2SemiBold.copyWith(
                      color: shouldHighlight
                          ? AppColors.white
                          : AppColors.primaryColor,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 14.w),

              Expanded(
                flex: 6,
                child: Text(
                  text,
                  textAlign: TextAlign.right,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body2Regular.copyWith(
                    color: AppColors.primaryColor,
                  ),
                ),
              ),

              const Spacer(),

              _ResultIcon(showResult: shouldHighlight, isCorrect: isCorrect),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResultIcon extends StatelessWidget {
  const _ResultIcon({required this.showResult, required this.isCorrect});

  final bool showResult;
  final bool isCorrect;

  @override
  Widget build(BuildContext context) {
    if (!showResult) {
      return Container(
        width: 24.w,
        height: 24.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.navyBlue50, width: 2),
        ),
      );
    }

    return AnimatedScale(
      duration: const Duration(milliseconds: 220),
      scale: 1,
      child: Container(
        width: 24.w,
        height: 24.w,
        decoration: BoxDecoration(
          color: isCorrect ? AppColors.success700 : AppColors.error100,
          shape: BoxShape.circle,
        ),
        child: Icon(
          isCorrect ? Icons.check : Icons.close,
          color: AppColors.white,
          size: 16.sp,
        ),
      ),
    );
  }
}
