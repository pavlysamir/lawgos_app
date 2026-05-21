import 'package:equatable/equatable.dart';

class Law extends Equatable {
  const Law({
    required this.id,
    required this.name,
    required this.completedLevelsCount,
    required this.completionPercentage,
    required this.materialsCount,
    required this.totalLevels,
    required this.totalQuestions,
    required this.isActive,
    required this.isDeleted,
  });

  final String id;
  final String name;
  final int completedLevelsCount;
  final int completionPercentage;
  final int materialsCount;
  final int totalLevels;
  final int totalQuestions;
  final bool isActive;
  final bool isDeleted;

  Law copyWith({
    int? completedLevelsCount,
    int? completionPercentage,
    int? totalLevels,
    int? totalQuestions,
  }) {
    return Law(
      id: id,
      name: name,
      completedLevelsCount: completedLevelsCount ?? this.completedLevelsCount,
      completionPercentage: completionPercentage ?? this.completionPercentage,
      materialsCount: materialsCount,
      totalLevels: totalLevels ?? this.totalLevels,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      isActive: isActive,
      isDeleted: isDeleted,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    completedLevelsCount,
    completionPercentage,
    materialsCount,
    totalLevels,
    totalQuestions,
    isActive,
    isDeleted,
  ];
}
