import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sensor_hub/features/native_lab/benchmark/cubit/benchmark_cubit.dart';
import 'package:sensorhub_native/sensorhub_native.dart';

void main() {
  late Map<BenchmarkMechanism, int> calls;

  setUp(() => calls = {});

  BenchmarkCall counter(BenchmarkMechanism m) =>
      () => calls.update(m, (n) => n + 1, ifAbsent: () => 1);

  BenchmarkCubit build(Map<BenchmarkMechanism, BenchmarkCall> targets) =>
      BenchmarkCubit(targets, callCount: 5, warmUpCount: 2);

  blocTest<BenchmarkCubit, BenchmarkState>(
    'measures every mechanism after warm-up, sync and async',
    build: () => build({
      BenchmarkMechanism.methodChannel: () async =>
          counter(BenchmarkMechanism.methodChannel)(),
      BenchmarkMechanism.ffi: counter(BenchmarkMechanism.ffi),
    }),
    act: (c) => c.run(),
    verify: (c) {
      expect(calls, {
        BenchmarkMechanism.methodChannel: 7,
        BenchmarkMechanism.ffi: 7,
      });
      expect(c.state.status, BenchmarkStatus.done);
      expect(c.state.results.map((r) => r.mechanism), [
        BenchmarkMechanism.methodChannel,
        BenchmarkMechanism.ffi,
      ]);
      expect(c.state.results.every((r) => r.stats.count == 5), isTrue);
    },
  );

  blocTest<BenchmarkCubit, BenchmarkState>(
    'maps native errors',
    build: () => build({
      BenchmarkMechanism.pigeon: () =>
          throw const NativeException('unavailable', 'no handler'),
    }),
    act: (c) => c.run(),
    expect: () => [
      const BenchmarkState(status: BenchmarkStatus.running),
      const BenchmarkState(status: BenchmarkStatus.error, error: 'no handler'),
    ],
  );
}
