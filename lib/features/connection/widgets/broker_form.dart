import 'package:flutter/material.dart';

import '../../../domain/connection_status.dart';

typedef BrokerFormSubmit = void Function(
  String host,
  int port,
  String username,
  String password,
);

class BrokerForm extends StatefulWidget {
  final ConnectionStatus status;
  final BrokerFormSubmit onConnect;
  final VoidCallback onDisconnect;

  const BrokerForm({
    super.key,
    required this.status,
    required this.onConnect,
    required this.onDisconnect,
  });

  @override
  State<BrokerForm> createState() => _BrokerFormState();
}

class _BrokerFormState extends State<BrokerForm> {
  final _formKey = GlobalKey<FormState>();
  final _host = TextEditingController(text: 'test.mosquitto.org');
  final _port = TextEditingController(text: '1883');
  final _username = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _host.dispose();
    _port.dispose();
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    widget.onConnect(
      _host.text.trim(),
      int.parse(_port.text.trim()),
      _username.text,
      _password.text,
    );
  }

  static String? _validateHost(String? value) =>
      value == null || value.trim().isEmpty ? 'Host is required' : null;

  static String? _validatePort(String? value) {
    final port = int.tryParse(value?.trim() ?? '');
    return port == null || port < 1 || port > 65535
        ? 'Port must be 1–65535'
        : null;
  }

  @override
  Widget build(BuildContext context) {
    final status = widget.status;
    final isIdle =
        status == ConnectionStatus.disconnected ||
        status == ConnectionStatus.error;
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            key: const Key('host_field'),
            controller: _host,
            enabled: isIdle,
            decoration: const InputDecoration(labelText: 'Host'),
            keyboardType: TextInputType.url,
            validator: _validateHost,
          ),
          const SizedBox(height: 12),
          TextFormField(
            key: const Key('port_field'),
            controller: _port,
            enabled: isIdle,
            decoration: const InputDecoration(labelText: 'Port'),
            keyboardType: TextInputType.number,
            validator: _validatePort,
          ),
          const SizedBox(height: 12),
          TextFormField(
            key: const Key('username_field'),
            controller: _username,
            enabled: isIdle,
            decoration: const InputDecoration(labelText: 'Username'),
          ),
          const SizedBox(height: 12),
          TextFormField(
            key: const Key('password_field'),
            controller: _password,
            enabled: isIdle,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Password'),
          ),
          const SizedBox(height: 24),
          if (isIdle)
            FilledButton(
              key: const Key('connect_button'),
              onPressed: _submit,
              child: const Text('Connect'),
            )
          else
            OutlinedButton(
              key: const Key('disconnect_button'),
              onPressed: widget.onDisconnect,
              child: Text(
                status == ConnectionStatus.connected ? 'Disconnect' : 'Cancel',
              ),
            ),
        ],
      ),
    );
  }
}
