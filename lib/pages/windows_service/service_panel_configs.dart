import 'package:data7_panel/components/settings/settings.dart';
import 'package:data7_panel/components/settings/settings_textfield.dart';
import 'package:data7_panel/main.dart';
import 'package:data7_panel/pages/windows_service/panels.dart';
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
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Consumer<WinServiceSettings>(
          builder: (context, winService, c) {
            bool allowEdit = winService.status == StatusService.stopped ||
                winService.status == StatusService.unistalled;
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
                            items: settings.database.availableRdbms,
                            selectedValue: settings.database.rdbms,
                            onChange: (value) {
                              settings.database.rdbms = value;
                            },
                          ),
                        ),
                        SettingsItem(
                          child: SettingRowTextField(
                            title: "Usuário:",
                            enabled: allowEdit,
                            required: true,
                            initialValue: settings.database.user,
                            onChange: (value) {
                              settings.database.user = value;
                            },
                          ),
                        ),
                        SettingsItem(
                          child: SettingRowTextField(
                            title: "Senha:",
                            enabled: allowEdit,
                            initialValue: settings.database.pass,
                            isPassword: true,
                            required: true,
                            onChange: (value) {
                              settings.database.pass = value;
                            },
                          ),
                        ),
                        SettingsItem(
                          child: SettingRowTextField(
                            title: "Servidor",
                            enabled: allowEdit,
                            required: true,
                            initialValue: settings.database.server,
                            onChange: (value) {
                              settings.database.server = value;
                            },
                          ),
                        ),
                        SettingsItem(
                          child: SettingRowTextField(
                            title: "Porta",
                            enabled: allowEdit,
                            required: true,
                            initialValue: settings.database.port,
                            inputType: TextInputType.number,
                            onChange: (value) {
                              settings.database.port = value;
                            },
                          ),
                        ),
                        SettingsItem(
                          child: SettingRowTextField(
                            title: "Base de Dados",
                            enabled: allowEdit,
                            required: true,
                            initialValue: settings.database.databaseName,
                            onChange: (value) {
                              settings.database.databaseName = value;
                            },
                          ),
                        ),
                        SettingsItem(
                          child: SettingRowTextField(
                            title: "Schema DB",
                            subtitle:
                                'Usado em caso de conexão com Linked Server, onde a Database é a master, caso contrário deixe em branco. \nEx: [SYBASE].[DATABASENAME].[SCHEMA]',
                            enabled: allowEdit,
                            required: false,
                            initialValue: settings.database.databaseSchema,
                            onChange: (value) {
                              settings.database.databaseSchema = value;
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Panels()
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
