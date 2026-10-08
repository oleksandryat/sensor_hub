import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sensor_hub/domain/connection_status.dart';
import 'package:sensor_hub/features/connection/cubit/connection_cubit.dart';
import 'package:sensor_hub/features/connection/view/connection_screen.dart';

class MockConnectionCubit extends MockCubit<ConnectionCubitState>
    implements ConnectionCubit {}

void main() {
  late MockConnectionCubit cubit;

  setUp(() {
    cubit = MockConnectionCubit();
    when(
      () => cubit.connect(
        host: any(named: 'host'),
        port: any(named: 'port'),
        username: any(named: 'username'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async {});
    when(() => cubit.disconnect()).thenAnswer((_) async {});
  });

  Future<void> pump(WidgetTester tester, ConnectionStatus status) {
    whenListen(
      cubit,
      const Stream<ConnectionCubitState>.empty(),
      initialState: ConnectionCubitState(status: status),
    );
    return tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<ConnectionCubit>.value(
          value: cubit,
          child: const ConnectionView(),
        ),
      ),
    );
  }

  testWidgets('shows defaults and valid form connects', (tester) async {
    await pump(tester, ConnectionStatus.disconnected);

    expect(find.text('Disconnected'), findsOneWidget);
    await tester.enterText(find.byKey(const Key('username_field')), 'user');
    await tester.tap(find.byKey(const Key('connect_button')));
    await tester.pump();

    verify(
      () => cubit.connect(
        host: 'test.mosquitto.org',
        port: 1883,
        username: 'user',
        password: '',
      ),
    ).called(1);
  });

  testWidgets('invalid host and port block connect', (tester) async {
    await pump(tester, ConnectionStatus.disconnected);

    await tester.enterText(find.byKey(const Key('host_field')), ' ');
    await tester.enterText(find.byKey(const Key('port_field')), '70000');
    await tester.tap(find.byKey(const Key('connect_button')));
    await tester.pump();

    expect(find.text('Host is required'), findsOneWidget);
    expect(find.text('Port must be 1–65535'), findsOneWidget);
    verifyNever(
      () => cubit.connect(
        host: any(named: 'host'),
        port: any(named: 'port'),
        username: any(named: 'username'),
        password: any(named: 'password'),
      ),
    );
  });

  const labels = {
    ConnectionStatus.disconnected: 'Disconnected',
    ConnectionStatus.connecting: 'Connecting…',
    ConnectionStatus.connected: 'Connected',
    ConnectionStatus.reconnecting: 'Reconnecting…',
    ConnectionStatus.error: 'Error',
  };

  for (final MapEntry(key: status, value: label) in labels.entries) {
    testWidgets('shows "$label" for $status', (tester) async {
      await pump(tester, status);
      expect(
        find.descendant(
          of: find.byKey(const Key('connection_status_chip')),
          matching: find.text(label),
        ),
        findsOneWidget,
      );
    });
  }

  testWidgets('connecting shows cancel and locks fields', (tester) async {
    await pump(tester, ConnectionStatus.connecting);

    expect(find.byKey(const Key('connect_button')), findsNothing);
    expect(find.text('Cancel'), findsOneWidget);
    expect(
      tester.widget<TextField>(find.byType(TextField).first).enabled,
      isFalse,
    );

    await tester.tap(find.byKey(const Key('disconnect_button')));
    verify(() => cubit.disconnect()).called(1);
  });

  testWidgets('connected shows disconnect', (tester) async {
    await pump(tester, ConnectionStatus.connected);
    expect(find.text('Disconnect'), findsOneWidget);
  });
}
