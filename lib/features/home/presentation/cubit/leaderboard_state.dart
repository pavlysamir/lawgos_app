import 'package:equatable/equatable.dart';
import 'package:lowgos_app/core/error/failures.dart';
import 'package:lowgos_app/features/home/domain/entities/law.dart';
import 'package:lowgos_app/features/home/domain/entities/leaderboard_entry.dart';
import 'package:lowgos_app/features/home/domain/entities/leaderboard_page_data.dart';

abstract class LeaderboardState extends Equatable {
  const LeaderboardState();

  @override
  List<Object?> get props => [];
}

class LeaderboardInitial extends LeaderboardState {
  const LeaderboardInitial();
}

class LeaderboardLoading extends LeaderboardState {
  const LeaderboardLoading();
}

class LeaderboardSuccess extends LeaderboardState {
  const LeaderboardSuccess({
    required this.laws,
    required this.topEntries,
    required this.entries,
    this.currentUserEntry,
    this.cursor,
    this.selectedLawId,
    this.isLoadingMore = false,
  });

  final List<Law> laws;
  final List<LeaderboardEntry> topEntries;
  final List<LeaderboardEntry> entries;
  final LeaderboardEntry? currentUserEntry;
  final LeaderboardCursor? cursor;
  final String? selectedLawId;
  final bool isLoadingMore;

  bool get hasMore => cursor != null;

  LeaderboardSuccess copyWith({
    List<Law>? laws,
    List<LeaderboardEntry>? topEntries,
    List<LeaderboardEntry>? entries,
    LeaderboardEntry? currentUserEntry,
    LeaderboardCursor? cursor,
    String? selectedLawId,
    bool clearSelectedLaw = false,
    bool clearCursor = false,
    bool? isLoadingMore,
  }) {
    return LeaderboardSuccess(
      laws: laws ?? this.laws,
      topEntries: topEntries ?? this.topEntries,
      entries: entries ?? this.entries,
      currentUserEntry: currentUserEntry ?? this.currentUserEntry,
      cursor: clearCursor ? null : cursor ?? this.cursor,
      selectedLawId: clearSelectedLaw
          ? null
          : selectedLawId ?? this.selectedLawId,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [
    laws,
    topEntries,
    entries,
    currentUserEntry,
    cursor,
    selectedLawId,
    isLoadingMore,
  ];
}

class LeaderboardError extends LeaderboardState {
  const LeaderboardError(this.failure);

  final Failure failure;

  @override
  List<Object?> get props => [failure];
}
