import 'package:dartz/dartz.dart';
import 'package:lowgos_app/core/error/failures.dart';
import 'package:lowgos_app/features/profile/domain/entities/profile_data.dart';
import 'package:lowgos_app/features/profile/domain/repositories/profile_repository.dart';

class GetProfileData {
  const GetProfileData(this.repository);

  final ProfileRepository repository;

  Future<Either<Failure, ProfileData>> call() {
    return repository.getProfileData();
  }
}
