import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lowgos_app/core/cashe/cache_helper.dart';
import 'package:lowgos_app/core/cashe/cashe_constance.dart';
import 'package:lowgos_app/core/di/injection.dart';
import 'package:lowgos_app/core/routing/routes.dart';
import 'package:lowgos_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:lowgos_app/features/auth/presentation/pages/login_page.dart';
import 'package:lowgos_app/features/auth/presentation/pages/sign_up_page.dart';
import 'package:lowgos_app/features/home/domain/entities/law.dart';
import 'package:lowgos_app/features/home/presentation/cubit/home_cubit.dart';
import 'package:lowgos_app/features/home/presentation/cubit/law_levels_cubit.dart';
import 'package:lowgos_app/features/home/presentation/pages/home_page.dart';
import 'package:lowgos_app/features/home/presentation/pages/law_levels_page.dart';
import 'package:lowgos_app/features/on_boarding/presentation/pages/on_boarding_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: _initialLocation,
    routes: [
      GoRoute(
        path: Routes.onBoarding,
        builder: (context, state) => const OnBoardingPage(),
      ),
      GoRoute(
        path: Routes.login,
        builder: (context, state) => BlocProvider(
          create: (context) => getIt<AuthCubit>(),
          child: const LoginPage(),
        ),
      ),
      GoRoute(
        path: Routes.signUp,
        builder: (context, state) => BlocProvider(
          create: (context) => getIt<AuthCubit>(),
          child: const SignUpPage(),
        ),
      ),
      GoRoute(
        path: Routes.home,
        builder: (context, state) => BlocProvider(
          create: (context) => getIt<HomeCubit>(),
          child: const HomePage(),
        ),
      ),
      GoRoute(
        path: Routes.lawLevels,
        builder: (context, state) {
          final law = state.extra as Law?;
          if (law == null) {
            return const Scaffold(
              body: Center(child: Text('القانون غير موجود')),
            );
          }

          return BlocProvider(
            create: (context) => getIt<LawLevelsCubit>(),
            child: LawLevelsPage(law: law),
          );
        },
      ),
    ],
  );

  static String get _initialLocation {
    final viewedOnBoarding =
        CacheHelper.getBool(key: CacheConstants.onBoardingViewed) == true;
    final hasCachedUser =
        CacheHelper.getString(key: CacheConstants.userId)?.isNotEmpty ?? false;

    if (!viewedOnBoarding) return Routes.onBoarding;
    if (hasCachedUser) return Routes.home;
    return Routes.login;
  }
}
