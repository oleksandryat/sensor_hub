import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/connection_manager.dart';
import '../../../domain/connection_status.dart';
import '../../../domain/mqtt_broker_settings.dart';

part 'connection_cubit.freezed.dart';
part 'connection_state.dart';

class ConnectionCubit extends Cubit<ConnectionCubitState> {
  final ConnectionManager _manager;
  final String Function() _clientId;

  late final StreamSubscription<ConnectionStatus> _sub;

  ConnectionCubit(this._manager, this._clientId)
    : super(const ConnectionCubitState()) {
    _sub = _manager.status.listen(
      (status) => emit(state.copyWith(status: status)),
    );
  }

  Future<void> connect({
    required String host,
    required int port,
    required String username,
    required String password,
  }) {
    return _manager.connect(
      MqttBrokerSettings(
        host: host,
        port: port,
        clientId: _clientId(),
        username: username,
        password: password,
      ),
    );
  }

  Future<void> disconnect() => _manager.disconnect();

  @override
  Future<void> close() {
    _sub.cancel();
    return super.close();
  }
}
