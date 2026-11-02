import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sensorhub_native/sensorhub_native.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  test('setValue goes to the per-view channel', () async {
    final calls = <MethodCall>[];
    messenger.setMockMethodCallHandler(
      const MethodChannel('sensorhub_native/gauge_7'),
      (call) async {
        calls.add(call);
        return null;
      },
    );

    await NativeGaugeController(7).setValue(4.5);

    expect(calls.single.method, 'setValue');
    expect(calls.single.arguments, 4.5);
  });

  testWidgets('shows a fallback without a platform view', (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;

    await tester.pumpWidget(
      const MaterialApp(
        home: NativeGauge(min: 0, max: 30, unit: 'm/s²', value: 9.8),
      ),
    );

    expect(find.text('Native gauge is not available here'), findsOneWidget);
    debugDefaultTargetPlatformOverride = null;
  });
}
