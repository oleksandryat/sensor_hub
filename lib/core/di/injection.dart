import 'dart:math';

import 'package:get_it/get_it.dart';
import 'package:sensorhub_native/sensorhub_native.dart';

import '../../data/device_repository_impl.dart';
import '../../data/mqtt/mqtt5_client_gateway.dart';
import '../../domain/backoff_policy.dart';
import '../../domain/command_dispatcher.dart';
import '../../domain/connection_manager.dart';
import '../../domain/device_repository.dart';
import '../../domain/mqtt_gateway.dart';
import '../../domain/mqtt_topics.dart';
import '../../domain/phone_telemetry_publisher.dart';
import '../../features/connection/cubit/connection_cubit.dart';
import '../../features/dashboard/cubit/dashboard_cubit.dart';
import '../../features/native_lab/device_info/cubit/device_info_cubit.dart';
import '../../features/native_lab/export/cubit/export_cubit.dart';
import '../../features/native_lab/phone_sensor/cubit/phone_sensor_cubit.dart';
import '../router/app_router.dart';

final getIt = GetIt.instance;

const _topicPrefix = 'sensorhub-demo/';
const _staleThreshold = Duration(seconds: 15);
const _phonePublishInterval = Duration(seconds: 1);

String _newClientId() =>
    'sensorhub-${Random().nextInt(1 << 32).toRadixString(16)}';

String _newPhoneId() => 'phone-${Random().nextInt(1 << 16).toRadixString(16)}';

String _newCmdId() => Random().nextInt(1 << 32).toRadixString(16);

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
    ..registerLazySingleton<SensorhubNative>(SensorhubNative.new)
    ..registerFactory<DeviceInfoCubit>(() => DeviceInfoCubit(getIt()))
    ..registerFactory<ExportCubit>(() => ExportCubit(getIt(), getIt()))
    ..registerLazySingleton<PhoneTelemetryPublisher>(
      () => PhoneTelemetryPublisher(
        deviceId: _newPhoneId(),
        gateway: getIt(),
        connection: getIt(),
        topics: getIt(),
        now: DateTime.now,
        interval: _phonePublishInterval,
      ),
    )
    ..registerFactory<PhoneSensorCubit>(
      () => PhoneSensorCubit(getIt(), getIt(), getIt(), DateTime.now),
    )
    ..registerFactory<DashboardCubit>(
      () => DashboardCubit(getIt(), getIt(), getIt(), _newCmdId),
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
