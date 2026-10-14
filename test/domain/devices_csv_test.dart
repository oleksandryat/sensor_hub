import 'package:flutter_test/flutter_test.dart';
import 'package:sensor_hub/domain/device.dart';
import 'package:sensor_hub/domain/devices_csv.dart';
import 'package:sensor_hub/domain/telemetry.dart';

void main() {
  test('empty list yields only the header', () {
    expect(devicesToCsv([]), 'id,online,value,unit,last_seen');
  });

  test('serializes one row per device, blanks for missing data', () {
    final seen = DateTime(2026, 10, 19, 12, 30, 5);
    final csv = devicesToCsv([
      Device(
        id: 'a',
        online: true,
        isStale: false,
        lastSeen: seen,
        last: Telemetry(ts: seen, value: 21.456, unit: 'C'),
      ),
      const Device(id: 'b', online: false, isStale: false),
    ]);

    expect(csv.split('\n'), [
      'id,online,value,unit,last_seen',
      'a,true,21.46,C,2026-10-19 12:30:05',
      'b,false,,,',
    ]);
  });
}
