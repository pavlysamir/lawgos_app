import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lowgos_app/features/home/domain/entities/law.dart';

class LawModel extends Law {
  const LawModel({
    required super.id,
    required super.name,
    required super.completedLevelsCount,
    required super.completionPercentage,
    required super.materialsCount,
    required super.totalLevels,
    required super.totalQuestions,
    required super.isActive,
    required super.isDeleted,
  });

  factory LawModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return LawModel(
      id: _readString(data, 'id', fallback: doc.id),
      name: _readString(data, 'name', fallback: 'قانون بدون اسم'),
      completedLevelsCount: _readInt(data, 'completed_levels_count'),
      completionPercentage: _readInt(data, 'completion_percentage'),
      materialsCount: _readInt(data, 'materials_count'),
      totalLevels: _readInt(data, 'total_levels'),
      totalQuestions: _readInt(
        data,
        'total_active_questions',
        fallbackKey: 'total_questions',
      ),
      isActive: _readBool(data, 'is_active'),
      isDeleted: _readBool(data, 'is_deleted'),
    );
  }

  static int _readInt(
    Map<String, dynamic> data,
    String key, {
    String? fallbackKey,
  }) {
    final value = data[key] ?? (fallbackKey == null ? null : data[fallbackKey]);
    if (value is int) return value;
    if (value is num) return value.toInt();
    return 0;
  }

  static String _readString(
    Map<String, dynamic> data,
    String key, {
    required String fallback,
  }) {
    final value = data[key];
    if (value is String && value.trim().isNotEmpty) return value;
    return fallback;
  }

  static bool _readBool(Map<String, dynamic> data, String key) {
    final value = data[key];
    if (value is bool) return value;
    return false;
  }
}
