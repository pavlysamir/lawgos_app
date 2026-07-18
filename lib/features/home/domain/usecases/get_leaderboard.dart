import 'package:dartz/dartz.dart';
import 'package:lowgos_app/core/error/failures.dart';
import 'package:lowgos_app/features/home/domain/entities/leaderboard_page_data.dart';
import 'package:lowgos_app/features/home/domain/repositories/home_repository.dart';

class GetLeaderboard {
  const GetLeaderboard(this.repository);

  final HomeRepository repository;

  Future<Either<Failure, LeaderboardPageData>> call({
    String? lawId,
    LeaderboardCursor? cursor,
    int limit = 20,
  }) {
    return repository.getLeaderboard(
      lawId: lawId,
      cursor: cursor,
      limit: limit,
    );
  }
}
