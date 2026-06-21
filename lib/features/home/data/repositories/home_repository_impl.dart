import 'package:dartz/dartz.dart';
import 'package:lowgos_app/core/cashe/cache_helper.dart';
import 'package:lowgos_app/core/cashe/cashe_constance.dart';
import 'package:lowgos_app/core/error/exceptions.dart';
import 'package:lowgos_app/core/error/failures.dart';
import 'package:lowgos_app/core/helpers/enums.dart';
import 'package:lowgos_app/features/home/data/datasources/home_local_data_source.dart';
import 'package:lowgos_app/features/home/data/datasources/home_remote_data_source.dart';
import 'package:lowgos_app/features/home/domain/entities/exam_flow_data.dart';
import 'package:lowgos_app/features/home/domain/entities/exam_session.dart';
import 'package:lowgos_app/features/home/domain/entities/home_data.dart';
import 'package:lowgos_app/features/home/domain/entities/home_user.dart';
import 'package:lowgos_app/features/home/domain/entities/law.dart';
import 'package:lowgos_app/features/home/domain/entities/law_level.dart';
import 'package:lowgos_app/features/home/domain/entities/law_levels_data.dart';
import 'package:lowgos_app/features/home/domain/entities/law_material.dart';
import 'package:lowgos_app/features/home/domain/entities/law_question.dart';
import 'package:lowgos_app/features/home/domain/entities/leaderboard_page_data.dart';
import 'package:lowgos_app/features/home/domain/entities/user_level_progress.dart';
import 'package:lowgos_app/features/home/domain/entities/user_law_progress.dart';
import 'package:lowgos_app/features/home/domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  const HomeRepositoryImpl({
    required HomeLocalDataSource localDataSource,
    required HomeRemoteDataSource remoteDataSource,
  }) : _localDataSource = localDataSource,
       _remoteDataSource = remoteDataSource;

  final HomeLocalDataSource _localDataSource;
  final HomeRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, HomeData>> getHomeData() async {
    try {
      final user = _readUser();
      if (user.id.isEmpty) {
        return const Left(AuthFailure('برجاء تسجيل الدخول مرة أخرى'));
      }

      final laws = await _remoteDataSource.getLaws();
      final progress = await _remoteDataSource.getUserProgress(user.id);
      final mergedLaws = await _mergeProgress(
        laws: laws,
        progressItems: progress,
        userId: user.id,
      );
      return Right(
        HomeData(
          user: user,
          laws: mergedLaws,
          progressLaws: _progressLawsOnly(mergedLaws, progress),
        ),
      );
    } on ServerException catch (error) {
      return Left(ServerFailure(error.message));
    }
  }

  @override
  Future<Either<Failure, UserLawProgress>> startLaw(String lawId) async {
    try {
      final userId =
          _remoteDataSource.getCurrentUserId() ??
          CacheHelper.getString(key: CacheConstants.userId) ??
          '';
      if (userId.isEmpty) {
        return const Left(AuthFailure('برجاء تسجيل الدخول مرة أخرى'));
      }

      final laws = await _remoteDataSource.getLaws();
      final law = laws.firstWhere(
        (item) => item.id == lawId,
        orElse: () => throw const ServerException('القانون غير موجود'),
      );
      final progress = await _remoteDataSource.startLaw(
        userId: userId,
        law: law,
      );
      return Right(progress);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateLawProgress({
    required String lawId,
    required int completedLevelsCount,
    required int currentLevel,
    required int totalPoints,
  }) async {
    try {
      final userId =
          _remoteDataSource.getCurrentUserId() ??
          CacheHelper.getString(key: CacheConstants.userId) ??
          '';
      if (userId.isEmpty) {
        return const Left(AuthFailure('برجاء تسجيل الدخول مرة أخرى'));
      }

      final laws = await _remoteDataSource.getLaws();
      final law = laws.firstWhere(
        (item) => item.id == lawId,
        orElse: () => throw const ServerException('القانون غير موجود'),
      );

      await _remoteDataSource.updateLawProgress(
        userId: userId,
        law: law,
        completedLevelsCount: completedLevelsCount,
        currentLevel: currentLevel,
        totalPoints: totalPoints,
      );
      return const Right(unit);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.message));
    }
  }

  @override
  Future<Either<Failure, LawLevelsData>> getLawLevels(Law law) async {
    try {
      final userId =
          _remoteDataSource.getCurrentUserId() ??
          CacheHelper.getString(key: CacheConstants.userId) ??
          '';
      if (userId.isEmpty) {
        return const Left(AuthFailure('برجاء تسجيل الدخول مرة أخرى'));
      }

      final levels = await _remoteDataSource.getLawLevels(law.id);
      final progress = await _remoteDataSource.getUserLevelProgress(
        userId: userId,
        lawId: law.id,
      );

      final materials = await _remoteDataSource.getMaterials(law.id);
      final activeMaterialIds = materials.map((m) => m.id).toSet();

      final activeQuestions = await _remoteDataSource.getActiveQuestionsForLaw(law.id);

      final questionsCountPerLevel = <int, int>{};
      for (final q in activeQuestions) {
        if (activeMaterialIds.contains(q.materialId)) {
          questionsCountPerLevel[q.level] = (questionsCountPerLevel[q.level] ?? 0) + 1;
        }
      }

      final mergedLevels = _mergeLevelProgress(levels, progress);
      final updatedLevels = mergedLevels.map((level) {
        final actualCount = questionsCountPerLevel[level.levelNumber] ?? 0;
        return level.copyWith(
          questionsCount: actualCount,
        );
      }).toList();

      return Right(
        LawLevelsData(law: law, levels: updatedLevels),
      );
    } on ServerException catch (error) {
      return Left(ServerFailure(error.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> enterLevel(LawLevel level) async {
    try {
      final userId =
          _remoteDataSource.getCurrentUserId() ??
          CacheHelper.getString(key: CacheConstants.userId) ??
          '';
      if (userId.isEmpty) {
        return const Left(AuthFailure('برجاء تسجيل الدخول مرة أخرى'));
      }

      await _remoteDataSource.enterLevel(userId: userId, level: level);
      return const Right(unit);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateLevelProgress({
    required LawLevel level,
    required LevelProgressStatus status,
    required int solvedQuestionsCount,
    required int correctAnswersCount,
    required int earnedPoints,
  }) async {
    try {
      final userId =
          _remoteDataSource.getCurrentUserId() ??
          CacheHelper.getString(key: CacheConstants.userId) ??
          '';
      if (userId.isEmpty) {
        return const Left(AuthFailure('برجاء تسجيل الدخول مرة أخرى'));
      }

      await _remoteDataSource.updateLevelProgress(
        userId: userId,
        level: level,
        status: status,
        solvedQuestionsCount: solvedQuestionsCount,
        correctAnswersCount: correctAnswersCount,
        earnedPoints: earnedPoints,
      );
      return const Right(unit);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.message));
    }
  }

  HomeUser _readUser() {
    final cached = _localDataSource.getCachedUser();
    final firebaseUserId = _remoteDataSource.getCurrentUserId();
    if (cached.id.isNotEmpty || firebaseUserId == null) return cached;

    return HomeUser(
      id: firebaseUserId,
      name: cached.name,
      profileImage: cached.profileImage,
    );
  }

  Future<List<Law>> _mergeProgress({
    required List<Law> laws,
    required List<UserLawProgress> progressItems,
    required String userId,
  }) async {
    final progressByLaw = {for (final item in progressItems) item.lawId: item};
    final mergedLaws = <Law>[];

    for (final law in laws) {
      final progress = progressByLaw[law.id];
      final levels = await _remoteDataSource.getAllLawLevels(law.id);
      final materials = await _remoteDataSource.getMaterials(law.id);
      final activeMaterialIds = materials.map((m) => m.id).toSet();

      final activeQuestions = await _remoteDataSource.getActiveQuestionsForLaw(law.id);

      final questionsCountPerLevel = <int, int>{};
      for (final q in activeQuestions) {
        if (activeMaterialIds.contains(q.materialId)) {
          questionsCountPerLevel[q.level] = (questionsCountPerLevel[q.level] ?? 0) + 1;
        }
      }

      final updatedLevels = levels.map((level) {
        final actualCount = questionsCountPerLevel[level.levelNumber] ?? 0;
        return level.copyWith(
          questionsCount: actualCount,
        );
      }).toList();

      final totalQuestions = _totalLevelQuestions(updatedLevels);
      final totalLevels = updatedLevels.length;
      final correctAnswers = await _remoteDataSource
          .getUserCorrectAnswersCountForLaw(userId: userId, lawId: law.id);
      final completionPercentage = _calculatePercentage(
        correctAnswers: correctAnswers,
        totalQuestions: totalQuestions,
      );

      if (progress == null) {
        mergedLaws.add(
          law.copyWith(
            totalQuestions: totalQuestions,
            totalLevels: totalLevels,
            completionPercentage: completionPercentage,
          ),
        );
        continue;
      }

      mergedLaws.add(
        law.copyWith(
          completedLevelsCount: progress.completedLevelsCount,
          completionPercentage: completionPercentage,
          totalLevels: totalLevels,
          totalQuestions: totalQuestions,
        ),
      );
    }

    return mergedLaws;
  }

  List<Law> _progressLawsOnly(
    List<Law> laws,
    List<UserLawProgress> progressItems,
  ) {
    final lawsById = {for (final law in laws) law.id: law};

    return progressItems.map((progress) {
      final law = lawsById[progress.lawId];

      return (law ?? _fallbackLawFromProgress(progress)).copyWith(
        completedLevelsCount: progress.completedLevelsCount,
        completionPercentage: law?.completionPercentage,
        totalLevels: law?.totalLevels,
        totalQuestions: law?.totalQuestions,
      );
    }).toList();
  }

  int _totalLevelQuestions(List<LawLevel> levels) {
    return levels.fold<int>(0, (total, level) => total + level.questionsCount);
  }



  int _calculatePercentage({
    required int correctAnswers,
    required int totalQuestions,
  }) {
    if (totalQuestions == 0) return 0;
    return ((correctAnswers / totalQuestions) * 100).round().clamp(0, 100);
  }

  Law _fallbackLawFromProgress(UserLawProgress progress) {
    return Law(
      id: progress.lawId,
      name: progress.lawName,
      completedLevelsCount: progress.completedLevelsCount,
      completionPercentage: progress.completionPercentage,
      materialsCount: 0,
      totalLevels: 0,
      totalQuestions: progress.totalSolvedQuestions,
      isActive: true,
      isDeleted: false,
    );
  }

  List<LawLevel> _mergeLevelProgress(
    List<LawLevel> levels,
    List<UserLevelProgress> progressItems,
  ) {
    final progressByLevel = {
      for (final item in progressItems) item.levelNumber: item,
    };

    return levels.map((level) {
      final progress = progressByLevel[level.levelNumber];
      if (progress == null) return level;
      return level.copyWith(status: progress.status);
    }).toList();
  }

  @override
  Future<Either<Failure, ExamFlowData>> getExamFlowData({
    required Law law,
    required LawLevel level,
  }) async {
    try {
      final materials = await _remoteDataSource.getMaterials(law.id);
      if (materials.isEmpty) {
        return const Left(ServerFailure('لا توجد مواد لهذا القانون'));
      }

      return Right(ExamFlowData(law: law, level: level, materials: materials));
    } on ServerException catch (error) {
      return Left(ServerFailure(error.message));
    }
  }

  @override
  Future<Either<Failure, List<LawQuestion>>> getMaterialQuestions({
    required String lawId,
    required String materialId,
    required int level,
  }) async {
    try {
      final questions = await _remoteDataSource.getQuestions(
        lawId: lawId,
        materialId: materialId,
        level: level,
      );
      if (questions.isEmpty) {
        return const Left(ServerFailure('لا يوجد سؤال لهذه المادة'));
      }

      return Right(questions);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.message));
    }
  }

  @override
  Future<Either<Failure, LeaderboardPageData>> getLeaderboard({
    String? lawId,
    LeaderboardCursor? cursor,
    int limit = 20,
  }) async {
    try {
      final userId =
          _remoteDataSource.getCurrentUserId() ??
          CacheHelper.getString(key: CacheConstants.userId) ??
          '';
      if (userId.isEmpty) {
        return const Left(AuthFailure('برجاء تسجيل الدخول مرة أخرى'));
      }

      final data = await _remoteDataSource.getLeaderboard(
        userId: userId,
        lawId: lawId,
        cursor: cursor,
        limit: limit,
      );
      return Right(data);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.message));
    }
  }

  @override
  Future<Either<Failure, ExamSession>> startOrResumeExamSession({
    required Law law,
    required LawLevel level,
    required LawMaterial firstMaterial,
  }) async {
    try {
      final userId =
          _remoteDataSource.getCurrentUserId() ??
          CacheHelper.getString(key: CacheConstants.userId) ??
          '';
      if (userId.isEmpty) {
        return const Left(AuthFailure('برجاء تسجيل الدخول مرة أخرى'));
      }

      final activeSession = await _remoteDataSource.getActiveExamSession(
        userId: userId,
        lawId: law.id,
        level: level.levelNumber,
      );
      if (activeSession != null) return Right(activeSession);

      final session = await _remoteDataSource.createExamSession(
        userId: userId,
        law: law,
        level: level,
        firstMaterial: firstMaterial,
      );
      return Right(session);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.message));
    }
  }

  @override
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
  }) async {
    try {
      final userId =
          _remoteDataSource.getCurrentUserId() ??
          CacheHelper.getString(key: CacheConstants.userId) ??
          '';
      if (userId.isEmpty) {
        return const Left(AuthFailure('برجاء تسجيل الدخول مرة أخرى'));
      }
      final user = _readUser();

      final currentIndex = materials.indexWhere(
        (material) => material.id == currentMaterial.id,
      );
      if (currentIndex < 0) {
        return const Left(ServerFailure('المادة الحالية غير موجودة'));
      }

      final isLastMaterial = currentIndex == materials.length - 1;
      final completedMaterialIds = isLastQuestionInMaterial
          ? {...session.completedMaterialIds, currentMaterial.id}.toList()
          : session.completedMaterialIds;
      final nextMaterialOrder = !isLastQuestionInMaterial || isLastMaterial
          ? currentMaterial.order
          : materials[currentIndex + 1].order;

      await _remoteDataSource.updateExamSession(
        sessionId: session.id,
        currentMaterialOrder: nextMaterialOrder,
        currentQuestionIndex: isLastQuestionInMaterial
            ? 0
            : session.currentQuestionIndex + 1,
        answeredQuestionsCount: session.answeredQuestionsCount + 1,
        correctAnswersCount: session.correctAnswersCount + (isCorrect ? 1 : 0),
        completedMaterialIds: completedMaterialIds,
        status: isLastQuestionInLevel
            ? ExamSessionStatus.completed
            : ExamSessionStatus.inProgress,
      );
      await _remoteDataSource.applyQuestionResult(
        userId: userId,
        userName: user.name.isEmpty ? 'مستخدم' : user.name,
        userPhotoUrl: user.profileImage,
        law: law,
        level: level,
        questionId: question.id,
        difficulty: question.difficulty,
        isCorrect: isCorrect,
        isLevelCompleted: isLastQuestionInLevel && isLevelPassed,
      );

      return const Right(unit);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.message));
    }
  }
}
