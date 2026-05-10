import 'package:dartz/dartz.dart';
import 'package:lowgos_app/core/error/exceptions.dart';
import 'package:lowgos_app/core/error/failures.dart';
import 'package:lowgos_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:lowgos_app/features/auth/domain/entities/auth_user.dart';
import 'package:lowgos_app/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({required AuthRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  final AuthRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, AuthUser>> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final user = await _remoteDataSource.loginWithEmail(
        email: email,
        password: password,
      );
      return Right(user);
    } on AuthException catch (error) {
      return Left(AuthFailure(error.message));
    } on ServerException catch (error) {
      return Left(ServerFailure(error.message));
    }
  }

  @override
  Future<Either<Failure, AuthUser>> signUpWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final user = await _remoteDataSource.signUpWithEmail(
        name: name,
        email: email,
        password: password,
      );
      return Right(user);
    } on AuthException catch (error) {
      return Left(AuthFailure(error.message));
    } on ServerException catch (error) {
      return Left(ServerFailure(error.message));
    }
  }

  @override
  Future<Either<Failure, AuthUser>> signInWithGoogle() async {
    try {
      final user = await _remoteDataSource.signInWithGoogle();
      return Right(user);
    } on AuthException catch (error) {
      return Left(AuthFailure(error.message));
    } on ServerException catch (error) {
      return Left(ServerFailure(error.message));
    }
  }
}
