import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers.dart';

void main() {
  testWidgets('pumpUntilFound waits for a delayed widget', (tester) async {
    await tester.pumpApp(const _Delayed());
    expect(find.text('ready'), findsNothing);

    await tester.pumpUntilFound(find.text('ready'));
    expect(find.text('ready'), findsOneWidget);
  });

  testWidgets('pumpUntilFound fails on timeout', (tester) async {
    await tester.pumpApp(const SizedBox());
    Object? error;
    try {
      await tester.pumpUntilFound(
        find.text('never'),
        timeout: const Duration(milliseconds: 200),
      );
    } catch (e) {
      error = e;
    }
    expect(error, isA<TestFailure>());
  });
}

class _Delayed extends StatelessWidget {
  const _Delayed();

  @override
  Widget build(BuildContext context) => FutureBuilder<String>(
    future: Future.delayed(const Duration(milliseconds: 300), () => 'ready'),
    builder: (_, snap) => Text(snap.data ?? ''),
  );
}
