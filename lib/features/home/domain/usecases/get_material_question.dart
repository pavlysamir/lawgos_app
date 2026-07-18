import 'package:dartz/dartz.dart';
import 'package:lowgos_app/core/error/failures.dart';
import 'package:lowgos_app/features/home/domain/entities/law_question.dart';
import 'package:lowgos_app/features/home/domain/repositories/home_repository.dart';

class GetMaterialQuestions {
  const GetMaterialQuestions(this.repository);

  final HomeRepository repository;

  Future<Either<Failure, List<LawQuestion>>> call({
    required String lawId,
    required String materialId,
    required int level,
  }) {
    return repository.getMaterialQuestions(
      lawId: lawId,
      materialId: materialId,
      level: level,
    );
  }
}
