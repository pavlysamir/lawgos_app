import 'package:dartz/dartz.dart';
import 'package:lowgos_app/core/cashe/cache_helper.dart';
import 'package:lowgos_app/core/cashe/cashe_constance.dart';
import 'package:lowgos_app/core/error/exceptions.dart';
import 'package:lowgos_app/core/error/failures.dart';
import 'package:lowgos_app/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:lowgos_app/features/profile/domain/entities/profile_data.dart';
import 'package:lowgos_app/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl({required ProfileRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  final ProfileRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, ProfileData>> getProfileData() async {
    try {
      final userId =
          _remoteDataSource.getCurrentUserId() ??
          CacheHelper.getString(key: CacheConstants.userId) ??
          '';
      if (userId.isEmpty) {
        return const Left(AuthFailure('برجاء تسجيل الدخول مرة أخرى'));
      }

      final profile = await _remoteDataSource.getProfileData(
        userId: userId,
        cachedUserName:
            CacheHelper.getString(key: CacheConstants.userName) ?? '',
        cachedEmail:
            CacheHelper.getString(key: CacheConstants.userEmail) ?? '',
      );
      return Right(profile);
    } on AuthException catch (error) {
      return Left(AuthFailure(error.message));
    } on ServerException catch (error) {
      return Left(ServerFailure(error.message));
    }
  }

  @override
  Future<Either<Failure, ProfileData>> updateProfile({
    required String name,
    required String email,
  }) async {
    try {
      final userId =
          _remoteDataSource.getCurrentUserId() ??
          CacheHelper.getString(key: CacheConstants.userId) ??
          '';
      if (userId.isEmpty) {
        return const Left(AuthFailure('برجاء تسجيل الدخول مرة أخرى'));
      }

      final profile = await _remoteDataSource.updateProfile(
        userId: userId,
        name: name,
        email: email,
      );
      await CacheHelper.set(
        key: CacheConstants.userName,
        value: profile.userName,
      );
      await CacheHelper.set(
        key: CacheConstants.userEmail,
        value: profile.email,
      );
      return Right(profile);
    } on AuthException catch (error) {
      return Left(AuthFailure(error.message));
    } on ServerException catch (error) {
      return Left(ServerFailure(error.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> sendPasswordResetEmail(String email) async {
    try {
      await _remoteDataSource.sendPasswordResetEmail(email);
      return const Right(unit);
    } on AuthException catch (error) {
      return Left(AuthFailure(error.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    try {
      await _remoteDataSource.logout();
      await _clearUserCache();
      return const Right(unit);
    } on AuthException catch (error) {
      return Left(AuthFailure(error.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteAccount() async {
    try {
      await _remoteDataSource.deleteAccount();
      await _clearUserCache();
      return const Right(unit);
    } on AuthException catch (error) {
      return Left(AuthFailure(error.message));
    } on ServerException catch (error) {
      return Left(ServerFailure(error.message));
    }
  }

  Future<void> _clearUserCache() async {
    await CacheHelper.delete(key: CacheConstants.userId);
    await CacheHelper.delete(key: CacheConstants.userEmail);
    await CacheHelper.delete(key: CacheConstants.userName);
    await CacheHelper.delete(key: CacheConstants.userImage);
  }
}
