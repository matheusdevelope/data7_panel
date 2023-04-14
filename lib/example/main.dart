import 'package:flutter/material.dart';

import 'panel_example.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Row(
              children: const [
                ScrollableColumnWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
