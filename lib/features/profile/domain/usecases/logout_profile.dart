import 'package:dartz/dartz.dart';
import 'package:lowgos_app/core/error/failures.dart';
import 'package:lowgos_app/features/profile/domain/repositories/profile_repository.dart';

class LogoutProfile {
  const LogoutProfile(this.repository);

  final ProfileRepository repository;

  Future<Either<Failure, Unit>> call() {
    return repository.logout();
  }
}
