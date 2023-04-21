import 'package:flutter/material.dart';

class CustomSlider extends StatelessWidget {
  final String label;
  final double value;
  final double minValue;
  final double maxValue;
  final Function(double) onChange;
  const CustomSlider(
      {super.key,
      required this.label,
      required this.value,
      required this.minValue,
      required this.maxValue,
      required this.onChange});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              label,
              textAlign: TextAlign.end,
            ),
          ),
          Expanded(
            flex: 4,
            child: Slider(
                value: value,
                min: minValue,
                max: maxValue,
                divisions: (maxValue - minValue).toInt(),
                onChanged: onChange),
          )
        ],
      ),
    );
  }
}
