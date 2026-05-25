import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lowgos_app/features/profile/domain/entities/profile_data.dart';

class ProfileDataModel extends ProfileData {
  const ProfileDataModel({
    required super.userName,
    required super.email,
    required super.totalPoints,
    required super.totalAnsweredQuestions,
    required super.completedLevelsCount,
  });

  factory ProfileDataModel.fromUserDocument({
    required DocumentSnapshot<Map<String, dynamic>> document,
    required String cachedUserName,
    required String cachedEmail,
  }) {
    final data = document.data() ?? {};
    final documentName = _readString(data, 'name');
    final documentEmail = _readString(data, 'email');

    return ProfileDataModel(
      userName: cachedUserName.isNotEmpty ? cachedUserName : documentName,
      email: documentEmail.isNotEmpty ? documentEmail : cachedEmail,
      totalPoints: _readInt(data, 'totalPoints'),
      totalAnsweredQuestions: _readInt(data, 'totalAnswers'),
      completedLevelsCount: _readInt(
        data,
        'count_completed_levels',
        fallbackKeys: const ['completedLevelsCount', 'completed_levels_count'],
      ),
    );
  }

  static int _readInt(
    Map<String, dynamic> data,
    String key, {
    List<String> fallbackKeys = const [],
  }) {
    final keys = [key, ...fallbackKeys];
    for (final itemKey in keys) {
      final value = data[itemKey];
      if (value is int) return value;
      if (value is num) return value.toInt();
    }
    return 0;
  }

  static String _readString(Map<String, dynamic> data, String key) {
    final value = data[key];
    if (value is String) return value;
    return '';
  }
}
