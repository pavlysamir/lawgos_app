import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lowgos_app/core/helpers/enums.dart';
import 'package:lowgos_app/features/home/domain/entities/law_level.dart';

class LawLevelModel extends LawLevel {
  const LawLevelModel({
    required super.id,
    required super.lawId,
    required super.levelNumber,
    required super.order,
    required super.questionsCount,
    required super.expectedDurationMinutes,
    required super.rewardPoints,
    required super.title,
    required super.isActive,
    required super.status,
  });

  factory LawLevelModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};
    return LawLevelModel(
      id: _readString(data, 'id', fallback: doc.id),
      lawId: _readString(data, 'law_id', fallback: ''),
      levelNumber: _readInt(data, 'level_number'),
      order: _readInt(data, 'order'),
      questionsCount: _readInt(data, 'questions_count'),
      expectedDurationMinutes: _readInt(data, 'expected_duration_minutes'),
      rewardPoints: _readInt(data, 'reward_points'),
      title: _readString(data, 'title', fallback: 'المستوى'),
      isActive: _readBool(data, 'is_active'),
      status: LevelProgressStatus.notStarted,
    );
  }

  static int _readInt(Map<String, dynamic> data, String key) {
    final value = data[key];
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
