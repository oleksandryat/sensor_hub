import 'package:flutter_test/flutter_test.dart';
import 'package:sensor_hub/app.dart';
import 'package:sensor_hub/core/di/injection.dart';

void main() {
  setUp(() async {
    await getIt.reset();
    configureDependencies();
  });

  testWidgets('SensorHubApp shows connection screen first', (tester) async {
    await tester.pumpWidget(const SensorHubApp());
    await tester.pump();

    expect(find.text('Connection'), findsWidgets);
  });
}
