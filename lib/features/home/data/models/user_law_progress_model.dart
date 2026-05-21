import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lowgos_app/features/home/domain/entities/law.dart';
import 'package:lowgos_app/features/home/domain/entities/user_law_progress.dart';

class UserLawProgressModel extends UserLawProgress {
  const UserLawProgressModel({
    required super.userId,
    required super.lawId,
    required super.lawName,
    required super.completedLevelsCount,
    required super.completionPercentage,
    required super.currentLevel,
    required super.totalSolvedQuestions,
    required super.correctAnswerQuestionCount,
    required super.totalPoints,
  });

  factory UserLawProgressModel.initial({
    required String userId,
    required Law law,
  }) {
    return UserLawProgressModel(
      userId: userId,
      lawId: law.id,
      lawName: law.name,
      completedLevelsCount: 0,
      completionPercentage: 0,
      currentLevel: 1,
      totalSolvedQuestions: 0,
      correctAnswerQuestionCount: 0,
      totalPoints: 0,
    );
  }

  factory UserLawProgressModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};
    return UserLawProgressModel(
      userId: _readString(data, 'userId'),
      lawId: _readString(data, 'lawId'),
      lawName: _readString(data, 'lawName'),
      completedLevelsCount: _readInt(data, 'completedLevelsCount'),
      completionPercentage: _readInt(
        data,
        'completion_percentage',
        fallbackKey: 'completionPercentage',
      ),
      currentLevel: _readInt(data, 'currentLevel'),
      totalSolvedQuestions: _readInt(data, 'totalSolvedQuestions'),
      correctAnswerQuestionCount: _readInt(
        data,
        'correct_answer_question_count',
      ),
      totalPoints: _readInt(data, 'totalPoints'),
    );
  }

  Map<String, dynamic> toCreateJson() {
    final now = Timestamp.now();
    return {
      'userId': userId,
      'lawId': lawId,
      'lawName': lawName,
      'completedLevelsCount': completedLevelsCount,
      'completionPercentage': completionPercentage,
      'completion_percentage': completionPercentage,
      'currentLevel': currentLevel,
      'totalSolvedQuestions': totalSolvedQuestions,
      'correct_answer_question_count': correctAnswerQuestionCount,
      'totalPoints': totalPoints,
      'startedAt': now,
      'lastPlayedAt': now,
    };
  }

  Map<String, dynamic> toUpdateJson({required int totalLevels}) {
    final percentage = totalLevels == 0
        ? 0
        : ((completedLevelsCount / totalLevels) * 100).round();
    return {
      'completionPercentage': percentage.clamp(0, 100),
      'completion_percentage': percentage.clamp(0, 100),
      'completedLevelsCount': completedLevelsCount,
      'currentLevel': currentLevel,
      'totalPoints': totalPoints,
      'lastPlayedAt': Timestamp.now(),
    };
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

  static String _readString(Map<String, dynamic> data, String key) {
    final value = data[key];
    if (value is String) return value;
    return '';
  }
}
