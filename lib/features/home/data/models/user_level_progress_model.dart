import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lowgos_app/core/helpers/enums.dart';
import 'package:lowgos_app/features/home/domain/entities/law_level.dart';
import 'package:lowgos_app/features/home/domain/entities/user_level_progress.dart';

class UserLevelProgressModel extends UserLevelProgress {
  const UserLevelProgressModel({
    required super.userId,
    required super.lawId,
    required super.levelNumber,
    required super.status,
    required super.solvedQuestionsCount,
    required super.correctAnswersCount,
    required super.earnedPoints,
  });

  factory UserLevelProgressModel.initial({
    required String userId,
    required LawLevel level,
  }) {
    return UserLevelProgressModel(
      userId: userId,
      lawId: level.lawId,
      levelNumber: level.levelNumber,
      status: LevelProgressStatus.notStarted,
      solvedQuestionsCount: 0,
      correctAnswersCount: 0,
      earnedPoints: 0,
    );
  }

  factory UserLevelProgressModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};
    return UserLevelProgressModel(
      userId: _readString(data, 'userId'),
      lawId: _readString(data, 'lawId'),
      levelNumber: _readInt(data, 'levelNumber'),
      status: LevelProgressStatus.fromValue(_readString(data, 'status')),
      solvedQuestionsCount: _readInt(data, 'solvedQuestionsCount'),
      correctAnswersCount: _readInt(data, 'correctAnswersCount'),
      earnedPoints: _readInt(data, 'earnedPoints'),
    );
  }

  Map<String, dynamic> toCreateJson() {
    return {
      'userId': userId,
      'lawId': lawId,
      'levelNumber': levelNumber,
      'status': status.value,
      'solvedQuestionsCount': solvedQuestionsCount,
      'correctAnswersCount': correctAnswersCount,
      'earnedPoints': earnedPoints,
      'startedAt': null,
      'completedAt': null,
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
