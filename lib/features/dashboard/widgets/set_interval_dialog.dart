import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SetIntervalDialog extends StatefulWidget {
  const SetIntervalDialog({super.key});

  @override
  State<SetIntervalDialog> createState() => _SetIntervalDialogState();
}

class _SetIntervalDialogState extends State<SetIntervalDialog> {
  final _controller = TextEditingController(text: '5');

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final seconds = int.tryParse(_controller.text);
    return AlertDialog(
      title: const Text('Set interval'),
      content: TextField(
        key: const Key('interval_field'),
        controller: _controller,
        autofocus: true,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: const InputDecoration(suffixText: 'seconds'),
        onChanged: (_) => setState(() {}),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          key: const Key('interval_confirm'),
          onPressed: seconds == null || seconds <= 0
              ? null
              : () => Navigator.of(context).pop(seconds),
          child: const Text('Send'),
        ),
      ],
    );
  }
}
