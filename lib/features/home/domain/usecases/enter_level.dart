import 'package:dartz/dartz.dart';
import 'package:lowgos_app/core/error/failures.dart';
import 'package:lowgos_app/features/home/domain/entities/law_level.dart';
import 'package:lowgos_app/features/home/domain/repositories/home_repository.dart';

class EnterLevel {
  const EnterLevel(this.repository);

  final HomeRepository repository;

  Future<Either<Failure, Unit>> call(LawLevel level) {
    return repository.enterLevel(level);
  }
}
