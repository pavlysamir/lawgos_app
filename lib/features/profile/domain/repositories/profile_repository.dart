import 'package:dartz/dartz.dart';
import 'package:lowgos_app/core/error/failures.dart';
import 'package:lowgos_app/features/profile/domain/entities/profile_data.dart';

abstract class ProfileRepository {
  Future<Either<Failure, ProfileData>> getProfileData();

  Future<Either<Failure, ProfileData>> updateProfile({
    required String name,
    required String email,
  });

  Future<Either<Failure, Unit>> sendPasswordResetEmail(String email);

  Future<Either<Failure, Unit>> logout();

  Future<Either<Failure, Unit>> deleteAccount();
}
