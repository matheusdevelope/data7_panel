import 'package:data7_panel/old/components/settings/settings_item.dart';
import 'package:data7_panel/old/providers/settings_model.dart';
import 'package:flutter/material.dart';

class SettingsNotifications extends StatefulWidget {
  const SettingsNotifications({
    super.key,
  });
  @override
  State<SettingsNotifications> createState() => _SettingsNotificationsState();
}

class _SettingsNotificationsState extends State<SettingsNotifications> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Settings.notifications.initialize(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return const Text(
              'Erro ao carregar as configurações de notificações');
        } else {
          return Column(
            children: [
              SettingsItem(
                child: Text('Conteúdo do Componente2'),
              ),
              Text('Conteúdo do Componente'),
              Text('Conteúdo do Componente')
            ],
          );
        }
      },
    );
  }
}
