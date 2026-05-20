import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lowgos_app/core/helpers/enums.dart';
import 'package:lowgos_app/features/home/domain/entities/exam_flow_data.dart';
import 'package:lowgos_app/features/home/domain/entities/exam_session.dart';
import 'package:lowgos_app/features/home/domain/entities/law.dart';
import 'package:lowgos_app/features/home/domain/entities/law_level.dart';
import 'package:lowgos_app/features/home/domain/entities/law_material.dart';
import 'package:lowgos_app/features/home/domain/entities/law_question.dart';
import 'package:lowgos_app/features/home/domain/usecases/get_exam_flow_data.dart';
import 'package:lowgos_app/features/home/domain/usecases/get_material_question.dart';
import 'package:lowgos_app/features/home/domain/usecases/start_or_resume_exam_session.dart';
import 'package:lowgos_app/features/home/domain/usecases/submit_question_answer.dart';
import 'package:lowgos_app/features/home/presentation/cubit/exam_flow_state.dart';

class ExamFlowCubit extends Cubit<ExamFlowState> {
  ExamFlowCubit({
    required GetExamFlowData getExamFlowData,
    required StartOrResumeExamSession startOrResumeExamSession,
    required GetMaterialQuestions getMaterialQuestions,
    required SubmitQuestionAnswer submitQuestionAnswer,
  }) : _getExamFlowData = getExamFlowData,
       _startOrResumeExamSession = startOrResumeExamSession,
       _getMaterialQuestions = getMaterialQuestions,
       _submitQuestionAnswer = submitQuestionAnswer,
       super(const ExamFlowInitial());

  final GetExamFlowData _getExamFlowData;
  final StartOrResumeExamSession _startOrResumeExamSession;
  final GetMaterialQuestions _getMaterialQuestions;
  final SubmitQuestionAnswer _submitQuestionAnswer;

  static const _noMaterialQuestionMessage = 'لا يوجد سؤال لهذه المادة';

  final Map<String, List<LawQuestion>> _questionsByMaterialId = {};
  int _correctAnswersCount = 0;
  int _totalQuestionsCount = 0;

  Future<void> load({
    required Law law,
    required LawLevel level,
    required Color levelColor,
  }) async {
    _correctAnswersCount = 0;
    _totalQuestionsCount = 0;
    _questionsByMaterialId.clear();
    emit(const ExamFlowLoading());

    final result = await _getExamFlowData(law: law, level: level);
    await result.fold(
      (failure) async => emit(ExamFlowError(failure)),
      (data) async {
        final didLoadQuestions = await _cacheAllMaterialQuestions(
          data: data,
          levelColor: levelColor,
        );
        if (!didLoadQuestions) return;

        final firstMaterialIndex = _nextMaterialIndexWithQuestions(
          data: data,
          startIndex: 0,
        );
        if (firstMaterialIndex == null) {
          emit(ExamFlowEmptyQuestions(levelColor: levelColor));
          return;
        }

        emit(
          ExamFlowMaterial(
            data: data,
            material: data.materials[firstMaterialIndex],
            materialIndex: firstMaterialIndex,
            levelColor: levelColor,
          ),
        );
      },
    );
  }

  Future<void> startQuestions() async {
    final current = state;
    if (current is! ExamFlowMaterial || current.isStarting) return;

    emit(current.copyWith(isStarting: true));
    final existingSession = current.session;
    if (existingSession != null) {
      await _loadQuestion(
        data: current.data,
        session: existingSession,
        materialIndex: current.materialIndex,
        levelColor: current.levelColor,
      );
      return;
    }

    final result = await _startOrResumeExamSession(
      law: current.data.law,
      level: current.data.level,
      firstMaterial: current.material,
    );

    await result.fold((failure) async => emit(ExamFlowError(failure)), (
      session,
    ) async {
      _correctAnswersCount = session.correctAnswersCount;
      await _loadQuestion(
        data: current.data,
        session: session,
        materialIndex: _materialIndexForSession(current.data, session),
        levelColor: current.levelColor,
      );
    });
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

    final nextMaterialIndex = _nextMaterialIndexWithQuestions(
      data: current.data,
      startIndex: current.materialIndex + 1,
    );
    final isLastQuestionInLevel =
        current.isLastQuestionInMaterial && nextMaterialIndex == null;
    final totalQuestions = _totalQuestionsCount > 0
        ? _totalQuestionsCount
        : current.totalQuestionsCount;
    final correctAnswersAfterSubmit =
        _correctAnswersCount + (current.isSelectedAnswerCorrect ? 1 : 0);
    final percentageAfterSubmit = _calculatePercentage(
      correctAnswers: correctAnswersAfterSubmit,
      totalQuestions: totalQuestions,
    );
    final isLevelPassed = !isLastQuestionInLevel || percentageAfterSubmit >= 31;

    emit(current.copyWith(isSaving: true));
    final result = await _submitQuestionAnswer(
      law: current.data.law,
      level: current.data.level,
      session: current.session,
      materials: _materialsWithQuestions(current.data),
      currentMaterial: current.material,
      isCorrect: current.isSelectedAnswerCorrect,
      isLevelPassed: isLevelPassed,
      isLastQuestionInMaterial: current.isLastQuestionInMaterial,
      isLastQuestionInLevel: isLastQuestionInLevel,
    );

    await result.fold((failure) async => emit(ExamFlowError(failure)), (
      _,
    ) async {
      _correctAnswersCount = correctAnswersAfterSubmit;
      final nextMaterialOrder = nextMaterialIndex == null
          ? current.material.order
          : current.data.materials[nextMaterialIndex].order;
      final updatedSession = current.session.copyWith(
        currentMaterialOrder: current.isLastQuestionInMaterial
            ? nextMaterialOrder
            : current.material.order,
        currentQuestionIndex: current.isLastQuestionInMaterial
            ? 0
            : current.session.currentQuestionIndex + 1,
        answeredQuestionsCount: current.session.answeredQuestionsCount + 1,
        correctAnswersCount: correctAnswersAfterSubmit,
        completedMaterialIds: current.isLastQuestionInMaterial
            ? {
                ...current.session.completedMaterialIds,
                current.material.id,
              }.toList()
            : current.session.completedMaterialIds,
        status: isLastQuestionInLevel
            ? ExamSessionStatus.completed
            : ExamSessionStatus.inProgress,
      );

      if (isLastQuestionInLevel) {
        emit(
          ExamFlowCompleted(
            levelColor: current.levelColor,
            correctAnswersCount: _correctAnswersCount,
            totalQuestionsCount: totalQuestions,
            percentage: percentageAfterSubmit,
            earnedPoints: _correctAnswersCount * 10,
            isPassed: percentageAfterSubmit >= 31,
          ),
        );
        return;
      }

      if (!current.isLastQuestionInMaterial) {
        final nextQuestionIndex = current.questionIndex + 1;
        emit(
          current.copyWith(
            session: updatedSession,
            questionIndex: nextQuestionIndex,
            question: current.questions[nextQuestionIndex],
            clearSelectedAnswer: true,
            isAnswerSubmitted: false,
            isSaving: false,
            isLastQuestionInLevel:
                nextQuestionIndex == current.questions.length - 1 &&
                nextMaterialIndex == null,
          ),
        );
        return;
      }

      final nextIndex = nextMaterialIndex!;
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
    final questions = await _questionsForMaterial(
      data: data,
      materialIndex: materialIndex,
      levelColor: levelColor,
    );
    if (questions == null) return;
    if (questions.isEmpty) {
      final nextMaterialIndex = _nextMaterialIndexWithQuestions(
        data: data,
        startIndex: materialIndex + 1,
      );
      if (nextMaterialIndex == null) {
        emit(ExamFlowEmptyQuestions(levelColor: levelColor));
        return;
      }

      emit(
        ExamFlowMaterial(
          data: data,
          material: data.materials[nextMaterialIndex],
          materialIndex: nextMaterialIndex,
          levelColor: levelColor,
          session: session,
        ),
      );
      return;
    }

    final questionIndex = _questionIndexForSession(
      session: session,
      questions: questions,
    );
    final nextMaterialIndex = _nextMaterialIndexWithQuestions(
      data: data,
      startIndex: materialIndex + 1,
    );
    emit(
      ExamFlowQuestion(
        data: data,
        session: session,
        material: material,
        materialIndex: materialIndex,
        questions: questions,
        questionIndex: questionIndex,
        question: questions[questionIndex],
        totalQuestionsCount: _totalQuestionsCount,
        isLastQuestionInLevel:
            questionIndex == questions.length - 1 && nextMaterialIndex == null,
        levelColor: levelColor,
      ),
    );
  }

  Future<List<LawQuestion>?> _questionsForMaterial({
    required ExamFlowData data,
    required int materialIndex,
    required Color levelColor,
  }) async {
    final material = data.materials[materialIndex];
    final cached = _questionsByMaterialId[material.id];
    if (cached != null) return cached;

    final result = await _getMaterialQuestions(
      lawId: data.law.id,
      materialId: material.id,
      level: data.level.levelNumber,
    );

    return result.fold((failure) {
      if (failure.message == _noMaterialQuestionMessage) {
        _questionsByMaterialId[material.id] = const [];
        return const <LawQuestion>[];
      }

      emit(ExamFlowError(failure));
      return null;
    }, (questions) {
      _questionsByMaterialId[material.id] = questions;
      _totalQuestionsCount += questions.length;
      return questions;
    });
  }

  Future<bool> _cacheAllMaterialQuestions({
    required ExamFlowData data,
    required Color levelColor,
  }) async {
    for (var index = 0; index < data.materials.length; index++) {
      final questions = await _questionsForMaterial(
        data: data,
        materialIndex: index,
        levelColor: levelColor,
      );
      if (questions == null) return false;
    }
    return true;
  }

  int? _nextMaterialIndexWithQuestions({
    required ExamFlowData data,
    required int startIndex,
  }) {
    for (var index = startIndex; index < data.materials.length; index++) {
      final questions = _questionsByMaterialId[data.materials[index].id];
      if (questions != null && questions.isNotEmpty) return index;
    }
    return null;
  }

  List<LawMaterial> _materialsWithQuestions(ExamFlowData data) {
    return data.materials.where((material) {
      final questions = _questionsByMaterialId[material.id];
      return questions != null && questions.isNotEmpty;
    }).toList();
  }

  int _materialIndexForSession(ExamFlowData data, ExamSession session) {
    final index = data.materials.indexWhere(
      (material) => material.order == session.currentMaterialOrder,
    );
    return index < 0 ? 0 : index;
  }

  int _questionIndexForSession({
    required ExamSession session,
    required List<LawQuestion> questions,
  }) {
    if (session.currentQuestionIndex < 0) return 0;
    if (session.currentQuestionIndex >= questions.length) return 0;
    return session.currentQuestionIndex;
  }

  int _calculatePercentage({
    required int correctAnswers,
    required int totalQuestions,
  }) {
    if (totalQuestions == 0) return 0;
    return ((correctAnswers / totalQuestions) * 100).round();
  }
}
