import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sensor_hub/domain/connection_status.dart';
import 'package:sensor_hub/domain/device.dart';
import 'package:sensor_hub/domain/telemetry.dart';
import 'package:sensor_hub/features/dashboard/cubit/dashboard_cubit.dart';
import 'package:sensor_hub/features/dashboard/view/dashboard_screen.dart';

class MockDashboardCubit extends MockCubit<DashboardState>
    implements DashboardCubit {}

void main() {
  late MockDashboardCubit cubit;

  setUp(() => cubit = MockDashboardCubit());

  Future<void> pump(WidgetTester tester, DashboardState state) {
    whenListen(
      cubit,
      const Stream<DashboardState>.empty(),
      initialState: state,
    );
    return tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<DashboardCubit>.value(
          value: cubit,
          child: const DashboardView(),
        ),
      ),
    );
  }

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
}
