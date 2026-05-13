import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lowgos_app/core/helpers/enums.dart';
import 'package:lowgos_app/features/home/domain/entities/exam_session.dart';
import 'package:lowgos_app/features/home/domain/entities/law.dart';
import 'package:lowgos_app/features/home/domain/entities/law_level.dart';
import 'package:lowgos_app/features/home/domain/entities/law_material.dart';

class ExamSessionModel extends ExamSession {
  const ExamSessionModel({
    required super.id,
    required super.userId,
    required super.lawId,
    required super.level,
    required super.currentMaterialOrder,
    required super.currentQuestionIndex,
    required super.completedMaterialIds,
    required super.status,
  });

  factory ExamSessionModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};
    return ExamSessionModel(
      id: doc.id,
      userId: _readString(data, 'userId'),
      lawId: _readString(data, 'lawId'),
      level: _readInt(data, 'level'),
      currentMaterialOrder: _readInt(data, 'currentMaterialOrder'),
      currentQuestionIndex: _readInt(data, 'currentQuestionIndex'),
      completedMaterialIds:
          (data['completedMaterialIds'] as List?)?.whereType<String>().toList() ??
          const [],
      status: ExamSessionStatus.fromValue(_readString(data, 'status')),
    );
  }

  factory ExamSessionModel.initial({
    required String userId,
    required Law law,
    required LawLevel level,
    required LawMaterial firstMaterial,
  }) {
    return ExamSessionModel(
      id: '',
      userId: userId,
      lawId: law.id,
      level: level.levelNumber,
      currentMaterialOrder: firstMaterial.order,
      currentQuestionIndex: 0,
      completedMaterialIds: const [],
      status: ExamSessionStatus.inProgress,
    );
  }

  Map<String, dynamic> toCreateJson() {
    return {
      'userId': userId,
      'lawId': lawId,
      'level': level,
      'currentMaterialOrder': currentMaterialOrder,
      'currentQuestionIndex': currentQuestionIndex,
      'completedMaterialIds': completedMaterialIds,
      'status': status.value,
      'startedAt': Timestamp.now(),
    };
  }

  static int _readInt(Map<String, dynamic> data, String key) {
    final value = data[key];
    if (value is int) return value;
    if (value is num) return value.toInt();
    return 0;
  }

  static String _readString(Map<String, dynamic> data, String key) {
    final value = data[key];
    if (value is String) return value;
    return '';
  }
}
