import 'package:dartz/dartz.dart';
import 'package:lowgos_app/core/error/failures.dart';
import 'package:lowgos_app/features/home/domain/entities/user_law_progress.dart';
import 'package:lowgos_app/features/home/domain/repositories/home_repository.dart';

class StartLaw {
  const StartLaw(this.repository);

  final HomeRepository repository;

  Future<Either<Failure, UserLawProgress>> call(String lawId) {
    return repository.startLaw(lawId);
  }
}
