import 'package:data7_panel/old/components/settings/settings.dart';
import 'package:data7_panel/old/providers/theme_model.dart';
import 'package:data7_panel/old/services/audio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Configurations extends StatefulWidget {
  const Configurations({
    super.key,
  });
  @override
  State<Configurations> createState() => _ConfigurationsState();
}

class _ConfigurationsState extends State<Configurations> {
  Future<void> initializeValues() async {
    await Settings.notifications.initialize();
    await Settings.theme.initialize();
    await Settings.carrossel.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initializeValues(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return const Text('Erro ao carregar as configurações');
        } else {
          return Padding(
            padding: const EdgeInsets.all(4),
            child: Consumer<ThemeModel>(
              builder: (ctx, ThemeModel theme, c) {
                return ListView(
                  children: [
                    SettingsGroup(
                      title: 'Geral',
                      children: [
                        SettingsCategory(
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
                                title: 'Abrir Automáticamente',
                                subtitle:
                                    "Caso o endereço de acesso seja válido, ao entrar no aplicativo o painel será aberto imediatamente.",
                                initialValue: Settings.panel.openAutomatic,
                                onChange: (value) {
                                  Settings.panel.openAutomatic = value;
                                },
                              ),
                            ),
                            SettingsItem(
                              child: SettingRowToggle(
                                title: 'Avanço Automático do Carrossel',
                                subtitle:
                                    "Se configurado na fonte de dados, os carrosseis carregados irão ficar fazendo a transição/exibição pelo tempo definido.",
                                initialValue: Settings.carrossel.autoplay,
                                onChange: (value) {
                                  Settings.carrossel.autoplay = value;
                                },
                              ),
                            ),
                            SettingsItem(
                              child: SettingRowNumber(
                                title:
                                    'Duração Padrão dos Carrosseis (Segundos)',
                                subtitle:
                                    'Esse valor será ignorado caso na fonte de dados do painel esteja informada a duração manualmente.',
                                useCarousel: false,
                                minValue: 1,
                                maxValue: 60 * 60,
                                initialValue:
                                    Settings.carrossel.autoPlayDuration,
                                // justIntValues: true,
                                // unit: ' seg.',
                                onChange: (value) {
                                  Settings.carrossel.autoPlayDuration = value;
                                },
                              ),
                            ),
                          ],
                        ),
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
                                initialValue:
                                    Settings.notifications.volume * 100,
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
                                itemsDefault:
                                    Settings.notifications.filesDefault,
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
                        SettingsCategory(
                          title: "Tema",
                          expansible: true,
                          icon: Icons.design_services,
                          iconStyle: IconStyle(
                            // iconsColor: Colors.white,
                            withBackground: true,
                            backgroundColor: Colors.red,
                          ),
                          child: [
                            SettingsItem(
                              child: SettingRowToggle(
                                title: 'Usar Tema Adaptativo',
                                initialValue: Settings.theme.useAdaptiveTheme,
                                onChange: (value) {
                                  theme.useAdaptiveTheme = value;
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
                                    initialValue: theme.fontSize,
                                    justIntValues: true,
                                    unit: ' px',
                                    onChange: (value) {
                                      theme.fontSize = value;
                                      theme.fontSizeTitlePanel = value;
                                      theme.fontSizeDataPanel = value;
                                      theme.fontSizeMenuPanel = value;
                                    },
                                  ),
                                ),
                                SettingsItem(
                                  child: SettingRowSlider(
                                    title: 'Titulo Painel',
                                    from: 13,
                                    to: 70,
                                    initialValue: theme.fontSizeTitlePanel,
                                    justIntValues: true,
                                    unit: ' px',
                                    onChange: (value) {
                                      theme.fontSizeTitlePanel = value;
                                    },
                                  ),
                                ),
                                SettingsItem(
                                  child: SettingRowSlider(
                                    title: 'Linhas Painel',
                                    from: 13,
                                    to: 70,
                                    initialValue: theme.fontSizeDataPanel,
                                    justIntValues: true,
                                    unit: ' px',
                                    onChange: (value) {
                                      theme.fontSizeDataPanel = value;
                                    },
                                  ),
                                ),
                                SettingsItem(
                                  child: SettingRowSlider(
                                    title: 'Menu Inferior',
                                    from: 13,
                                    to: 70,
                                    initialValue: theme.fontSizeMenuPanel,
                                    justIntValues: true,
                                    unit: ' px',
                                    onChange: (value) {
                                      theme.fontSizeMenuPanel = value;
                                    },
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    )
                  ],
                );
              },
            ),
          );
        }
      },
    );
  }
}
