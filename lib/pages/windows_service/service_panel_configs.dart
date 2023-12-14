import 'package:data7_panel/components/settings/settings.dart';
import 'package:data7_panel/components/settings/settings_textfield.dart';
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
                            required: true,
                            onChange: (value) {
                              Settings.db.pass = value;
                            },
                          ),
                        ),
                        SettingsItem(
                          child: SettingRowTextField(
                            title: "Servidor",
                            enabled: allowEdit,
                            required: true,
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
                            required: true,
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
                            required: true,
                            initialValue: Settings.db.databaseName,
                            onChange: (value) {
                              Settings.db.databaseName = value;
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
                            initialValue: Settings.db.databaseSchema,
                            onChange: (value) {
                              Settings.db.databaseSchema = value;
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
