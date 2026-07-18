import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lowgos_app/core/cashe/cache_helper.dart';
import 'package:lowgos_app/core/cashe/cashe_constance.dart';
import 'package:lowgos_app/features/on_boarding/presentation/cubit/on_boarding_state.dart';

class OnBoardingCubit extends Cubit<OnBoardingState> {
  OnBoardingCubit() : super(OnBoardingInitial());

  void changePage(int index) {
    emit(OnBoardingPageChanged(index));
  }

  Future<void> completeOnBoarding() async {
    await CacheHelper.set(key: CacheConstants.onBoardingViewed, value: true);
    emit(OnBoardingCompleted());
  }
}
