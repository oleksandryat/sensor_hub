import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sensor_hub/domain/command_result.dart';
import 'package:sensor_hub/domain/connection_status.dart';
import 'package:sensor_hub/domain/device.dart';
import 'package:sensor_hub/domain/telemetry.dart';
import 'package:sensor_hub/features/dashboard/cubit/dashboard_cubit.dart';
import 'package:sensor_hub/features/dashboard/view/dashboard_screen.dart';

import '../../helpers/helpers.dart';

void main() {
  late MockDashboardCubit cubit;

  setUp(() {
    cubit = MockDashboardCubit();
    when(() => cubit.reboot(any())).thenAnswer((_) async {});
    when(() => cubit.setInterval(any(), any())).thenAnswer((_) async {});
  });

  Future<void> pump(WidgetTester tester, DashboardState state) =>
      tester.pumpView<DashboardCubit, DashboardState>(
        const DashboardView(),
        cubit: cubit,
        state: state,
      );

  final device = Device(
    id: 'a',
    online: true,
    isStale: false,
    lastSeen: DateTime(2026, 1, 1, 12, 30, 45),
    last: Telemetry(ts: DateTime(2026), value: 21.54, unit: '°C'),
  );

  testWidgets('loading shows a progress indicator', (tester) async {
    await pump(tester, const DashboardState());
    expect(find.byKey(const Key('loading_state')), findsOneWidget);
  });

  testWidgets('error shows the error state', (tester) async {
    await pump(tester, const DashboardState(status: DashboardStatus.error));
    expect(find.byKey(const Key('error_state')), findsOneWidget);
  });

  testWidgets('empty list shows the empty state', (tester) async {
    await pump(
      tester,
      const DashboardState(
        status: DashboardStatus.loaded,
        connection: ConnectionStatus.connected,
      ),
    );
    expect(find.byKey(const Key('empty_state')), findsOneWidget);
  });

  testWidgets('device tile shows value, unit and last seen', (tester) async {
    await pump(
      tester,
      DashboardState(
        status: DashboardStatus.loaded,
        devices: [device],
        connection: ConnectionStatus.connected,
      ),
    );
    expect(find.text('a'), findsOneWidget);
    expect(find.text('21.5 °C'), findsOneWidget);
    expect(find.text('Last seen 12:30:45'), findsOneWidget);
    expect(find.byKey(const Key('stale_badge')), findsNothing);
    expect(find.byKey(const Key('offline_banner')), findsNothing);
  });

  testWidgets('stale device shows the badge', (tester) async {
    await pump(
      tester,
      DashboardState(
        status: DashboardStatus.loaded,
        devices: [device.copyWith(isStale: true)],
        connection: ConnectionStatus.connected,
      ),
    );
    expect(find.byKey(const Key('stale_badge')), findsOneWidget);
  });

  testWidgets('offline shows the banner and keeps devices', (tester) async {
    await pump(
      tester,
      DashboardState(
        status: DashboardStatus.loaded,
        devices: [device],
        connection: ConnectionStatus.reconnecting,
      ),
    );
    expect(find.byKey(const Key('offline_banner')), findsOneWidget);
    expect(find.byKey(const Key('device_a')), findsOneWidget);
  });

  testWidgets('command buttons are enabled when online', (tester) async {
    await pump(
      tester,
      DashboardState(
        status: DashboardStatus.loaded,
        devices: [device],
        connection: ConnectionStatus.connected,
      ),
    );
    await tester.tap(find.byKey(const Key('reboot_a')));
    verify(() => cubit.reboot('a')).called(1);
  });

  testWidgets('command buttons are disabled when offline', (tester) async {
    await pump(
      tester,
      DashboardState(
        status: DashboardStatus.loaded,
        devices: [device],
        connection: ConnectionStatus.reconnecting,
      ),
    );
    final button = tester.widget<TextButton>(find.byKey(const Key('reboot_a')));
    expect(button.onPressed, isNull);
  });

  testWidgets('sending shows progress and disables buttons', (tester) async {
    await pump(
      tester,
      DashboardState(
        status: DashboardStatus.loaded,
        devices: [device],
        connection: ConnectionStatus.connected,
        sending: const {'a'},
      ),
    );
    expect(find.byKey(const Key('command_progress')), findsOneWidget);
    final button = tester.widget<TextButton>(find.byKey(const Key('reboot_a')));
    expect(button.onPressed, isNull);
  });

  testWidgets('timeout feedback shows a snackbar', (tester) async {
    final online = DashboardState(
      status: DashboardStatus.loaded,
      devices: [device],
      connection: ConnectionStatus.connected,
    );
    await tester.pumpView<DashboardCubit, DashboardState>(
      const DashboardView(),
      cubit: cubit,
      state: online,
      updates: Stream.value(
        online.copyWith(
          feedback: (
            deviceId: 'a',
            result: const CommandResult.timedOut(cmdId: 'c1'),
          ),
        ),
      ),
    );
    await tester.pump();
    expect(find.text('a: no response in time'), findsOneWidget);
  });

  DashboardState loaded({
    List<Device>? devices,
    ConnectionStatus connection = ConnectionStatus.connected,
  }) => DashboardState(
    status: DashboardStatus.loaded,
    devices: devices ?? [device],
    connection: connection,
  );

  Future<void> pumpFeedback(WidgetTester tester, CommandResult result) async {
    final state = loaded();
    await tester.pumpView<DashboardCubit, DashboardState>(
      const DashboardView(),
      cubit: cubit,
      state: state,
      updates: Stream.value(
        state.copyWith(feedback: (deviceId: 'a', result: result)),
      ),
    );
    await tester.pump();
  }

  testWidgets('ack feedback shows a snackbar', (tester) async {
    await pumpFeedback(tester, const CommandResult.succeeded(cmdId: 'c1'));
    expect(find.text('a: acknowledged'), findsOneWidget);
  });

  testWidgets('failed feedback shows the error', (tester) async {
    await pumpFeedback(
      tester,
      const CommandResult.failed(cmdId: 'c1', error: 'boom'),
    );
    expect(find.text('a: boom'), findsOneWidget);
  });

  testWidgets('renders a tile per device', (tester) async {
    await pump(
      tester,
      loaded(
        devices: [
          device,
          device.copyWith(id: 'b'),
        ],
      ),
    );
    expect(find.byKey(const Key('device_a')), findsOneWidget);
    expect(find.byKey(const Key('device_b')), findsOneWidget);
  });

  testWidgets('device without data shows a placeholder', (tester) async {
    await pump(
      tester,
      loaded(devices: [const Device(id: 'n', online: true, isStale: false)]),
    );
    expect(find.text('No data yet'), findsOneWidget);
    expect(find.textContaining('°C'), findsNothing);
  });

  testWidgets('set interval sends the entered value', (tester) async {
    await pump(tester, loaded());
    await tester.tap(find.byKey(const Key('set_interval_a')));
    await tester.pump();
    await tester.enterText(find.byKey(const Key('interval_field')), '10');
    await tester.pump();
    await tester.tap(find.byKey(const Key('interval_confirm')));
    await tester.pump();
    verify(() => cubit.setInterval('a', 10)).called(1);
  });

  testWidgets('cancelling the interval dialog sends nothing', (tester) async {
    await pump(tester, loaded());
    await tester.tap(find.byKey(const Key('set_interval_a')));
    await tester.pump();
    await tester.tap(find.text('Cancel'));
    await tester.pump();
    verifyNever(() => cubit.setInterval(any(), any()));
  });

  testWidgets('interval confirm is disabled for zero', (tester) async {
    await pump(tester, loaded());
    await tester.tap(find.byKey(const Key('set_interval_a')));
    await tester.pump();
    await tester.enterText(find.byKey(const Key('interval_field')), '0');
    await tester.pump();
    final confirm = tester.widget<FilledButton>(
      find.byKey(const Key('interval_confirm')),
    );
    expect(confirm.onPressed, isNull);
  });
}
