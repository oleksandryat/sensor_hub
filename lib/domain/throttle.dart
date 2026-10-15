/// Lets one event through per [interval]; the rest are dropped.
class Throttle {
  final Duration interval;
  final DateTime Function() _now;

  DateTime? _last;

  Throttle(this.interval, this._now);

  bool tryAcquire() {
    final now = _now();
    if (_last case final last? when now.difference(last) < interval) {
      return false;
    }
    _last = now;
    return true;
  }
}
