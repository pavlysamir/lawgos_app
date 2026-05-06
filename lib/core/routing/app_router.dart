import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lowgos_app/core/cashe/cache_helper.dart';
import 'package:lowgos_app/core/cashe/cashe_constance.dart';
import 'package:lowgos_app/core/routing/routes.dart';
import 'package:lowgos_app/features/on_boarding/presentation/pages/on_boarding_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: CacheHelper.getBool(key: CacheConstants.onBoardingViewed) == true ? Routes.login : Routes.onBoarding,
    routes: [
      GoRoute(
        path: Routes.onBoarding,
        builder: (context, state) => const OnBoardingPage(),
      ),
      GoRoute(
        path: Routes.login,
        builder: (context, state) => const Scaffold(body: Center(child: Text("Login"))),
      ),
    ],
  );
}
