import 'package:flutter/material.dart';

class CustomOutilinedButton extends StatelessWidget {
  final String label;
  final Function() onPress;
  final ButtonStyle? buttonStyle;
  final bool? enabled;

  const CustomOutilinedButton(
      {required this.label,
      required this.onPress,
      this.buttonStyle,
      this.enabled});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: OutlinedButton(
        style: buttonStyle,
        onPressed: enabled == false ? null : onPress,
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
