import 'package:flutter/material.dart';

class NumberStepper extends StatefulWidget {
  final String label;
  final double initialValue;
  final double min;
  final double max;
  final double step;
  final double fontSize;

  final Function(double) onChanged;

  const NumberStepper(
      {super.key,
      required this.label,
      required this.initialValue,
      required this.min,
      required this.max,
      required this.step,
      required this.fontSize,
      required this.onChanged});

  @override
  State<NumberStepper> createState() => _NumberStepperState();
}

class _NumberStepperState extends State<NumberStepper> {
  double _currentValue = 0;

  @override
  void initState() {
    super.initState();

    _currentValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // const SizedBox(width: 16),
        Column(
          children: [
            Text(
              widget.label + ":",
              style: TextStyle(fontSize: widget.fontSize),
            ),
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        if (_currentValue > widget.min) {
                          _currentValue -= widget.step;
                          _currentValue = double.parse(
                              _currentValue.toString().substring(0, 4));
                        }
                        widget.onChanged(_currentValue);
                      });
                    },
                    icon: const Icon(
                      Icons.remove_circle,
                      color: Color(0xFF006B98),
                    )),
                Text(
                  _currentValue.toString().substring(0, 4),
                  style: TextStyle(fontSize: widget.fontSize),
                ),
                IconButton(
                    onPressed: () {
                      setState(() {
                        if (_currentValue < widget.max) {
                          _currentValue += widget.step;
                          _currentValue = double.parse(
                              _currentValue.toString().substring(0, 4));
                        }
                        widget.onChanged(_currentValue);
                      });
                    },
                    icon:
                        const Icon(Icons.add_circle, color: Color(0xFF006B98))),
              ],
            )
          ],
        ),
      ],
    );
  }
}
