import 'package:flutter_test/flutter_test.dart';
import 'package:sensor_hub/domain/throttle.dart';

void main() {
  late DateTime now;
  late Throttle throttle;

  setUp(() {
    now = DateTime(2026);
    throttle = Throttle(const Duration(seconds: 1), () => now);
  });

  test('first call passes', () => expect(throttle.tryAcquire(), isTrue));

  test('calls inside the interval are dropped', () {
    throttle.tryAcquire();
    now = now.add(const Duration(milliseconds: 999));
    expect(throttle.tryAcquire(), isFalse);
  });

  test('call after the interval passes and restarts the window', () {
    throttle.tryAcquire();
    now = now.add(const Duration(seconds: 1));
    expect(throttle.tryAcquire(), isTrue);
    now = now.add(const Duration(milliseconds: 500));
    expect(throttle.tryAcquire(), isFalse);
  });
}
