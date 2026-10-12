import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sensor_hub/core/theme/app_theme.dart';

extension PumpApp on WidgetTester {
  /// Pumps [widget] in a themed `MaterialApp`, optionally wrapped in [providers].
  Future<void> pumpApp(
    Widget widget, {
    List<BlocProvider> providers = const [],
  }) {
    final Widget home = providers.isEmpty
        ? widget
        : MultiBlocProvider(providers: providers, child: widget);
    return pumpWidget(
      MaterialApp(theme: AppTheme.light, darkTheme: AppTheme.dark, home: home),
    );
  }

  /// Pumps [view] with [cubit] seeded to [state] (and emitting [updates]).
  // Pass type args explicitly: C must be the real cubit, not the mock.
  Future<void> pumpView<C extends BlocBase<S>, S>(
    Widget view, {
    required C cubit,
    required S state,
    Stream<S> updates = const Stream.empty(),
  }) {
    whenListen(cubit, updates, initialState: state);
    return pumpApp(view, providers: [BlocProvider<C>.value(value: cubit)]);
  }

  /// Pumps in [step] intervals until [finder] matches; avoids `pumpAndSettle`
  /// on screens with live streams or endless animations.
  Future<void> pumpUntilFound(
    Finder finder, {
    Duration step = const Duration(milliseconds: 50),
    Duration timeout = const Duration(seconds: 5),
  }) async {
    var elapsed = Duration.zero;
    while (finder.evaluate().isEmpty) {
      if (elapsed >= timeout) {
        throw TestFailure('Timed out after $timeout waiting for $finder');
      }
      await pump(step);
      elapsed += step;
    }
  }
}
