import 'package:dartz/dartz.dart';
import 'package:lowgos_app/core/error/failures.dart';
import 'package:lowgos_app/core/helpers/enums.dart';
import 'package:lowgos_app/features/home/domain/entities/home_data.dart';
import 'package:lowgos_app/features/home/domain/entities/exam_flow_data.dart';
import 'package:lowgos_app/features/home/domain/entities/exam_session.dart';
import 'package:lowgos_app/features/home/domain/entities/law.dart';
import 'package:lowgos_app/features/home/domain/entities/law_levels_data.dart';
import 'package:lowgos_app/features/home/domain/entities/law_material.dart';
import 'package:lowgos_app/features/home/domain/entities/user_law_progress.dart';
import 'package:lowgos_app/features/home/domain/entities/law_level.dart';
import 'package:lowgos_app/features/home/domain/entities/law_question.dart';

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

  Future<Either<Failure, ExamFlowData>> getExamFlowData({
    required Law law,
    required LawLevel level,
  });

  Future<Either<Failure, ExamSession>> startOrResumeExamSession({
    required Law law,
    required LawLevel level,
    required LawMaterial firstMaterial,
  });

  Future<Either<Failure, List<LawQuestion>>> getMaterialQuestions({
    required String lawId,
    required String materialId,
    required int level,
  });

  Future<Either<Failure, Unit>> submitQuestionAnswer({
    required Law law,
    required LawLevel level,
    required ExamSession session,
    required LawQuestion question,
    required List<LawMaterial> materials,
    required LawMaterial currentMaterial,
    required bool isCorrect,
    required bool isLevelPassed,
    required bool isLastQuestionInMaterial,
    required bool isLastQuestionInLevel,
  });
}
