import 'package:flutter/material.dart';

class WindowsServiceScreen extends StatelessWidget {
  const WindowsServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WindowsServiceScreen'),
      ),
      body: Center(
        child: TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Go to Home Page'),
        ),
      ),
    );
  }
}
