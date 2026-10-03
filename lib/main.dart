import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MovePlus',
      home: Scaffold(
        appBar: AppBar(title: const Text('MovePlus MVP')),
        body: const Center(child: Text('Bem-vindo ao MovePlus!')),
      ),
    );
  }
}
