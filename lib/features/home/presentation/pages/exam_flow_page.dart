import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lowgos_app/core/theme/app_colors.dart';
import 'package:lowgos_app/core/theme/app_text_styles.dart';
import 'package:lowgos_app/features/home/domain/entities/law.dart';
import 'package:lowgos_app/features/home/domain/entities/law_level.dart';
import 'package:lowgos_app/features/home/presentation/cubit/exam_flow_cubit.dart';
import 'package:lowgos_app/features/home/presentation/cubit/exam_flow_state.dart';
import 'package:lowgos_app/features/home/presentation/widgets/exam_flow_scaffold.dart';
import 'package:lowgos_app/features/home/presentation/widgets/exam_result_view.dart';
import 'package:lowgos_app/features/home/presentation/widgets/material_text_view.dart';
import 'package:lowgos_app/features/home/presentation/widgets/question_view.dart';

class ExamFlowPageArgs {
  const ExamFlowPageArgs({
    required this.law,
    required this.level,
    required this.levelColor,
  });

  final Law law;
  final LawLevel level;
  final Color levelColor;
}

class ExamFlowPage extends StatefulWidget {
  const ExamFlowPage({super.key, required this.args});

  final ExamFlowPageArgs args;

  @override
  State<ExamFlowPage> createState() => _ExamFlowPageState();
}

class _ExamFlowPageState extends State<ExamFlowPage> {
  @override
  void initState() {
    super.initState();
    context.read<ExamFlowCubit>().load(
      law: widget.args.law,
      level: widget.args.level,
      levelColor: widget.args.levelColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ExamFlowCubit, ExamFlowState>(
      listener: (context, state) {
        if (state is ExamFlowError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.failure.message)));
        }
      },
      builder: (context, state) {
        if (state is ExamFlowLoading || state is ExamFlowInitial) {
          return ExamFlowScaffold(
            backgroundColor: widget.args.levelColor,
            child: const Center(
              child: CircularProgressIndicator(color: AppColors.white),
            ),
          );
        }

        if (state is ExamFlowMaterial) {
          return MaterialTextView(
            levelColor: state.levelColor,
            material: state.material,
            isStarting: state.isStarting,
            onStart: context.read<ExamFlowCubit>().startQuestions,
          );
        }

        if (state is ExamFlowQuestionLoading) {
          return ExamFlowScaffold(
            backgroundColor: state.levelColor,
            child: const Center(
              child: CircularProgressIndicator(color: AppColors.white),
            ),
          );
        }

        if (state is ExamFlowEmptyQuestions) {
          return ExamFlowScaffold(
            backgroundColor: state.levelColor,
            child: Column(
              children: [
                const Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: ExamBackButton(),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'لا توجد اسئله',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.h4Medium.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        if (state is ExamFlowQuestion) {
          return QuestionView(
            levelColor: state.levelColor,
            lawName: state.data.law.name,
            question: state.question,
            currentQuestionNumber: state.currentQuestionNumber,
            totalQuestions: state.totalQuestionsCount,
            selectedAnswerIndex: state.selectedAnswerIndex,
            isAnswerSubmitted: state.isAnswerSubmitted,
            isSaving: state.isSaving,
            isLastQuestion: state.isLastQuestionInLevel,
            onSelectAnswer: context.read<ExamFlowCubit>().selectAnswer,
            onNext: context.read<ExamFlowCubit>().submitSelectedAnswer,
          );
        }

        if (state is ExamFlowCompleted) {
          return ExamResultView(
            percentage: state.percentage,
            correctAnswersCount: state.correctAnswersCount,
            totalQuestionsCount: state.totalQuestionsCount,
            earnedPoints: state.earnedPoints,
            isPassed: state.isPassed,
            onBackPressed: () => Navigator.of(context).maybePop(),
            onPrimaryPressed: () {
              if (state.isPassed) {
                Navigator.of(context).maybePop();
                return;
              }

              context.read<ExamFlowCubit>().load(
                law: widget.args.law,
                level: widget.args.level,
                levelColor: widget.args.levelColor,
              );
            },
          );
        }

        if (state is ExamFlowError) {
          return ExamFlowScaffold(
            backgroundColor: widget.args.levelColor,
            child: Center(
              child: ExamPrimaryButton(
                label: 'إعادة المحاولة',
                onPressed: () {
                  context.read<ExamFlowCubit>().load(
                    law: widget.args.law,
                    level: widget.args.level,
                    levelColor: widget.args.levelColor,
                  );
                },
                backgroundColor: AppColors.gold50,
              ),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
