part of 'dashboard_cubit.dart';

enum DashboardStatus { loading, loaded, error }

/// Outcome of the last command; `result.cmdId` makes every outcome distinct.
typedef CommandFeedback = ({String deviceId, CommandResult result});

@freezed
abstract class DashboardState with _$DashboardState {
  const DashboardState._();

  const factory DashboardState({
    @Default(DashboardStatus.loading) DashboardStatus status,
    @Default([]) List<Device> devices,
    @Default(ConnectionStatus.disconnected) ConnectionStatus connection,
    @Default({}) Set<String> sending,
    CommandFeedback? feedback,
  }) = _DashboardState;

  bool get isOffline => connection != ConnectionStatus.connected;
}
