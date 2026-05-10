import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lowgos_app/core/cashe/cache_helper.dart';
import 'package:lowgos_app/core/cashe/cashe_constance.dart';
import 'package:lowgos_app/core/di/injection.dart';
import 'package:lowgos_app/core/routing/routes.dart';
import 'package:lowgos_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:lowgos_app/features/auth/presentation/pages/login_page.dart';
import 'package:lowgos_app/features/auth/presentation/pages/sign_up_page.dart';
import 'package:lowgos_app/features/on_boarding/presentation/pages/on_boarding_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation:
        CacheHelper.getBool(key: CacheConstants.onBoardingViewed) == true
        ? Routes.login
        : Routes.onBoarding,
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
    ],
  );
}
