import 'package:flutter_test/flutter_test.dart';
import 'package:sensor_hub/main.dart';

void main() {
  testWidgets('SensorHubApp renders', (tester) async {
    await tester.pumpWidget(const SensorHubApp());

    expect(find.text('SensorHub'), findsOneWidget);
  });
}
