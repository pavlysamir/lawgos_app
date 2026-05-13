import 'package:dartz/dartz.dart';
import 'package:lowgos_app/core/error/failures.dart';
import 'package:lowgos_app/features/home/domain/entities/law_question.dart';
import 'package:lowgos_app/features/home/domain/repositories/home_repository.dart';

class GetMaterialQuestion {
  const GetMaterialQuestion(this.repository);

  final HomeRepository repository;

  Future<Either<Failure, LawQuestion>> call({
    required String lawId,
    required String materialId,
    required int level,
  }) {
    return repository.getMaterialQuestion(
      lawId: lawId,
      materialId: materialId,
      level: level,
    );
  }
}
