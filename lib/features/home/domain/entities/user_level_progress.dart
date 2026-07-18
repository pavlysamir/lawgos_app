import 'package:equatable/equatable.dart';
import 'package:lowgos_app/core/helpers/enums.dart';

class UserLevelProgress extends Equatable {
  const UserLevelProgress({
    required this.userId,
    required this.lawId,
    required this.levelNumber,
    required this.status,
    required this.solvedQuestionsCount,
    required this.correctAnswersCount,
    required this.earnedPoints,
  });

  final String userId;
  final String lawId;
  final int levelNumber;
  final LevelProgressStatus status;
  final int solvedQuestionsCount;
  final int correctAnswersCount;
  final int earnedPoints;

  @override
  List<Object?> get props => [
    userId,
    lawId,
    levelNumber,
    status,
    solvedQuestionsCount,
    correctAnswersCount,
    earnedPoints,
  ];
}
