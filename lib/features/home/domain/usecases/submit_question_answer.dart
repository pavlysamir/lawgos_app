import 'package:dartz/dartz.dart';
import 'package:lowgos_app/core/error/failures.dart';
import 'package:lowgos_app/features/home/domain/entities/exam_session.dart';
import 'package:lowgos_app/features/home/domain/entities/law.dart';
import 'package:lowgos_app/features/home/domain/entities/law_level.dart';
import 'package:lowgos_app/features/home/domain/entities/law_material.dart';
import 'package:lowgos_app/features/home/domain/repositories/home_repository.dart';

class SubmitQuestionAnswer {
  const SubmitQuestionAnswer(this.repository);

  final HomeRepository repository;

  Future<Either<Failure, Unit>> call({
    required Law law,
    required LawLevel level,
    required ExamSession session,
    required List<LawMaterial> materials,
    required LawMaterial currentMaterial,
    required bool isCorrect,
    required bool isLevelPassed,
    required bool isLastQuestionInMaterial,
    required bool isLastQuestionInLevel,
  }) {
    return repository.submitQuestionAnswer(
      law: law,
      level: level,
      session: session,
      materials: materials,
      currentMaterial: currentMaterial,
      isCorrect: isCorrect,
      isLevelPassed: isLevelPassed,
      isLastQuestionInMaterial: isLastQuestionInMaterial,
      isLastQuestionInLevel: isLastQuestionInLevel,
    );
  }
}
