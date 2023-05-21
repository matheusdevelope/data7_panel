import 'package:data7_panel/components/settings/settings.dart';
import 'package:data7_panel/services/audio.dart';
import 'package:flutter/material.dart';

class Configurations extends StatefulWidget {
  const Configurations({
    super.key,
  });
  @override
  State<Configurations> createState() => _ConfigurationsState();
}

class _ConfigurationsState extends State<Configurations> {
  bool refresh = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Settings.notifications.initialize(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return const Text('Erro ao carregar as configurações');
        } else {
          return Padding(
            padding: const EdgeInsets.all(4),
            child: ListView(
              children: [
                SettingsGroup(
                  title: 'Geral',
                  children: [
                    SettingsCategory(
                      title: "Notificações",
                      icon: Icons.notification_add,
                      iconStyle: IconStyle(
                        // iconsColor: Colors.white,
                        withBackground: true,
                        backgroundColor: Colors.blue[900],
                      ),
                      child: [
                        SettingsItem(
                          child: SettingRowToggle(
                            title: 'Alerta Sonoro',
                            initialValue: Settings.notifications.enabled,
                            onChange: (value) {
                              Settings.notifications.enabled = value;
                            },
                          ),
                        ),
                        SettingsItem(
                          child: SettingRowSlider(
                            title: 'Volume',
                            from: 1,
                            to: 100,
                            initialValue: Settings.notifications.volume * 100,
                            justIntValues: true,
                            unit: ' %',
                            onChange: (value) {
                              Settings.notifications.volume = value / 100;
                            },
                          ),
                        ),
                        SettingsItem(
                          child: SettingRowDropDown(
                            title: 'Som de Notificação',
                            items: Settings.notifications.files,
                            itemsDefault: Settings.notifications.filesDefault,
                            selectedValue: Settings.notifications.file,
                            onChange: (value) {
                              Settings.notifications.file = value;
                            },
                            onAdd: () => Settings.notifications.addFile([]),
                            onRightButtonPress: (item) {
                              Settings.notifications.deleteFile(item);
                            },
                            onLeftButtonPress: (item) =>
                                AudioHelper().playPause(item),
                            onLeftLongButtonPress: (item) =>
                                AudioHelper().play(item),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          );
        }
      },
    );
  }
}
