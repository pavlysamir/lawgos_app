import 'package:dartz/dartz.dart';
import 'package:lowgos_app/core/error/failures.dart';
import 'package:lowgos_app/features/auth/domain/entities/auth_user.dart';
import 'package:lowgos_app/features/auth/domain/repositories/auth_repository.dart';

class SignUpWithEmail {
  const SignUpWithEmail(this.repository);

  final AuthRepository repository;

  Future<Either<Failure, AuthUser>> call(SignUpWithEmailParams params) {
    return repository.signUpWithEmail(
      name: params.name,
      email: params.email,
      password: params.password,
    );
  }
}

class SignUpWithEmailParams {
  const SignUpWithEmailParams({
    required this.name,
    required this.email,
    required this.password,
  });

  final String name;
  final String email;
  final String password;
}
