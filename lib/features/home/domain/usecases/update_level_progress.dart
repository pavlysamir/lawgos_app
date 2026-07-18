import 'package:dartz/dartz.dart';
import 'package:lowgos_app/core/error/failures.dart';
import 'package:lowgos_app/core/helpers/enums.dart';
import 'package:lowgos_app/features/home/domain/entities/law_level.dart';
import 'package:lowgos_app/features/home/domain/repositories/home_repository.dart';

class UpdateLevelProgress {
  const UpdateLevelProgress(this.repository);

  final HomeRepository repository;

  Future<Either<Failure, Unit>> call(UpdateLevelProgressParams params) {
    return repository.updateLevelProgress(
      level: params.level,
      status: params.status,
      solvedQuestionsCount: params.solvedQuestionsCount,
      correctAnswersCount: params.correctAnswersCount,
      earnedPoints: params.earnedPoints,
    );
  }
}

class UpdateLevelProgressParams {
  const UpdateLevelProgressParams({
    required this.level,
    required this.status,
    required this.solvedQuestionsCount,
    required this.correctAnswersCount,
    required this.earnedPoints,
  });

  final LawLevel level;
  final LevelProgressStatus status;
  final int solvedQuestionsCount;
  final int correctAnswersCount;
  final int earnedPoints;
}
