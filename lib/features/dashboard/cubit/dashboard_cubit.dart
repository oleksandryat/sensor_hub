import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/command.dart';
import '../../../domain/command_dispatcher.dart';
import '../../../domain/command_result.dart';
import '../../../domain/connection_manager.dart';
import '../../../domain/connection_status.dart';
import '../../../domain/device.dart';
import '../../../domain/device_repository.dart';

part 'dashboard_cubit.freezed.dart';
part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final DeviceRepository _devices;
  final ConnectionManager _connection;
  final CommandDispatcher _commands;
  final String Function() _newCmdId;

  StreamSubscription<List<Device>>? _devicesSub;
  StreamSubscription<ConnectionStatus>? _connectionSub;

  DashboardCubit(
    this._devices,
    this._connection,
    this._commands,
    this._newCmdId,
  ) : super(
        DashboardState(
          connection: _connection.currentStatus,
          status: _connection.currentStatus == ConnectionStatus.connected
              ? DashboardStatus.loaded
              : DashboardStatus.loading,
        ),
      );

  void start() {
    _connectionSub ??= _connection.status.listen(_onConnection);
    _devicesSub ??= _devices.devices.listen(
      (devices) => emit(
        state.copyWith(status: DashboardStatus.loaded, devices: devices),
      ),
      onError: (_) => emit(state.copyWith(status: DashboardStatus.error)),
    );
    _devices.start();
  }

  void _onConnection(ConnectionStatus connection) {
    final status = switch (connection) {
      ConnectionStatus.error when state.devices.isEmpty =>
        DashboardStatus.error,
      ConnectionStatus.connected => DashboardStatus.loaded,
      _ when state.status == DashboardStatus.error => DashboardStatus.loading,
      _ => state.status,
    };
    emit(state.copyWith(connection: connection, status: status));
  }

  Future<void> reboot(String deviceId) =>
      _send(deviceId, Command.reboot(cmdId: _newCmdId()));

  Future<void> setInterval(String deviceId, int seconds) => _send(
    deviceId,
    Command.setInterval(cmdId: _newCmdId(), seconds: seconds),
  );

  Future<void> _send(String deviceId, Command command) async {
    if (state.isOffline || state.sending.contains(deviceId)) return;
    emit(state.copyWith(sending: {...state.sending, deviceId}));
    CommandResult result;
    try {
      result = await _commands.send(command, deviceId: deviceId);
    } catch (e) {
      result = CommandResult.failed(cmdId: command.cmdId, error: '$e');
    }
    if (isClosed) return;
    emit(
      state.copyWith(
        sending: {...state.sending}..remove(deviceId),
        feedback: (deviceId: deviceId, result: result),
      ),
    );
  }

  @override
  Future<void> close() {
    _devicesSub?.cancel();
    _connectionSub?.cancel();
    return super.close();
  }
}
