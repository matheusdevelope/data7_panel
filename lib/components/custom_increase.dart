import 'package:flutter/material.dart';

class CustomIncrease extends StatelessWidget {
  final String label;
  final double value;
  final double minValue;
  final double maxValue;
  final Function(double) onChange;
  final double fontSize;
  const CustomIncrease({
    super.key,
    required this.label,
    required this.value,
    required this.minValue,
    required this.maxValue,
    required this.onChange,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            iconSize: fontSize,
            onPressed: () {
              if (value - 1 >= minValue) onChange(value - 1);
            },
            icon: const Icon(Icons.remove),
          ),
          Text(
            value.toString(),
            style: TextStyle(fontSize: fontSize - 6),
          ),
          IconButton(
            iconSize: fontSize,
            onPressed: () {
              if (value + 1 <= maxValue) onChange(value + 1);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
