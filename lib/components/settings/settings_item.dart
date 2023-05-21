import 'package:flutter/material.dart';

class SettingsItem extends StatefulWidget {
  final Widget child;

  SettingsItem({
    required this.child,
  });

  @override
  _SettingsItemState createState() => _SettingsItemState();
}

class _SettingsItemState extends State<SettingsItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(width: 0.5, color: Colors.grey.shade300),
      ),
      child: widget.child,
    );
  }
}
