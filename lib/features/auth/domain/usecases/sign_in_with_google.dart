import 'package:dartz/dartz.dart';
import 'package:lowgos_app/core/error/failures.dart';
import 'package:lowgos_app/features/auth/domain/entities/auth_user.dart';
import 'package:lowgos_app/features/auth/domain/repositories/auth_repository.dart';

class SignInWithGoogle {
  const SignInWithGoogle(this.repository);

  final AuthRepository repository;

  Future<Either<Failure, AuthUser>> call() {
    return repository.signInWithGoogle();
  }
}
