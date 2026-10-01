import 'dart:math';

abstract interface class BackoffPolicy {
  Duration nextDelay();

  void reset();
}

class FullJitterBackoffPolicy implements BackoffPolicy {
  int _attempt = 0;

  final Duration base;
  final Duration max;
  final Random random;

  new({
    this.base = const Duration(seconds: 1),
    this.max = const Duration(seconds: 30),
    required this.random,
  });

  @override
  Duration nextDelay() {
    final base = this.base.inMilliseconds;
    final max = this.max.inMilliseconds;
    _attempt++;
    final exp = min(base * pow(2, _attempt - 1), max).toInt();
    return Duration(milliseconds: random.nextInt(exp + 1));
  }

  @override
  void reset() {
    _attempt = 0;
  }
}
