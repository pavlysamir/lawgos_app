import 'package:equatable/equatable.dart';

class ProfileData extends Equatable {
  const ProfileData({
    required this.userName,
    required this.email,
    required this.totalPoints,
    required this.totalAnsweredQuestions,
    required this.completedLevelsCount,
  });

  final String userName;
  final String email;
  final int totalPoints;
  final int totalAnsweredQuestions;
  final int completedLevelsCount;

  @override
  List<Object?> get props => [
    userName,
    email,
    totalPoints,
    totalAnsweredQuestions,
    completedLevelsCount,
  ];
}
