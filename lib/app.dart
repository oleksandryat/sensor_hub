import 'package:flutter/material.dart';

import 'core/di/injection.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

class SensorHubApp extends StatelessWidget {
  const SensorHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'SensorHub',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      routerConfig: getIt<AppRouter>().config(),
    );
  }
}
