import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:lowgos_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:lowgos_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:lowgos_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:lowgos_app/features/auth/domain/usecases/login_with_email.dart';
import 'package:lowgos_app/features/auth/domain/usecases/sign_in_with_google.dart';
import 'package:lowgos_app/features/auth/domain/usecases/sign_up_with_email.dart';
import 'package:lowgos_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:lowgos_app/features/on_boarding/presentation/cubit/on_boarding_cubit.dart';

final getIt = GetIt.instance;

void setupInjection() {
  getIt.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );

  // Features
  getIt.registerFactory<OnBoardingCubit>(() => OnBoardingCubit());

  // Auth
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(firebaseAuth: getIt(), firestore: getIt()),
  );
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: getIt()),
  );
  getIt.registerLazySingleton(() => LoginWithEmail(getIt()));
  getIt.registerLazySingleton(() => SignUpWithEmail(getIt()));
  getIt.registerLazySingleton(() => SignInWithGoogle(getIt()));
  getIt.registerFactory(
    () => AuthCubit(
      loginWithEmail: getIt(),
      signUpWithEmail: getIt(),
      signInWithGoogle: getIt(),
    ),
  );
}
