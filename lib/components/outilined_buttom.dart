import 'package:flutter/material.dart';

class CustomOutilinedButton extends StatelessWidget {
  final String label;
  final Function() onPress;
  final ButtonStyle? buttonStyle;

  const CustomOutilinedButton(
      {required this.label, required this.onPress, this.buttonStyle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: OutlinedButton(
        style: buttonStyle,
        onPressed: onPress,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label),
          ],
        ),
      ),
    );
  }
}
