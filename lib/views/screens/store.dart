import 'package:flutter/material.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Store')),
      body: const Center(
        child: Text(
          'This is the Store Screen',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}