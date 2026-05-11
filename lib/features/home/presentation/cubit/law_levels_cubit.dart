import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lowgos_app/features/home/domain/entities/law.dart';
import 'package:lowgos_app/features/home/domain/entities/law_level.dart';
import 'package:lowgos_app/features/home/domain/usecases/enter_level.dart';
import 'package:lowgos_app/features/home/domain/usecases/get_law_levels.dart';
import 'package:lowgos_app/features/home/presentation/cubit/law_levels_state.dart';

class LawLevelsCubit extends Cubit<LawLevelsState> {
  LawLevelsCubit({
    required GetLawLevels getLawLevels,
    required EnterLevel enterLevel,
  }) : _getLawLevels = getLawLevels,
       _enterLevel = enterLevel,
       super(const LawLevelsInitial());

  final GetLawLevels _getLawLevels;
  final EnterLevel _enterLevel;
  Law? _law;

  Future<void> loadLevels(Law law) async {
    _law = law;
    emit(const LawLevelsLoading());
    final result = await _getLawLevels(law);
    result.fold(
      (failure) => emit(LawLevelsError(failure)),
      (data) => emit(LawLevelsSuccess(data: data)),
    );
  }

  Future<void> enterLevel(LawLevel level) async {
    final current = state;
    if (current is! LawLevelsSuccess) return;

    emit(current.copyWith(openingLevelNumber: level.levelNumber));
    final result = await _enterLevel(level);

    result.fold(
      (failure) => emit(LawLevelsError(failure)),
      (_) async {
        final law = _law;
        if (law == null) {
          emit(current.copyWith(clearOpeningLevel: true));
          return;
        }
        await loadLevels(law);
      },
    );
  }
}
