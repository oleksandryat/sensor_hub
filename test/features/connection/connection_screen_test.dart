import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sensor_hub/core/router/app_router.dart';
import 'package:sensor_hub/domain/connection_status.dart';
import 'package:sensor_hub/domain/stored_credentials.dart';
import 'package:sensor_hub/features/connection/cubit/connection_cubit.dart';
import 'package:sensor_hub/features/connection/view/connection_screen.dart';

import '../../helpers/helpers.dart';

class MockStackRouter extends Mock implements StackRouter {}

void main() {
  late MockConnectionCubit cubit;

  setUpAll(() => registerFallbackValue(const DashboardRoute()));

  setUp(() {
    cubit = MockConnectionCubit();
    when(
      () => cubit.connect(
        host: any(named: 'host'),
        port: any(named: 'port'),
        username: any(named: 'username'),
        password: any(named: 'password'),
        remember: any(named: 'remember'),
      ),
    ).thenAnswer((_) async {});
    when(() => cubit.disconnect()).thenAnswer((_) async {});
  });

  Future<void> pump(
    WidgetTester tester,
    ConnectionStatus status, {
    StoredCredentials? saved,
  }) => tester.pumpView<ConnectionCubit, ConnectionCubitState>(
    const ConnectionView(),
    cubit: cubit,
    state: ConnectionCubitState(status: status, saved: saved),
  );

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

  testWidgets('remember checkbox is passed to connect', (tester) async {
    await pump(tester, ConnectionStatus.disconnected);

    await tester.tap(find.byKey(const Key('remember_checkbox')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('connect_button')));
    await tester.pump();

    verify(
      () => cubit.connect(
        host: 'test.mosquitto.org',
        port: 1883,
        username: '',
        password: '',
        remember: true,
      ),
    ).called(1);
  });

  testWidgets('saved credentials prefill the form', (tester) async {
    await pump(
      tester,
      ConnectionStatus.disconnected,
      saved: const StoredCredentials(username: 'user', password: 'secret'),
    );

    expect(find.text('user'), findsOneWidget);
    expect(
      tester
          .widget<CheckboxListTile>(find.byKey(const Key('remember_checkbox')))
          .value,
      isTrue,
    );
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

  testWidgets('reconnecting locks fields and offers cancel', (tester) async {
    await pump(tester, ConnectionStatus.reconnecting);

    expect(find.byKey(const Key('connect_button')), findsNothing);
    expect(find.byKey(const Key('disconnect_button')), findsOneWidget);
    expect(
      tester.widget<TextField>(find.byType(TextField).first).enabled,
      isFalse,
    );
  });

  testWidgets('error state keeps form editable and allows retry', (
    tester,
  ) async {
    await pump(tester, ConnectionStatus.error);

    expect(find.byKey(const Key('connect_button')), findsOneWidget);
    expect(
      tester.widget<TextField>(find.byType(TextField).first).enabled,
      isTrue,
    );
    await tester.tap(find.byKey(const Key('connect_button')));
    verify(
      () => cubit.connect(
        host: any(named: 'host'),
        port: any(named: 'port'),
        username: any(named: 'username'),
        password: any(named: 'password'),
      ),
    ).called(1);
  });

  testWidgets('non-numeric port is rejected', (tester) async {
    await pump(tester, ConnectionStatus.disconnected);

    await tester.enterText(find.byKey(const Key('port_field')), 'abc');
    await tester.tap(find.byKey(const Key('connect_button')));
    await tester.pump();

    expect(find.text('Port must be 1–65535'), findsOneWidget);
  });

  testWidgets('host and port are trimmed, password is passed as typed', (
    tester,
  ) async {
    await pump(tester, ConnectionStatus.disconnected);

    await tester.enterText(find.byKey(const Key('host_field')), '  broker.io ');
    await tester.enterText(find.byKey(const Key('port_field')), ' 8883 ');
    await tester.enterText(find.byKey(const Key('password_field')), ' secret ');
    await tester.tap(find.byKey(const Key('connect_button')));
    await tester.pump();

    verify(
      () => cubit.connect(
        host: 'broker.io',
        port: 8883,
        username: '',
        password: ' secret ',
      ),
    ).called(1);
  });

  testWidgets('password field is obscured', (tester) async {
    await pump(tester, ConnectionStatus.disconnected);

    final field = tester.widget<TextField>(
      find.descendant(
        of: find.byKey(const Key('password_field')),
        matching: find.byType(TextField),
      ),
    );
    expect(field.obscureText, isTrue);
  });

  testWidgets('status updates and form input survive state changes', (
    tester,
  ) async {
    final updates = StreamController<ConnectionCubitState>();
    addTearDown(updates.close);
    await tester.pumpView<ConnectionCubit, ConnectionCubitState>(
      const ConnectionView(),
      cubit: cubit,
      state: const ConnectionCubitState(),
      updates: updates.stream,
    );
    await tester.enterText(find.byKey(const Key('host_field')), 'my.host');

    updates.add(
      const ConnectionCubitState(status: ConnectionStatus.connecting),
    );
    await tester.pump();
    expect(find.text('Connecting…'), findsOneWidget);

    updates.add(const ConnectionCubitState(status: ConnectionStatus.error));
    await tester.pump();
    expect(find.text('Error'), findsOneWidget);
    expect(find.text('my.host'), findsOneWidget);
  });

  testWidgets('navigates to dashboard once connected', (tester) async {
    final router = MockStackRouter();
    when(() => router.push<Object?>(any())).thenAnswer((_) async => null);
    final updates = StreamController<ConnectionCubitState>();
    addTearDown(updates.close);
    whenListen(
      cubit,
      updates.stream,
      initialState: const ConnectionCubitState(),
    );

    await tester.pumpApp(
      StackRouterScope(
        controller: router,
        stateHash: 0,
        child: BlocProvider<ConnectionCubit>.value(
          value: cubit,
          child: const ConnectionView(),
        ),
      ),
    );
    verifyNever(() => router.push<Object?>(any()));

    updates.add(const ConnectionCubitState(status: ConnectionStatus.connected));
    await tester.pump();

    verify(() => router.push<Object?>(any(that: isA<DashboardRoute>())))
        .called(1);
  });
}
