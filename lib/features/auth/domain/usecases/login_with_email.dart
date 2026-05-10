import 'package:dartz/dartz.dart';
import 'package:lowgos_app/core/error/failures.dart';
import 'package:lowgos_app/features/auth/domain/entities/auth_user.dart';
import 'package:lowgos_app/features/auth/domain/repositories/auth_repository.dart';

class LoginWithEmail {
  const LoginWithEmail(this.repository);

  final AuthRepository repository;

  Future<Either<Failure, AuthUser>> call(LoginWithEmailParams params) {
    return repository.loginWithEmail(
      email: params.email,
      password: params.password,
    );
  }
}

class LoginWithEmailParams {
  const LoginWithEmailParams({required this.email, required this.password});

  final String email;
  final String password;
}
