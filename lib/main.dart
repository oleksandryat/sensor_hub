import 'package:flutter/material.dart';

void main() {
  runApp(const SensorHubApp());
}

class SensorHubApp extends StatelessWidget {
  const SensorHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SensorHub',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      home: const Scaffold(body: Center(child: Text('SensorHub'))),
    );
  }
}
