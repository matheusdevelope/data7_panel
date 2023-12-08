import 'package:flutter/material.dart';

class WindowsServicePage extends StatelessWidget {
  const WindowsServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WindowsService Page'),
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
