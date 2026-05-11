import 'package:dartz/dartz.dart';
import 'package:lowgos_app/core/cashe/cache_helper.dart';
import 'package:lowgos_app/core/cashe/cashe_constance.dart';
import 'package:lowgos_app/core/error/exceptions.dart';
import 'package:lowgos_app/core/error/failures.dart';
import 'package:lowgos_app/core/helpers/enums.dart';
import 'package:lowgos_app/features/home/data/datasources/home_local_data_source.dart';
import 'package:lowgos_app/features/home/data/datasources/home_remote_data_source.dart';
import 'package:lowgos_app/features/home/domain/entities/home_data.dart';
import 'package:lowgos_app/features/home/domain/entities/home_user.dart';
import 'package:lowgos_app/features/home/domain/entities/law.dart';
import 'package:lowgos_app/features/home/domain/entities/law_level.dart';
import 'package:lowgos_app/features/home/domain/entities/law_levels_data.dart';
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
      return Right(
        HomeData(
          user: user,
          laws: _mergeProgress(laws, progress),
          progressLaws: _mergeProgressLawsOnly(laws, progress),
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

      return Right(
        LawLevelsData(law: law, levels: _mergeLevelProgress(levels, progress)),
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

  List<Law> _mergeProgress(
    List<Law> laws,
    List<UserLawProgress> progressItems,
  ) {
    final progressByLaw = {for (final item in progressItems) item.lawId: item};

    return laws.map((law) {
      final progress = progressByLaw[law.id];
      if (progress == null) return law;

      final percentage = law.totalLevels == 0
          ? progress.completionPercentage
          : ((progress.completedLevelsCount / law.totalLevels) * 100).round();

      return law.copyWith(
        completedLevelsCount: progress.completedLevelsCount,
        completionPercentage: percentage.clamp(0, 100).toInt(),
      );
    }).toList();
  }

  List<Law> _mergeProgressLawsOnly(
    List<Law> laws,
    List<UserLawProgress> progressItems,
  ) {
    final lawsById = {for (final law in laws) law.id: law};

    return progressItems.map((progress) {
      final law = lawsById[progress.lawId];
      final totalLevels = law?.totalLevels ?? 0;
      final percentage = totalLevels == 0
          ? progress.completionPercentage
          : ((progress.completedLevelsCount / totalLevels) * 100).round();

      return (law ?? _fallbackLawFromProgress(progress)).copyWith(
        completedLevelsCount: progress.completedLevelsCount,
        completionPercentage: percentage.clamp(0, 100).toInt(),
      );
    }).toList();
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
}
