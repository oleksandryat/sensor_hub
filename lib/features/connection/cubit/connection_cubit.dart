import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/connection_manager.dart';
import '../../../domain/credentials_vault.dart';
import '../../../domain/connection_status.dart';
import '../../../domain/mqtt_broker_settings.dart';
import '../../../domain/stored_credentials.dart';

part 'connection_cubit.freezed.dart';
part 'connection_state.dart';

class ConnectionCubit extends Cubit<ConnectionCubitState> {
  final ConnectionManager _manager;
  final String Function() _clientId;
  final CredentialsVault _vault;

  late final StreamSubscription<ConnectionStatus> _sub;

  ConnectionCubit(this._manager, this._clientId, this._vault)
    : super(const ConnectionCubitState()) {
    _sub = _manager.status.listen(_onStatus);
  }

  Future<void> loadSaved() async {
    try {
      final saved = await _vault.load();
      if (saved != null) emit(state.copyWith(saved: saved));
    } on VaultException catch (e) {
      emit(state.copyWith(vaultError: e.message));
    }
  }

  Future<void> _onStatus(ConnectionStatus status) async {
    emit(state.copyWith(status: status, vaultError: null));
    final pending = state.pending;
    if (status != ConnectionStatus.connected || pending == null) return;
    emit(state.copyWith(pending: null));
    try {
      if (pending.remember) {
        await _vault.save(pending.credentials);
        emit(state.copyWith(saved: pending.credentials));
      } else {
        await _vault.clear();
        emit(state.copyWith(saved: null));
      }
    } on VaultException catch (e) {
      emit(state.copyWith(vaultError: e.message));
    }
  }

  Future<void> connect({
    required String host,
    required int port,
    required String username,
    required String password,
    bool remember = false,
  }) {
    emit(
      state.copyWith(
        pending: (
          credentials: StoredCredentials(
            username: username,
            password: password,
          ),
          remember: remember,
        ),
      ),
    );
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
