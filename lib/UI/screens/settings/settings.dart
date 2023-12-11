import 'package:data7_panel/UI/screens/settings/categories/notifications_category.dart';
import 'package:data7_panel/UI/screens/settings/categories/panel_category.dart';
import 'package:data7_panel/UI/screens/settings/categories/theme_category.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: ListView(
        children: const [
          SettingsPanelCategory(),
          SettingsNotificationsCategory(),
          SettingsThemeCategory()
        ],
      ),
    );
  }
}
