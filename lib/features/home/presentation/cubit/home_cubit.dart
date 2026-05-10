import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lowgos_app/features/home/domain/usecases/get_home_data.dart';
import 'package:lowgos_app/features/home/domain/usecases/start_law.dart';
import 'package:lowgos_app/features/home/presentation/cubit/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({
    required GetHomeData getHomeData,
    required StartLaw startLaw,
  }) : _getHomeData = getHomeData,
       _startLaw = startLaw,
       super(const HomeInitial());

  final GetHomeData _getHomeData;
  final StartLaw _startLaw;

  Future<void> loadHome() async {
    emit(const HomeLoading());
    final result = await _getHomeData();
    result.fold(
      (failure) => emit(HomeError(failure)),
      (data) => emit(HomeSuccess(data: data)),
    );
  }

  void changeLaw(int index) {
    final current = state;
    if (current is! HomeSuccess) return;
    emit(current.copyWith(selectedLawIndex: index));
  }

  void changeTab(int index) {
    final current = state;
    if (current is! HomeSuccess) return;
    emit(current.copyWith(selectedTabIndex: index));
  }

  Future<void> startSelectedLaw() async {
    final current = state;
    if (current is! HomeSuccess || current.data.laws.isEmpty) return;

    final law = current.data.laws[current.selectedLawIndex];
    emit(current.copyWith(isStartingLaw: true));

    final result = await _startLaw(law.id);
    result.fold(
      (failure) => emit(HomeError(failure)),
      (_) => loadHome(),
    );
  }
}
