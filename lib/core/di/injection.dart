import 'dart:math';

import 'package:get_it/get_it.dart';

import '../../data/device_repository_impl.dart';
import '../../data/mqtt/mqtt5_client_gateway.dart';
import '../../domain/backoff_policy.dart';
import '../../domain/command_dispatcher.dart';
import '../../domain/connection_manager.dart';
import '../../domain/device_repository.dart';
import '../../domain/mqtt_gateway.dart';
import '../../domain/mqtt_topics.dart';
import '../../features/connection/cubit/connection_cubit.dart';
import '../router/app_router.dart';

final getIt = GetIt.instance;

const _topicPrefix = 'sensorhub-demo/';
const _staleThreshold = Duration(seconds: 15);

String _newClientId() =>
    'sensorhub-${Random().nextInt(1 << 32).toRadixString(16)}';

void configureDependencies() {
  getIt
    ..registerSingleton<AppRouter>(AppRouter())
    ..registerSingleton<MqttTopics>(MqttTopics(_topicPrefix))
    ..registerLazySingleton<MqttGateway>(Mqtt5ClientGateway.new)
    ..registerLazySingleton<BackoffPolicy>(
      () => FullJitterBackoffPolicy(random: Random()),
    )
    ..registerLazySingleton<ConnectionManager>(
      () => ConnectionManager(getIt(), getIt()),
    )
    ..registerLazySingleton<CommandDispatcher>(
      () => MqttCommandDispatcher(getIt(), getIt()),
    )
    ..registerFactory<ConnectionCubit>(
      () => ConnectionCubit(getIt(), _newClientId),
    )
    ..registerLazySingleton<DeviceRepository>(
      () => DeviceRepositoryImpl(
        gateway: getIt(),
        connection: getIt(),
        topics: getIt(),
        now: DateTime.now,
        staleThreshold: _staleThreshold,
      ),
    );
}
