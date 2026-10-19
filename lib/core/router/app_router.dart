import 'package:auto_route/auto_route.dart';

import '../../features/connection/view/connection_screen.dart';
import '../../features/dashboard/view/dashboard_screen.dart';
import '../../features/native_lab/device_info/view/device_info_screen.dart';
import '../../features/native_lab/export/view/export_screen.dart';
import '../../features/native_lab/phone_sensor/view/phone_sensor_screen.dart';
import '../../features/native_lab/system_events/view/system_events_screen.dart';
import '../../features/native_lab/view/native_lab_screen.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: ConnectionRoute.page, initial: true),
    AutoRoute(page: DashboardRoute.page),
    AutoRoute(page: NativeLabRoute.page),
    AutoRoute(page: DeviceInfoRoute.page),
    AutoRoute(page: ExportRoute.page),
    AutoRoute(page: PhoneSensorRoute.page),
    AutoRoute(page: SystemEventsRoute.page),
  ];
}
