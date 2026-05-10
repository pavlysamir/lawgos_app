import 'package:dartz/dartz.dart';
import 'package:lowgos_app/core/error/failures.dart';
import 'package:lowgos_app/features/home/domain/repositories/home_repository.dart';

class UpdateLawProgress {
  const UpdateLawProgress(this.repository);

  final HomeRepository repository;

  Future<Either<Failure, Unit>> call(UpdateLawProgressParams params) {
    return repository.updateLawProgress(
      lawId: params.lawId,
      completedLevelsCount: params.completedLevelsCount,
      currentLevel: params.currentLevel,
      totalPoints: params.totalPoints,
    );
  }
}

class UpdateLawProgressParams {
  const UpdateLawProgressParams({
    required this.lawId,
    required this.completedLevelsCount,
    required this.currentLevel,
    required this.totalPoints,
  });

  final String lawId;
  final int completedLevelsCount;
  final int currentLevel;
  final int totalPoints;
}
