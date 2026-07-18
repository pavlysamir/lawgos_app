import 'package:equatable/equatable.dart';
import 'package:lowgos_app/core/helpers/enums.dart';

class LawLevel extends Equatable {
  const LawLevel({
    required this.id,
    required this.lawId,
    required this.levelNumber,
    required this.order,
    required this.questionsCount,
    required this.expectedDurationMinutes,
    required this.rewardPoints,
    required this.title,
    required this.isActive,
    required this.status,
  });

  final String id;
  final String lawId;
  final int levelNumber;
  final int order;
  final int questionsCount;
  final int expectedDurationMinutes;
  final int rewardPoints;
  final String title;
  final bool isActive;
  final LevelProgressStatus status;

  LawLevel copyWith({
    LevelProgressStatus? status,
    int? questionsCount,
  }) {
    return LawLevel(
      id: id,
      lawId: lawId,
      levelNumber: levelNumber,
      order: order,
      questionsCount: questionsCount ?? this.questionsCount,
      expectedDurationMinutes: expectedDurationMinutes,
      rewardPoints: rewardPoints,
      title: title,
      isActive: isActive,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
    id,
    lawId,
    levelNumber,
    order,
    questionsCount,
    expectedDurationMinutes,
    rewardPoints,
    title,
    isActive,
    status,
  ];
}
