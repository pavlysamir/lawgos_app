import 'package:dartz/dartz.dart';
import 'package:lowgos_app/core/error/failures.dart';
import 'package:lowgos_app/features/home/domain/entities/exam_session.dart';
import 'package:lowgos_app/features/home/domain/entities/law.dart';
import 'package:lowgos_app/features/home/domain/entities/law_level.dart';
import 'package:lowgos_app/features/home/domain/entities/law_material.dart';
import 'package:lowgos_app/features/home/domain/repositories/home_repository.dart';

class StartOrResumeExamSession {
  const StartOrResumeExamSession(this.repository);

  final HomeRepository repository;

  Future<Either<Failure, ExamSession>> call({
    required Law law,
    required LawLevel level,
    required LawMaterial firstMaterial,
  }) {
    return repository.startOrResumeExamSession(
      law: law,
      level: level,
      firstMaterial: firstMaterial,
    );
  }
}
