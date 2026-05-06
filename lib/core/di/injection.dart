import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:lowgos_app/features/on_boarding/presentation/cubit/on_boarding_cubit.dart';

final getIt = GetIt.instance;

void setupInjection() {
  getIt.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );

  // Features
  getIt.registerFactory<OnBoardingCubit>(() => OnBoardingCubit());
}
