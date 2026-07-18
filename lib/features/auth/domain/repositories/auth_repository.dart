import 'package:dartz/dartz.dart';
import 'package:lowgos_app/core/error/failures.dart';
import 'package:lowgos_app/features/auth/domain/entities/auth_user.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthUser>> loginWithEmail({
    required String email,
    required String password,
  });

  Future<Either<Failure, AuthUser>> signUpWithEmail({
    required String name,
    required String email,
    required String password,
  });

  Future<Either<Failure, AuthUser>> signInWithGoogle();
}
