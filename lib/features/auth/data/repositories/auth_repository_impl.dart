import 'package:dartz/dartz.dart';
import 'package:lowgos_app/core/cashe/cache_helper.dart';
import 'package:lowgos_app/core/cashe/cashe_constance.dart';
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
      await _cacheUser(user);
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
      await _cacheUser(user);
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
      await _cacheUser(user);
      return Right(user);
    } on AuthException catch (error) {
      return Left(AuthFailure(error.message));
    } on ServerException catch (error) {
      return Left(ServerFailure(error.message));
    }
  }

  Future<void> _cacheUser(AuthUser user) async {
    await CacheHelper.set(key: CacheConstants.userId, value: user.id);
    await CacheHelper.set(key: CacheConstants.userEmail, value: user.email);
    await CacheHelper.set(key: CacheConstants.userName, value: user.name ?? '');
    if (user.photoUrl != null) {
      await CacheHelper.set(
        key: CacheConstants.userImage,
        value: user.photoUrl!,
      );
    }
  }
}
