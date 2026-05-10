import 'package:equatable/equatable.dart';

class UserLawProgress extends Equatable {
  const UserLawProgress({
    required this.userId,
    required this.lawId,
    required this.lawName,
    required this.completedLevelsCount,
    required this.completionPercentage,
    required this.currentLevel,
    required this.totalSolvedQuestions,
    required this.totalPoints,
  });

  final String userId;
  final String lawId;
  final String lawName;
  final int completedLevelsCount;
  final int completionPercentage;
  final int currentLevel;
  final int totalSolvedQuestions;
  final int totalPoints;

  @override
  List<Object?> get props => [
    userId,
    lawId,
    lawName,
    completedLevelsCount,
    completionPercentage,
    currentLevel,
    totalSolvedQuestions,
    totalPoints,
  ];
}
