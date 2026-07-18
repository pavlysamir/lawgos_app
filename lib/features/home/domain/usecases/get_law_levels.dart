import 'package:dartz/dartz.dart';
import 'package:lowgos_app/core/error/failures.dart';
import 'package:lowgos_app/features/home/domain/entities/law.dart';
import 'package:lowgos_app/features/home/domain/entities/law_levels_data.dart';
import 'package:lowgos_app/features/home/domain/repositories/home_repository.dart';

class GetLawLevels {
  const GetLawLevels(this.repository);

  final HomeRepository repository;

  Future<Either<Failure, LawLevelsData>> call(Law law) {
    return repository.getLawLevels(law);
  }
}
