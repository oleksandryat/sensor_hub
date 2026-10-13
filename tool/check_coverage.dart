// Usage: dart run tool/check_coverage.dart [lcov] [threshold]
// Line coverage over lib/domain + lib/data, generated files and broker-bound gateways excluded.
import 'dart:io';

const _scope = ['lib/domain/', 'lib/data/'];
const _generated = ['.g.dart', '.freezed.dart', '.gr.dart'];
// Thin wrappers over real network clients; need a broker (local smoke test).
const _excluded = [
  'lib/data/mqtt/mqtt5_client_gateway.dart',
  'lib/data/mqtt/mqtt3_client_gateway.dart',
];

void main(List<String> args) {
  final path = args.isNotEmpty ? args[0] : 'coverage/lcov.info';
  final threshold = args.length > 1 ? double.parse(args[1]) : 80;

  var found = 0;
  var hit = 0;
  var include = false;
  for (final line in File(path).readAsLinesSync()) {
    if (line.startsWith('SF:')) {
      final file = line.substring(3);
      include =
          _scope.any(file.startsWith) &&
          !_generated.any(file.endsWith) &&
          !_excluded.contains(file);
    } else if (include && line.startsWith('DA:')) {
      found++;
      if (!line.endsWith(',0')) hit++;
    }
  }

  if (found == 0) {
    stderr.writeln('No coverage data for ${_scope.join(', ')}');
    exit(1);
  }
  final percent = hit / found * 100;
  stdout.writeln('Coverage: ${percent.toStringAsFixed(1)}% ($hit/$found)');
  if (percent < threshold) {
    stderr.writeln('Below threshold of $threshold%');
    exit(1);
  }
}
