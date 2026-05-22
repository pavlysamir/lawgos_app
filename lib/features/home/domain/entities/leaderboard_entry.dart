import 'package:equatable/equatable.dart';

class LeaderboardEntry extends Equatable {
  const LeaderboardEntry({
    required this.userId,
    required this.displayName,
    required this.points,
    required this.rank,
    this.photoUrl,
    this.lawId,
    this.lawName,
    this.isCurrentUser = false,
  });

  final String userId;
  final String displayName;
  final String? photoUrl;
  final String? lawId;
  final String? lawName;
  final int points;
  final int rank;
  final bool isCurrentUser;

  LeaderboardEntry copyWith({
    int? rank,
    bool? isCurrentUser,
  }) {
    return LeaderboardEntry(
      userId: userId,
      displayName: displayName,
      photoUrl: photoUrl,
      lawId: lawId,
      lawName: lawName,
      points: points,
      rank: rank ?? this.rank,
      isCurrentUser: isCurrentUser ?? this.isCurrentUser,
    );
  }

  @override
  List<Object?> get props => [
    userId,
    displayName,
    photoUrl,
    lawId,
    lawName,
    points,
    rank,
    isCurrentUser,
  ];
}
