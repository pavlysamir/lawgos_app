import 'package:equatable/equatable.dart';
import 'package:lowgos_app/core/error/failures.dart';
import 'package:lowgos_app/features/profile/domain/entities/profile_data.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileLoaded extends ProfileState {
  const ProfileLoaded({required this.data});

  final ProfileData data;

  @override
  List<Object?> get props => [data];
}

class ProfileActionLoading extends ProfileState {
  const ProfileActionLoading({required this.data});

  final ProfileData data;

  @override
  List<Object?> get props => [data];
}

class ProfileLogoutSuccess extends ProfileState {
  const ProfileLogoutSuccess();
}

class ProfileDeleteAccountSuccess extends ProfileState {
  const ProfileDeleteAccountSuccess();
}

class ProfileUpdateSuccess extends ProfileState {
  const ProfileUpdateSuccess({required this.data});

  final ProfileData data;

  @override
  List<Object?> get props => [data];
}

class ProfilePasswordResetEmailSent extends ProfileState {
  const ProfilePasswordResetEmailSent({required this.data});

  final ProfileData data;

  @override
  List<Object?> get props => [data];
}

class ProfileError extends ProfileState {
  const ProfileError(this.failure, {this.data});

  final Failure failure;
  final ProfileData? data;

  @override
  List<Object?> get props => [failure, data];
}
