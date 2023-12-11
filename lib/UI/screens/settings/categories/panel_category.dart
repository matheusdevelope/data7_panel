import 'package:data7_panel/UI/components/settings/settings.dart';
import 'package:data7_panel/main.dart';
import 'package:flutter/material.dart';

class SettingsPanelCategory extends StatelessWidget {
  const SettingsPanelCategory({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsCategory(
      title: "Painel",
      expansible: true,
      icon: Icons.table_view,
      iconStyle: IconStyle(
        withBackground: true,
        backgroundColor: Colors.green[700],
      ),
      child: [
        SettingsItem(
          child: SettingRowToggle(
            title: 'Abrir Automaticamente',
            subtitle:
                "Caso o endereço de acesso seja válido, ao entrar no aplicativo o painel será aberto imediatamente.",
            initialValue: settings.panel.openAutomatic,
            onChange: (value) {
              settings.panel.openAutomatic = value;
            },
          ),
        ),
        SettingsItem(
          child: SettingRowToggle(
            title: 'Avanço Automático do Carrossel',
            subtitle:
                "Se configurado na fonte de dados, os carrosseis carregados irão ficar fazendo a transição/exibição pelo tempo definido.",
            initialValue: settings.carousel.autoplay,
            onChange: (value) {
              settings.carousel.autoplay = value;
            },
          ),
        ),
        SettingsItem(
          child: SettingRowNumber(
            title: 'Duração Padrão dos Carrosseis (Segundos)',
            subtitle:
                'Esse valor será ignorado caso na fonte de dados do painel esteja informada a duração manualmente.',
            useCarousel: false,
            minValue: 1,
            maxValue: 60 * 60,
            initialValue: settings.carousel.autoPlayDuration,
            onChange: (value) {
              settings.carousel.autoPlayDuration = value;
            },
          ),
        ),
      ],
    );
  }
}
