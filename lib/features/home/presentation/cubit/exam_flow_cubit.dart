import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lowgos_app/core/helpers/enums.dart';
import 'package:lowgos_app/features/home/domain/entities/exam_flow_data.dart';
import 'package:lowgos_app/features/home/domain/entities/exam_session.dart';
import 'package:lowgos_app/features/home/domain/entities/law.dart';
import 'package:lowgos_app/features/home/domain/entities/law_level.dart';
import 'package:lowgos_app/features/home/domain/usecases/get_exam_flow_data.dart';
import 'package:lowgos_app/features/home/domain/usecases/get_material_question.dart';
import 'package:lowgos_app/features/home/domain/usecases/start_or_resume_exam_session.dart';
import 'package:lowgos_app/features/home/domain/usecases/submit_question_answer.dart';
import 'package:lowgos_app/features/home/presentation/cubit/exam_flow_state.dart';

class ExamFlowCubit extends Cubit<ExamFlowState> {
  ExamFlowCubit({
    required GetExamFlowData getExamFlowData,
    required StartOrResumeExamSession startOrResumeExamSession,
    required GetMaterialQuestion getMaterialQuestion,
    required SubmitQuestionAnswer submitQuestionAnswer,
  }) : _getExamFlowData = getExamFlowData,
       _startOrResumeExamSession = startOrResumeExamSession,
       _getMaterialQuestion = getMaterialQuestion,
       _submitQuestionAnswer = submitQuestionAnswer,
       super(const ExamFlowInitial());

  final GetExamFlowData _getExamFlowData;
  final StartOrResumeExamSession _startOrResumeExamSession;
  final GetMaterialQuestion _getMaterialQuestion;
  final SubmitQuestionAnswer _submitQuestionAnswer;

  Future<void> load({
    required Law law,
    required LawLevel level,
    required Color levelColor,
  }) async {
    emit(const ExamFlowLoading());
    final result = await _getExamFlowData(law: law, level: level);
    result.fold(
      (failure) => emit(ExamFlowError(failure)),
      (data) => emit(
        ExamFlowMaterial(
          data: data,
          material: data.materials.first,
          materialIndex: 0,
          levelColor: levelColor,
        ),
      ),
    );
  }

  Future<void> startQuestions() async {
    final current = state;
    if (current is! ExamFlowMaterial || current.isStarting) return;

    emit(current.copyWith(isStarting: true));
    final result = await _startOrResumeExamSession(
      law: current.data.law,
      level: current.data.level,
      firstMaterial: current.data.materials.first,
    );

    await result.fold(
      (failure) async => emit(ExamFlowError(failure)),
      (session) async => _loadQuestion(
        data: current.data,
        session: session,
        materialIndex: _materialIndexForSession(current.data, session),
        levelColor: current.levelColor,
      ),
    );
  }

  void selectAnswer(int index) {
    final current = state;
    if (current is! ExamFlowQuestion || current.isAnswerSubmitted) return;
    emit(current.copyWith(selectedAnswerIndex: index, isAnswerSubmitted: true));
  }

  Future<void> submitSelectedAnswer() async {
    final current = state;
    if (current is! ExamFlowQuestion ||
        current.selectedAnswerIndex == null ||
        current.isSaving) {
      return;
    }

    emit(current.copyWith(isSaving: true));
    final result = await _submitQuestionAnswer(
      law: current.data.law,
      level: current.data.level,
      session: current.session,
      materials: current.data.materials,
      currentMaterial: current.material,
      isCorrect: current.isSelectedAnswerCorrect,
    );

    await result.fold((failure) async => emit(ExamFlowError(failure)), (
      _,
    ) async {
      final nextMaterialOrder = current.isLastMaterial
          ? current.material.order
          : current.data.materials[current.materialIndex + 1].order;
      final updatedSession = current.session.copyWith(
        currentMaterialOrder: nextMaterialOrder,
        currentQuestionIndex: current.session.currentQuestionIndex + 1,
        completedMaterialIds: {
          ...current.session.completedMaterialIds,
          current.material.id,
        }.toList(),
        status: current.isLastMaterial
            ? ExamSessionStatus.completed
            : ExamSessionStatus.inProgress,
      );

      if (current.isLastMaterial) {
        emit(ExamFlowCompleted(levelColor: current.levelColor));
        return;
      }

      final nextIndex = current.materialIndex + 1;
      emit(
        ExamFlowMaterial(
          data: current.data,
          material: current.data.materials[nextIndex],
          materialIndex: nextIndex,
          levelColor: current.levelColor,
          session: updatedSession,
        ),
      );
    });
  }

  Future<void> _loadQuestion({
    required ExamFlowData data,
    required ExamSession session,
    required int materialIndex,
    required Color levelColor,
  }) async {
    emit(ExamFlowQuestionLoading(levelColor: levelColor));
    final material = data.materials[materialIndex];
    final result = await _getMaterialQuestion(
      lawId: data.law.id,
      materialId: material.id,
      level: data.level.levelNumber,
    );

    result.fold(
      (failure) => emit(ExamFlowError(failure)),
      (question) => emit(
        ExamFlowQuestion(
          data: data,
          session: session,
          material: material,
          materialIndex: materialIndex,
          question: question,
          levelColor: levelColor,
        ),
      ),
    );
  }

  int _materialIndexForSession(ExamFlowData data, ExamSession session) {
    final index = data.materials.indexWhere(
      (material) => material.order == session.currentMaterialOrder,
    );
    return index < 0 ? 0 : index;
  }
}
