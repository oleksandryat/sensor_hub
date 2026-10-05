import 'dart:collection';

import 'package:sensor_hub/domain/backoff_policy.dart';

class FakeBackoffPolicy implements BackoffPolicy {
  final Queue<Duration> delays = Queue();
  int resetCalls = 0;

  @override
  Duration nextDelay() {
    assert(delays.isNotEmpty, 'DELAYS ARE EMPTY');
    return delays.removeFirst();
  }

  @override
  void reset() {
    resetCalls++;
  }
}
