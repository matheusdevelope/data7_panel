import 'package:data7_panel/components/settings/settings.dart';
import 'package:data7_panel/components/settings/settings_textfield.dart';
import 'package:data7_panel/services/windows_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ServicePanelConfigs extends StatefulWidget {
  const ServicePanelConfigs({
    super.key,
  });
  @override
  State<ServicePanelConfigs> createState() => _ServicePanelConfigsState();
}

class _ServicePanelConfigsState extends State<ServicePanelConfigs> {
  late StatusService serviceStatus = StatusService.startPending;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Consumer<WinServiceSettings>(
          builder: (context, settings, c) {
            bool allowEdit = settings.status == StatusService.stopped ||
                settings.status == StatusService.unistalled;
            return Column(
              children: [
                SettingsGroup(
                  title: 'Configurações Painel',
                  children: [
                    SettingsCategory(
                      title: 'Dados de Conexão',
                      icon: Icons.account_tree_outlined,
                      iconStyle: IconStyle(),
                      child: [
                        SettingsItem(
                          child: SettingRowDropDown(
                            title: "RDBMS:",
                            enabled: allowEdit,
                            items: Settings.db.availableRdbms,
                            selectedValue: Settings.db.rdbms,
                            onChange: (value) {
                              Settings.db.rdbms = value;
                            },
                          ),
                        ),
                        SettingsItem(
                          child: SettingRowTextField(
                            title: "Usuário:",
                            enabled: allowEdit,
                            required: true,
                            initialValue: Settings.db.user,
                            onChange: (value) {
                              Settings.db.user = value;
                            },
                          ),
                        ),
                        SettingsItem(
                          child: SettingRowTextField(
                            title: "Senha:",
                            enabled: allowEdit,
                            initialValue: Settings.db.pass,
                            isPassword: true,
                            onChange: (value) {
                              Settings.db.pass = value;
                            },
                          ),
                        ),
                        SettingsItem(
                          child: SettingRowTextField(
                            title: "Servidor",
                            enabled: allowEdit,
                            initialValue: Settings.db.server,
                            onChange: (value) {
                              Settings.db.server = value;
                            },
                          ),
                        ),
                        SettingsItem(
                          child: SettingRowTextField(
                            title: "Porta",
                            enabled: allowEdit,
                            initialValue: Settings.db.port,
                            inputType: TextInputType.number,
                            onChange: (value) {
                              Settings.db.port = value;
                            },
                          ),
                        ),
                        SettingsItem(
                          child: SettingRowTextField(
                            title: "Base de Dados",
                            enabled: allowEdit,
                            initialValue: Settings.db.databaseName,
                            onChange: (value) {
                              Settings.db.databaseName = value;
                            },
                          ),
                        ),
                      ],
                    ),
                    SettingsCategory(
                      title: "Paramêtros Painel",
                      icon: Icons.table_view,
                      iconStyle: IconStyle(),
                      // expansible: false,
                      child: [
                        SettingsItem(
                          child: SettingRowTextField(
                            title: "Consulta SQL:",
                            subtitle:
                                'Lebre-se de otimizar sua consulta.\nNão é necessário declarar as colunas, apenas o (SELECT * FROM) já é suficiente.',
                            placeholder: 'Query SQL',
                            enabled: allowEdit,
                            initialValue: Settings.panel.query,
                            maxLines: 5,
                            onChange: (value) {
                              Settings.panel.query = value;
                            },
                          ),
                        ),
                        SettingsItem(
                          child: SettingRowNumber(
                            title: "Intervalo de Atualização:",
                            subtitle:
                                "Tenha em mente que dependendo da query, o intervalo pode não ser suficiente.",

                            enabled: allowEdit,
                            initialValue: Settings.panel.interval,
                            minValue: 1,
                            maxValue: 60,
                            // maxLines: 5,
                            onChange: (value) {
                              Settings.panel.interval = value;
                            },
                          ),
                        ),
                        SettingsItem(
                          child: SettingRowDropDown(
                            title: "Tipo de Intervalo:",
                            enabled: allowEdit,
                            items: Settings.panel.availableTypes,
                            selectedValue: Settings.panel.typeInterval,
                            onChange: (value) {
                              Settings.panel.typeInterval = value;
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            );
            //   ),
            // );
          },
        ),
      ],
    );
  }
}
