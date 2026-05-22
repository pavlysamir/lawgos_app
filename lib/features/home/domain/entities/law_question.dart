import 'package:equatable/equatable.dart';
import 'package:lowgos_app/features/home/domain/entities/question_answer.dart';

class LawQuestion extends Equatable {
  const LawQuestion({
    required this.id,
    required this.lawId,
    required this.materialId,
    required this.level,
    required this.questionText,
    required this.answers,
    required this.difficulty,
  });

  final String id;
  final String lawId;
  final String materialId;
  final int level;
  final String questionText;
  final List<QuestionAnswer> answers;
  final String difficulty;

  @override
  List<Object?> get props => [
    id,
    lawId,
    materialId,
    level,
    questionText,
    answers,
    difficulty,
  ];
}
