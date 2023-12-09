import 'package:flutter/material.dart';
import 'settings_category.dart';

class SettingsGroup extends StatefulWidget {
  final String title;
  final List<SettingsCategory> children;

  const SettingsGroup({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  State<SettingsGroup> createState() => SettingsGroupState();
}

class SettingsGroupState extends State<SettingsGroup> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 16.0),
          child: Text(
            widget.title,
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.headlineSmall?.fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...widget.children
      ],
    );
  }
}
