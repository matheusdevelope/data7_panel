import 'package:data7_panel/UI/components/settings/settings.dart';
import 'package:data7_panel/core/infra/services/Models/audio.dart';
import 'package:data7_panel/main.dart';
import 'package:flutter/material.dart';

class SettingsNotificationsCategory extends StatelessWidget {
  const SettingsNotificationsCategory({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsCategory(
      title: "Notificações",
      icon: Icons.notification_add,
      iconStyle: IconStyle(
        withBackground: true,
        backgroundColor: Colors.blue[900],
      ),
      child: [
        SettingsItem(
          child: SettingRowToggle(
            title: 'Alerta Sonoro',
            initialValue: settings.notifications.enabled,
            onChange: (value) {
              settings.notifications.enabled = value;
            },
          ),
        ),
        SettingsItem(
          child: SettingRowSlider(
            title: 'Volume',
            from: 1,
            to: 100,
            initialValue: settings.notifications.volume * 100,
            justIntValues: true,
            unit: ' %',
            onChange: (value) {
              settings.notifications.volume = value / 100;
            },
          ),
        ),
        SettingsItem(
          child: SettingRowDropDown(
            title: 'Som de Notificação',
            items: settings.notifications.files,
            itemsDefault: [settings.notifications.file],
            selectedValue: settings.notifications.file,
            onChange: (value) {
              settings.notifications.file = value;
            },
            onAdd: settings.notifications.add,
            onRightButtonPress: settings.notifications.delete,
            onLeftButtonPress: (item) {
              audioPlayer.setVolume(settings.notifications.volume * 100);
              audioPlayer.playPause(Audio(path: item));
            },
            onLeftLongButtonPress: (item) => audioPlayer.play(
                audio: Audio(path: item),
                volume: settings.notifications.volume * 100,
                stopAll: true),
          ),
        ),
      ],
    );
  }
}
