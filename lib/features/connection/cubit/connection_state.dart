part of 'connection_cubit.dart';

@freezed
abstract class ConnectionCubitState with _$ConnectionCubitState {
  const factory ConnectionCubitState({
    @Default(ConnectionStatus.disconnected) ConnectionStatus status,
    StoredCredentials? saved,
    String? vaultError,

    /// Attempt in flight; persisted only once it succeeds.
    ({StoredCredentials credentials, bool remember})? pending,
  }) = _ConnectionCubitState;
}
