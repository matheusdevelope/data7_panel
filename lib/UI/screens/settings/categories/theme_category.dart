import 'package:data7_panel/UI/components/settings/settings.dart';
import 'package:data7_panel/main.dart';
import 'package:flutter/material.dart';

class SettingsThemeCategory extends StatelessWidget {
  const SettingsThemeCategory({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsCategory(
      title: "Tema",
      expansible: true,
      icon: Icons.design_services,
      iconStyle: IconStyle(
        withBackground: true,
        backgroundColor: Colors.red,
      ),
      child: [
        SettingsItem(
          child: SettingRowToggle(
            title: 'Usar Tema Adaptativo',
            initialValue: settings.theme.useAdaptiveTheme,
            onChange: (value) {
              settings.theme.useAdaptiveTheme = value;
            },
          ),
        ),
        SettingsCategory(
          title: "Fontes",
          icon: Icons.font_download_outlined,
          expansible: true,
          child: [
            SettingsItem(
              child: SettingRowSlider(
                title: 'Geral',
                subtitle:
                    "Ao definir um valor geral, todas as fontes irão assumir o mesmo valor.",
                from: 13,
                to: 70,
                initialValue: settings.theme.fontSize,
                justIntValues: true,
                unit: ' px',
                onChange: (value) {
                  settings.theme.fontSize = value;
                  settings.theme.fontSizeTitlePanel = value;
                  settings.theme.fontSizeDataPanel = value;
                  settings.theme.fontSizeMenuPanel = value;
                },
              ),
            ),
            SettingsItem(
              child: SettingRowSlider(
                title: 'Titulo Painel',
                from: 13,
                to: 70,
                initialValue: settings.theme.fontSizeTitlePanel,
                justIntValues: true,
                unit: ' px',
                onChange: (value) {
                  settings.theme.fontSizeTitlePanel = value;
                },
              ),
            ),
            SettingsItem(
              child: SettingRowSlider(
                title: 'Linhas Painel',
                from: 13,
                to: 70,
                initialValue: settings.theme.fontSizeDataPanel,
                justIntValues: true,
                unit: ' px',
                onChange: (value) {
                  settings.theme.fontSizeDataPanel = value;
                },
              ),
            ),
            SettingsItem(
              child: SettingRowSlider(
                title: 'Menu Inferior',
                from: 13,
                to: 70,
                initialValue: settings.theme.fontSizeMenuPanel,
                justIntValues: true,
                unit: ' px',
                onChange: (value) {
                  settings.theme.fontSizeMenuPanel = value;
                },
              ),
            ),
          ],
        )
      ],
    );
  }
}
