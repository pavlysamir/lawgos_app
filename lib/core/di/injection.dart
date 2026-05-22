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
import 'package:lowgos_app/features/home/data/datasources/home_local_data_source.dart';
import 'package:lowgos_app/features/home/data/datasources/home_remote_data_source.dart';
import 'package:lowgos_app/features/home/data/repositories/home_repository_impl.dart';
import 'package:lowgos_app/features/home/domain/repositories/home_repository.dart';
import 'package:lowgos_app/features/home/domain/usecases/get_home_data.dart';
import 'package:lowgos_app/features/home/domain/usecases/get_exam_flow_data.dart';
import 'package:lowgos_app/features/home/domain/usecases/get_leaderboard.dart';
import 'package:lowgos_app/features/home/domain/usecases/get_law_levels.dart';
import 'package:lowgos_app/features/home/domain/usecases/get_material_question.dart';
import 'package:lowgos_app/features/home/domain/usecases/enter_level.dart';
import 'package:lowgos_app/features/home/domain/usecases/start_or_resume_exam_session.dart';
import 'package:lowgos_app/features/home/domain/usecases/start_law.dart';
import 'package:lowgos_app/features/home/domain/usecases/submit_question_answer.dart';
import 'package:lowgos_app/features/home/domain/usecases/update_level_progress.dart';
import 'package:lowgos_app/features/home/domain/usecases/update_law_progress.dart';
import 'package:lowgos_app/features/home/presentation/cubit/exam_flow_cubit.dart';
import 'package:lowgos_app/features/home/presentation/cubit/home_cubit.dart';
import 'package:lowgos_app/features/home/presentation/cubit/leaderboard_cubit.dart';
import 'package:lowgos_app/features/home/presentation/cubit/law_levels_cubit.dart';
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

  // Home
  getIt.registerLazySingleton<HomeLocalDataSource>(
    () => HomeLocalDataSourceImpl(),
  );
  getIt.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(firestore: getIt(), firebaseAuth: getIt()),
  );
  getIt.registerLazySingleton<HomeRepository>(
    () =>
        HomeRepositoryImpl(localDataSource: getIt(), remoteDataSource: getIt()),
  );
  getIt.registerLazySingleton(() => GetHomeData(getIt()));
  getIt.registerLazySingleton(() => StartLaw(getIt()));
  getIt.registerLazySingleton(() => UpdateLawProgress(getIt()));
  getIt.registerLazySingleton(() => GetLawLevels(getIt()));
  getIt.registerLazySingleton(() => GetLeaderboard(getIt()));
  getIt.registerLazySingleton(() => EnterLevel(getIt()));
  getIt.registerLazySingleton(() => UpdateLevelProgress(getIt()));
  getIt.registerLazySingleton(() => GetExamFlowData(getIt()));
  getIt.registerLazySingleton(() => StartOrResumeExamSession(getIt()));
  getIt.registerLazySingleton(() => GetMaterialQuestions(getIt()));
  getIt.registerLazySingleton(() => SubmitQuestionAnswer(getIt()));
  getIt.registerFactory(
    () => HomeCubit(getHomeData: getIt(), startLaw: getIt()),
  );
  getIt.registerFactory(() => LeaderboardCubit(getLeaderboard: getIt()));
  getIt.registerFactory(
    () => LawLevelsCubit(getLawLevels: getIt(), enterLevel: getIt()),
  );
  getIt.registerFactory(
    () => ExamFlowCubit(
      getExamFlowData: getIt(),
      startOrResumeExamSession: getIt(),
      getMaterialQuestions: getIt(),
      submitQuestionAnswer: getIt(),
    ),
  );
}
