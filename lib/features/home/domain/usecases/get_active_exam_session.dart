import 'package:dartz/dartz.dart';
import 'package:lowgos_app/core/error/failures.dart';
import 'package:lowgos_app/features/home/domain/entities/exam_session.dart';
import 'package:lowgos_app/features/home/domain/repositories/home_repository.dart';

class GetActiveExamSession {
  const GetActiveExamSession(this.repository);

  final HomeRepository repository;

  Future<Either<Failure, ExamSession?>> call({
    required String lawId,
    required int level,
  }) {
    return repository.getActiveExamSession(lawId: lawId, level: level);
  }
}
