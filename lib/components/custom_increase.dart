import 'dart:async';

import 'package:flutter/material.dart';

class CustomIncrease extends StatefulWidget {
  final String label;
  final double value;
  final double minValue;
  final double maxValue;
  final Function(double) onChange;
  final double fontSize;
  CustomIncrease({
    super.key,
    required this.label,
    required this.value,
    required this.minValue,
    required this.maxValue,
    required this.onChange,
    required this.fontSize,
  });

  @override
  State<CustomIncrease> createState() => _CustomIncreaseState();
}

class _CustomIncreaseState extends State<CustomIncrease> {
  Timer? timer;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          widget.label,
          style: TextStyle(fontSize: widget.fontSize),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onLongPress: () => setState(() {
                timer =
                    Timer.periodic(const Duration(milliseconds: 60), (timer) {
                  setState(() {
                    if (widget.value - 1 >= widget.minValue) {
                      widget.onChange(widget.value - 1);
                    }
                  });
                });
              }),
              onLongPressEnd: (_) => setState(() {
                timer?.cancel();
              }),
              child: IconButton(
                iconSize: widget.fontSize,
                onPressed: () {
                  if (widget.value - 1 >= widget.minValue) {
                    widget.onChange(widget.value - 1);
                  }
                },
                icon: const Icon(Icons.remove),
              ),
            ),
            Text(
              widget.value.toString(),
              style: TextStyle(fontSize: widget.fontSize),
            ),
            GestureDetector(
              onLongPress: () => setState(() {
                timer =
                    Timer.periodic(const Duration(milliseconds: 60), (timer) {
                  setState(() {
                    if (widget.value + 1 <= widget.maxValue) {
                      widget.onChange(widget.value + 1);
                    }
                  });
                });
              }),
              onLongPressEnd: (_) => setState(() {
                timer?.cancel();
              }),
              child: IconButton(
                iconSize: widget.fontSize,
                onPressed: () {
                  if (widget.value + 1 <= widget.maxValue) {
                    widget.onChange(widget.value + 1);
                  }
                },
                icon: const Icon(Icons.add),
              ),
            ),
          ],
        ),
      ],
    ));
  }
}
