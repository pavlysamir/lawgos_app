import 'package:dartz/dartz.dart';
import 'package:lowgos_app/core/error/failures.dart';
import 'package:lowgos_app/features/home/domain/entities/home_data.dart';
import 'package:lowgos_app/features/home/domain/entities/user_law_progress.dart';

abstract class HomeRepository {
  Future<Either<Failure, HomeData>> getHomeData();

  Future<Either<Failure, UserLawProgress>> startLaw(String lawId);

  Future<Either<Failure, Unit>> updateLawProgress({
    required String lawId,
    required int completedLevelsCount,
    required int currentLevel,
    required int totalPoints,
  });
}
