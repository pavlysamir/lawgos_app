import 'package:equatable/equatable.dart';
import 'package:lowgos_app/features/home/domain/entities/leaderboard_entry.dart';

class LeaderboardPageData extends Equatable {
  const LeaderboardPageData({
    required this.topEntries,
    required this.entries,
    this.currentUserEntry,
    this.nextCursor,
  });

  final List<LeaderboardEntry> topEntries;
  final List<LeaderboardEntry> entries;
  final LeaderboardEntry? currentUserEntry;
  final LeaderboardCursor? nextCursor;

  bool get hasMore => nextCursor != null;

  @override
  List<Object?> get props => [
    topEntries,
    entries,
    currentUserEntry,
    nextCursor,
  ];
}

class LeaderboardCursor extends Equatable {
  const LeaderboardCursor({
    required this.points,
    required this.displayName,
    required this.userId,
    required this.rank,
  });

  final int points;
  final String displayName;
  final String userId;
  final int rank;

  @override
  List<Object?> get props => [points, displayName, userId, rank];
}
