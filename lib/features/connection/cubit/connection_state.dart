part of 'connection_cubit.dart';

@freezed
abstract class ConnectionCubitState with _$ConnectionCubitState {
  const factory ConnectionCubitState({
    @Default(ConnectionStatus.disconnected) ConnectionStatus status,
  }) = _ConnectionCubitState;
}
