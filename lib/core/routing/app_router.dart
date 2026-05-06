import 'package:go_router/go_router.dart';
import 'package:lowgos_app/core/routing/routes.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: Routes.init,
    routes: [
      /// Init
      // GoRoute(
      //   path: Routes.init,
      //   builder: (context, state) => const AuthVideoContainer(initialIndex: 0),
      // ),

    ],
  );
}
