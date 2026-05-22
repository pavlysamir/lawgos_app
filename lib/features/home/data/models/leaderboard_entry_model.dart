import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lowgos_app/features/home/domain/entities/leaderboard_entry.dart';
import 'package:lowgos_app/features/home/domain/entities/leaderboard_page_data.dart';

class LeaderboardEntryModel extends LeaderboardEntry {
  const LeaderboardEntryModel({
    required super.userId,
    required super.displayName,
    required super.points,
    required super.rank,
    super.photoUrl,
    super.lawId,
    super.lawName,
    super.isCurrentUser,
  });

  factory LeaderboardEntryModel.fromFirestore({
    required DocumentSnapshot<Map<String, dynamic>> doc,
    required int rank,
    required String currentUserId,
  }) {
    final data = doc.data() ?? {};
    final userId = _readString(data, 'userId', fallback: doc.id);
    return LeaderboardEntryModel(
      userId: userId,
      displayName: _readString(data, 'displayName', fallback: 'مستخدم'),
      photoUrl: _readNullableString(data, 'photoUrl'),
      lawId: _readNullableString(data, 'lawId'),
      lawName: _readNullableString(data, 'lawName'),
      points: _readInt(data, 'points'),
      rank: rank,
      isCurrentUser: userId == currentUserId,
    );
  }

  LeaderboardCursor get cursor => LeaderboardCursor(
    points: points,
    displayName: displayName,
    userId: userId,
    rank: rank,
  );

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
    if (value is String && value.trim().isNotEmpty) return value.trim();
    return fallback;
  }

  static String? _readNullableString(Map<String, dynamic> data, String key) {
    final value = data[key];
    if (value is String && value.trim().isNotEmpty) return value.trim();
    return null;
  }
}
