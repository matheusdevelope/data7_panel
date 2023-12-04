import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingAnimated extends StatelessWidget {
  const LoadingAnimated({super.key, required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Lottie.asset(
              'assets/loading.json',
            ),
          ),
          if (message.isNotEmpty)
            Container(
              padding: const EdgeInsets.only(
                  top: 10, right: 16, bottom: 30, left: 16),
              child: Text(message),
            )
        ],
      ),
    );
  }
}
