import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:lowgos_app/core/error/failures.dart';
import 'package:lowgos_app/features/home/domain/entities/exam_flow_data.dart';
import 'package:lowgos_app/features/home/domain/entities/exam_session.dart';
import 'package:lowgos_app/features/home/domain/entities/law_material.dart';
import 'package:lowgos_app/features/home/domain/entities/law_question.dart';

abstract class ExamFlowState extends Equatable {
  const ExamFlowState();

  @override
  List<Object?> get props => [];
}

class ExamFlowInitial extends ExamFlowState {
  const ExamFlowInitial();
}

class ExamFlowLoading extends ExamFlowState {
  const ExamFlowLoading();
}

class ExamFlowMaterial extends ExamFlowState {
  const ExamFlowMaterial({
    required this.data,
    required this.material,
    required this.materialIndex,
    required this.levelColor,
    this.session,
    this.isStarting = false,
  });

  final ExamFlowData data;
  final LawMaterial material;
  final int materialIndex;
  final Color levelColor;
  final ExamSession? session;
  final bool isStarting;

  ExamFlowMaterial copyWith({ExamSession? session, bool? isStarting}) {
    return ExamFlowMaterial(
      data: data,
      material: material,
      materialIndex: materialIndex,
      levelColor: levelColor,
      session: session ?? this.session,
      isStarting: isStarting ?? this.isStarting,
    );
  }

  @override
  List<Object?> get props => [
    data,
    material,
    materialIndex,
    levelColor,
    session,
    isStarting,
  ];
}

class ExamFlowQuestionLoading extends ExamFlowState {
  const ExamFlowQuestionLoading({required this.levelColor});

  final Color levelColor;

  @override
  List<Object?> get props => [levelColor];
}

class ExamFlowEmptyQuestions extends ExamFlowState {
  const ExamFlowEmptyQuestions({required this.levelColor});

  final Color levelColor;

  @override
  List<Object?> get props => [levelColor];
}

class ExamFlowQuestion extends ExamFlowState {
  const ExamFlowQuestion({
    required this.data,
    required this.session,
    required this.material,
    required this.materialIndex,
    required this.questions,
    required this.questionIndex,
    required this.question,
    required this.totalQuestionsCount,
    required this.isLastQuestionInLevel,
    required this.levelColor,
    this.selectedAnswerIndex,
    this.isAnswerSubmitted = false,
    this.isSaving = false,
  });

  final ExamFlowData data;
  final ExamSession session;
  final LawMaterial material;
  final int materialIndex;
  final List<LawQuestion> questions;
  final int questionIndex;
  final LawQuestion question;
  final int totalQuestionsCount;
  final bool isLastQuestionInLevel;
  final Color levelColor;
  final int? selectedAnswerIndex;
  final bool isAnswerSubmitted;
  final bool isSaving;

  bool get isLastQuestionInMaterial => questionIndex == questions.length - 1;

  int get currentQuestionNumber => session.answeredQuestionsCount + 1;

  bool get isSelectedAnswerCorrect {
    final index = selectedAnswerIndex;
    if (index == null) return false;
    return question.answers[index].isCorrect;
  }

  ExamFlowQuestion copyWith({
    ExamSession? session,
    List<LawQuestion>? questions,
    int? questionIndex,
    LawQuestion? question,
    int? totalQuestionsCount,
    bool? isLastQuestionInLevel,
    int? selectedAnswerIndex,
    bool clearSelectedAnswer = false,
    bool? isAnswerSubmitted,
    bool? isSaving,
  }) {
    return ExamFlowQuestion(
      data: data,
      session: session ?? this.session,
      material: material,
      materialIndex: materialIndex,
      questions: questions ?? this.questions,
      questionIndex: questionIndex ?? this.questionIndex,
      question: question ?? this.question,
      totalQuestionsCount: totalQuestionsCount ?? this.totalQuestionsCount,
      isLastQuestionInLevel:
          isLastQuestionInLevel ?? this.isLastQuestionInLevel,
      levelColor: levelColor,
      selectedAnswerIndex: clearSelectedAnswer
          ? null
          : selectedAnswerIndex ?? this.selectedAnswerIndex,
      isAnswerSubmitted: isAnswerSubmitted ?? this.isAnswerSubmitted,
      isSaving: isSaving ?? this.isSaving,
    );
  }

  @override
  List<Object?> get props => [
    data,
    session,
    material,
    materialIndex,
    questions,
    questionIndex,
    question,
    totalQuestionsCount,
    isLastQuestionInLevel,
    levelColor,
    selectedAnswerIndex,
    isAnswerSubmitted,
    isSaving,
  ];
}

class ExamFlowCompleted extends ExamFlowState {
  const ExamFlowCompleted({
    required this.levelColor,
    required this.correctAnswersCount,
    required this.totalQuestionsCount,
    required this.percentage,
    required this.earnedPoints,
    required this.isPassed,
  });

  final Color levelColor;
  final int correctAnswersCount;
  final int totalQuestionsCount;
  final int percentage;
  final int earnedPoints;
  final bool isPassed;

  @override
  List<Object?> get props => [
    levelColor,
    correctAnswersCount,
    totalQuestionsCount,
    percentage,
    earnedPoints,
    isPassed,
  ];
}

class ExamFlowError extends ExamFlowState {
  const ExamFlowError(this.failure);

  final Failure failure;

  @override
  List<Object?> get props => [failure];
}
