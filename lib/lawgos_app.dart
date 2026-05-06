import 'package:flutter/material.dart';
import 'package:lowgos_app/core/routing/app_router.dart';

class LawgosApp extends StatelessWidget {
  const LawgosApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.router,
    );
  }
}
