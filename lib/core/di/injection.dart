import 'dart:math';

import 'package:get_it/get_it.dart';
import 'package:sensorhub_native/sensorhub_native.dart';
import 'package:sensorhub_stats/sensorhub_stats.dart';

import '../../data/device_repository_impl.dart';
import '../../data/mqtt/mqtt5_client_gateway.dart';
import '../../data/native_anomaly_detector.dart';
import '../../data/native_credentials_vault.dart';
import '../../domain/anomaly_detector.dart';
import '../../domain/backoff_policy.dart';
import '../../domain/command_dispatcher.dart';
import '../../domain/connection_manager.dart';
import '../../domain/credentials_vault.dart';
import '../../domain/device_repository.dart';
import '../../domain/mqtt_gateway.dart';
import '../../domain/mqtt_topics.dart';
import '../../domain/phone_telemetry_publisher.dart';
import '../../features/connection/cubit/connection_cubit.dart';
import '../../features/dashboard/cubit/dashboard_cubit.dart';
import '../../features/native_lab/device_info/cubit/device_info_cubit.dart';
import '../../features/native_lab/export/cubit/export_cubit.dart';
import '../../features/native_lab/phone_sensor/cubit/phone_sensor_cubit.dart';
import '../../features/native_lab/system_events/cubit/system_events_cubit.dart';
import '../router/app_router.dart';

final getIt = GetIt.instance;

const _topicPrefix = 'sensorhub-demo/';
const _staleThreshold = Duration(seconds: 15);
const _phonePublishInterval = Duration(seconds: 1);
// One second of samples at the accelerometer's 50 Hz.
const _anomalyWindow = 50;
const _anomalyZThreshold = 3.5;

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
      () => ConnectionCubit(getIt(), _newClientId, getIt()),
    )
    ..registerLazySingleton<SensorhubNative>(SensorhubNative.new)
    ..registerLazySingleton<CredentialsVault>(
      () => NativeCredentialsVault(SecureVault()),
    )
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
      () => PhoneSensorCubit(getIt(), getIt(), getIt(), getIt(), DateTime.now),
    )
    // Each screen gets its own detector, so history is not shared.
    ..registerFactory<AnomalyDetector>(
      () => NativeAnomalyDetector(
        StatsDetector(window: _anomalyWindow, zThreshold: _anomalyZThreshold),
      ),
    )
    ..registerFactory<SystemEventsCubit>(() => SystemEventsCubit(getIt()))
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
