import 'package:auto_route/auto_route.dart';

import '../../features/connection/view/connection_screen.dart';
import '../../features/dashboard/view/dashboard_screen.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: ConnectionRoute.page, initial: true),
    AutoRoute(page: DashboardRoute.page),
  ];
}
