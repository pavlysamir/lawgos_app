import 'package:dartz/dartz.dart';
import 'package:lowgos_app/core/error/failures.dart';
import 'package:lowgos_app/features/profile/domain/entities/profile_data.dart';
import 'package:lowgos_app/features/profile/domain/repositories/profile_repository.dart';

class UpdateProfileData {
  const UpdateProfileData(this.repository);

  final ProfileRepository repository;

  Future<Either<Failure, ProfileData>> call(UpdateProfileDataParams params) {
    return repository.updateProfile(name: params.name, email: params.email);
  }
}

class UpdateProfileDataParams {
  const UpdateProfileDataParams({required this.name, required this.email});

  final String name;
  final String email;
}
