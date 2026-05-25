import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lowgos_app/features/profile/domain/entities/profile_data.dart';
import 'package:lowgos_app/features/profile/domain/usecases/delete_profile_account.dart';
import 'package:lowgos_app/features/profile/domain/usecases/get_profile_data.dart';
import 'package:lowgos_app/features/profile/domain/usecases/logout_profile.dart';
import 'package:lowgos_app/features/profile/domain/usecases/send_password_reset_email.dart';
import 'package:lowgos_app/features/profile/domain/usecases/update_profile_data.dart';
import 'package:lowgos_app/features/profile/presentation/cubit/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({
    required GetProfileData getProfileData,
    required LogoutProfile logoutProfile,
    required DeleteProfileAccount deleteProfileAccount,
    required UpdateProfileData updateProfileData,
    required SendPasswordResetEmail sendPasswordResetEmail,
  }) : _getProfileData = getProfileData,
       _logoutProfile = logoutProfile,
       _deleteProfileAccount = deleteProfileAccount,
       _updateProfileData = updateProfileData,
       _sendPasswordResetEmail = sendPasswordResetEmail,
       super(const ProfileInitial());

  final GetProfileData _getProfileData;
  final LogoutProfile _logoutProfile;
  final DeleteProfileAccount _deleteProfileAccount;
  final UpdateProfileData _updateProfileData;
  final SendPasswordResetEmail _sendPasswordResetEmail;

  Future<void> loadProfile() async {
    emit(const ProfileLoading());
    final result = await _getProfileData();
    result.fold(
      (failure) => emit(ProfileError(failure)),
      (data) => emit(ProfileLoaded(data: data)),
    );
  }

  Future<void> logout() async {
    final data = _currentData;
    if (data == null) return;

    emit(ProfileActionLoading(data: data));
    final result = await _logoutProfile();
    result.fold(
      (failure) => emit(ProfileError(failure, data: data)),
      (_) => emit(const ProfileLogoutSuccess()),
    );
  }

  Future<void> deleteAccount() async {
    final data = _currentData;
    if (data == null) return;

    emit(ProfileActionLoading(data: data));
    final result = await _deleteProfileAccount();
    result.fold(
      (failure) => emit(ProfileError(failure, data: data)),
      (_) => emit(const ProfileDeleteAccountSuccess()),
    );
  }

  Future<void> updateProfile({
    required String name,
    required String email,
  }) async {
    final data = _currentData;
    if (data == null) return;

    emit(ProfileActionLoading(data: data));
    final result = await _updateProfileData(
      UpdateProfileDataParams(name: name, email: email),
    );
    result.fold(
      (failure) => emit(ProfileError(failure, data: data)),
      (updatedData) => emit(ProfileUpdateSuccess(data: updatedData)),
    );
  }

  Future<void> sendPasswordResetEmail(String email) async {
    final data = _currentData;
    if (data == null) return;

    emit(ProfileActionLoading(data: data));
    final result = await _sendPasswordResetEmail(email);
    result.fold(
      (failure) => emit(ProfileError(failure, data: data)),
      (_) => emit(ProfilePasswordResetEmailSent(data: data)),
    );
  }

  ProfileData? get _currentData {
    final current = state;
    if (current is ProfileLoaded) return current.data;
    if (current is ProfileActionLoading) return current.data;
    if (current is ProfileError) return current.data;
    if (current is ProfileUpdateSuccess) return current.data;
    if (current is ProfilePasswordResetEmailSent) return current.data;
    return null;
  }
}
