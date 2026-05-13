import 'package:equatable/equatable.dart';
import 'package:lowgos_app/core/helpers/enums.dart';

class ExamSession extends Equatable {
  const ExamSession({
    required this.id,
    required this.userId,
    required this.lawId,
    required this.level,
    required this.currentMaterialOrder,
    required this.currentQuestionIndex,
    required this.completedMaterialIds,
    required this.status,
  });

  final String id;
  final String userId;
  final String lawId;
  final int level;
  final int currentMaterialOrder;
  final int currentQuestionIndex;
  final List<String> completedMaterialIds;
  final ExamSessionStatus status;

  ExamSession copyWith({
    int? currentMaterialOrder,
    int? currentQuestionIndex,
    List<String>? completedMaterialIds,
    ExamSessionStatus? status,
  }) {
    return ExamSession(
      id: id,
      userId: userId,
      lawId: lawId,
      level: level,
      currentMaterialOrder: currentMaterialOrder ?? this.currentMaterialOrder,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      completedMaterialIds: completedMaterialIds ?? this.completedMaterialIds,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    lawId,
    level,
    currentMaterialOrder,
    currentQuestionIndex,
    completedMaterialIds,
    status,
  ];
}
