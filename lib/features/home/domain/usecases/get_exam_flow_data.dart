import 'package:dartz/dartz.dart';
import 'package:lowgos_app/core/error/failures.dart';
import 'package:lowgos_app/features/home/domain/entities/exam_flow_data.dart';
import 'package:lowgos_app/features/home/domain/entities/law.dart';
import 'package:lowgos_app/features/home/domain/entities/law_level.dart';
import 'package:lowgos_app/features/home/domain/repositories/home_repository.dart';

class GetExamFlowData {
  const GetExamFlowData(this.repository);

  final HomeRepository repository;

  Future<Either<Failure, ExamFlowData>> call({
    required Law law,
    required LawLevel level,
  }) {
    return repository.getExamFlowData(law: law, level: level);
  }
}
