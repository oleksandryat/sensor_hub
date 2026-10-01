import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sensor_hub/domain/backoff_policy.dart';

class MockRandom extends Mock implements Random {}

void main() {
  late MockRandom random;
  late BackoffPolicy backoffPolicy;
  setUp(() {
    random = MockRandom();
    backoffPolicy = FullJitterBackoffPolicy(random: random);
    when(() => random.nextInt(any())).thenReturn(100);
  });

  test('called with base.inMilliseconds + 1', () {
    final delay = backoffPolicy.nextDelay();
    verify(() => random.nextInt(1001)).called(1);
    expect(delay, Duration(seconds: 0, milliseconds: 100));
  });

  test('exponent grows with each call', () {
    backoffPolicy.nextDelay();
    verify(() => random.nextInt(1001)).called(1);
    backoffPolicy.nextDelay();
    verify(() => random.nextInt(2001)).called(1);
    final delay = backoffPolicy.nextDelay();
    verify(() => random.nextInt(4001)).called(1);
    expect(delay, Duration(seconds: 0, milliseconds: 100));
  });

  test('caps at max when exponent outgrows it', () {
    backoffPolicy = FullJitterBackoffPolicy(
      base: Duration(seconds: 20),
      max: Duration(seconds: 30),
      random: random,
    );

    backoffPolicy.nextDelay();
    verify(() => random.nextInt(20001)).called(1);
    backoffPolicy.nextDelay();
    verify(() => random.nextInt(30001)).called(1);
  });

  test('reset restart the sequence', () {
    backoffPolicy = FullJitterBackoffPolicy(
      base: Duration(seconds: 20),
      max: Duration(seconds: 30),
      random: random,
    );

    backoffPolicy.nextDelay();
    verify(() => random.nextInt(20001)).called(1);
    backoffPolicy.nextDelay();
    verify(() => random.nextInt(30001)).called(1);
    backoffPolicy.reset();
    backoffPolicy.nextDelay();
    verify(() => random.nextInt(20001)).called(1);
  });

  test(
    'returned delay lays in expected range from 0 to exp+1 milliseconds',
    () {
      backoffPolicy = FullJitterBackoffPolicy(
        base: Duration(seconds: 20),
        max: Duration(seconds: 30),
        random: Random(),
      );

      final delay = backoffPolicy.nextDelay();
      expect(delay.inMilliseconds, inInclusiveRange(0, 30001));
    },
  );
}
