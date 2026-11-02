import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Pushes values into one native gauge over its own channel.
class NativeGaugeController {
  static const viewType = 'sensorhub_native/gauge';

  final MethodChannel _channel;

  NativeGaugeController(int viewId, {BinaryMessenger? messenger})
    : _channel = MethodChannel(
        '${viewType}_$viewId',
        const StandardMethodCodec(),
        messenger,
      );

  /// Redraws the gauge; the native view clamps [value] to its range.
  Future<void> setValue(double value) =>
      _channel.invokeMethod<void>('setValue', value);
}

/// Native custom-drawn gauge (`View.onDraw` / `UIView.draw`).
///
/// [min], [max], [unit] and the first [value] travel as creation params;
/// later [value] changes go through the per-view channel, so the platform
/// view is never recreated.
class NativeGauge extends StatefulWidget {
  final double min;
  final double max;
  final String unit;
  final double value;

  const NativeGauge({
    super.key,
    required this.min,
    required this.max,
    required this.unit,
    required this.value,
  });

  @override
  State<NativeGauge> createState() => _NativeGaugeState();
}

class _NativeGaugeState extends State<NativeGauge> {
  NativeGaugeController? _controller;

  @override
  void didUpdateWidget(NativeGauge old) {
    super.didUpdateWidget(old);
    if (old.value != widget.value) _controller?.setValue(widget.value);
  }

  @override
  Widget build(BuildContext context) {
    final params = <String, Object?>{
      'min': widget.min,
      'max': widget.max,
      'unit': widget.unit,
      'value': widget.value,
    };
    void onCreated(int id) => _controller = NativeGaugeController(id);
    return switch (defaultTargetPlatform) {
      TargetPlatform.android => AndroidView(
        viewType: NativeGaugeController.viewType,
        creationParams: params,
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: onCreated,
      ),
      TargetPlatform.iOS => UiKitView(
        viewType: NativeGaugeController.viewType,
        creationParams: params,
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: onCreated,
      ),
      _ => const Center(child: Text('Native gauge is not available here')),
    };
  }
}
