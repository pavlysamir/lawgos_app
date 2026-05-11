import 'package:dartz/dartz.dart';
import 'package:lowgos_app/core/error/failures.dart';
import 'package:lowgos_app/core/helpers/enums.dart';
import 'package:lowgos_app/features/home/domain/entities/home_data.dart';
import 'package:lowgos_app/features/home/domain/entities/law.dart';
import 'package:lowgos_app/features/home/domain/entities/law_levels_data.dart';
import 'package:lowgos_app/features/home/domain/entities/user_law_progress.dart';
import 'package:lowgos_app/features/home/domain/entities/law_level.dart';

abstract class HomeRepository {
  Future<Either<Failure, HomeData>> getHomeData();

  Future<Either<Failure, UserLawProgress>> startLaw(String lawId);

  Future<Either<Failure, Unit>> updateLawProgress({
    required String lawId,
    required int completedLevelsCount,
    required int currentLevel,
    required int totalPoints,
  });

  Future<Either<Failure, LawLevelsData>> getLawLevels(Law law);

  Future<Either<Failure, Unit>> enterLevel(LawLevel level);

  Future<Either<Failure, Unit>> updateLevelProgress({
    required LawLevel level,
    required LevelProgressStatus status,
    required int solvedQuestionsCount,
    required int correctAnswersCount,
    required int earnedPoints,
  });
}
