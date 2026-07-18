import 'package:equatable/equatable.dart';
import 'package:lowgos_app/core/error/failures.dart';
import 'package:lowgos_app/features/home/domain/entities/law_levels_data.dart';

abstract class LawLevelsState extends Equatable {
  const LawLevelsState();

  @override
  List<Object?> get props => [];
}

class LawLevelsInitial extends LawLevelsState {
  const LawLevelsInitial();
}

class LawLevelsLoading extends LawLevelsState {
  const LawLevelsLoading();
}

class LawLevelsSuccess extends LawLevelsState {
  const LawLevelsSuccess({
    required this.data,
    this.openingLevelNumber,
  });

  final LawLevelsData data;
  final int? openingLevelNumber;

  LawLevelsSuccess copyWith({
    LawLevelsData? data,
    int? openingLevelNumber,
    bool clearOpeningLevel = false,
  }) {
    return LawLevelsSuccess(
      data: data ?? this.data,
      openingLevelNumber: clearOpeningLevel
          ? null
          : openingLevelNumber ?? this.openingLevelNumber,
    );
  }

  @override
  List<Object?> get props => [data, openingLevelNumber];
}

class LawLevelsError extends LawLevelsState {
  const LawLevelsError(this.failure);

  final Failure failure;

  @override
  List<Object?> get props => [failure];
}
