part of 'dashboard_cubit.dart';

enum DashboardStatus { loading, loaded, error }

@freezed
abstract class DashboardState with _$DashboardState {
  const DashboardState._();

  const factory DashboardState({
    @Default(DashboardStatus.loading) DashboardStatus status,
    @Default([]) List<Device> devices,
    @Default(ConnectionStatus.disconnected) ConnectionStatus connection,
  }) = _DashboardState;

  bool get isOffline => connection != ConnectionStatus.connected;
}
