import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lowgos_app/features/home/domain/entities/law.dart';
import 'package:lowgos_app/features/home/domain/usecases/get_leaderboard.dart';
import 'package:lowgos_app/features/home/presentation/cubit/leaderboard_state.dart';

class LeaderboardCubit extends Cubit<LeaderboardState> {
  LeaderboardCubit({required GetLeaderboard getLeaderboard})
    : _getLeaderboard = getLeaderboard,
      super(const LeaderboardInitial());

  final GetLeaderboard _getLeaderboard;

  static const _pageSize = 20;

  Future<void> load({required List<Law> laws, String? lawId}) async {
    emit(const LeaderboardLoading());
    final result = await _getLeaderboard(lawId: lawId, limit: _pageSize);
    result.fold(
      (failure) => emit(LeaderboardError(failure)),
      (data) => emit(
        LeaderboardSuccess(
          laws: laws,
          topEntries: data.topEntries,
          entries: data.entries,
          currentUserEntry: data.currentUserEntry,
          cursor: data.nextCursor,
          selectedLawId: lawId,
        ),
      ),
    );
  }

  Future<void> changeLaw(String? lawId) async {
    final current = state;
    if (current is! LeaderboardSuccess || current.selectedLawId == lawId) {
      return;
    }
    await load(laws: current.laws, lawId: lawId);
  }

  Future<void> loadMore() async {
    final current = state;
    if (current is! LeaderboardSuccess ||
        current.isLoadingMore ||
        !current.hasMore) {
      return;
    }

    emit(current.copyWith(isLoadingMore: true));
    final result = await _getLeaderboard(
      lawId: current.selectedLawId,
      cursor: current.cursor,
      limit: _pageSize,
    );
    result.fold(
      (failure) => emit(LeaderboardError(failure)),
      (data) => emit(
        current.copyWith(
          entries: [...current.entries, ...data.entries],
          currentUserEntry: data.currentUserEntry,
          cursor: data.nextCursor,
          clearCursor: data.nextCursor == null,
          isLoadingMore: false,
        ),
      ),
    );
  }
}
