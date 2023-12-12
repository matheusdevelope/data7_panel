import 'package:data7_panel/UI/components/settings/settings.dart';
import 'package:data7_panel/UI/components/settings/settings_textfield.dart';
import 'package:data7_panel/core/providers/WindowsService/windows_service_model.dart';
import 'package:data7_panel/main.dart';
import 'package:flutter/material.dart';

class WindowsServiceConnectionParamsCategory extends StatelessWidget {
  const WindowsServiceConnectionParamsCategory({super.key});

  @override
  Widget build(BuildContext context) {
    bool allowEdit = settings.winService.status == StatusService.stopped ||
        settings.winService.status == StatusService.unistalled;
    return SettingsGroup(
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
                required: true,
                validations: [
                  (value) => value.trim().length > 5
                      ? null
                      : "A query precisa ter pelo menos 5 caracteres.",
                ],
                initialValue: settings.panel.query,
                maxLines: 5,
                onChange: (value) {
                  settings.panel.query = value;
                },
              ),
            ),
            SettingsItem(
              child: SettingRowNumber(
                title: "Intervalo de Atualização:",
                subtitle:
                    "Tenha em mente que dependendo da query, o intervalo pode não ser suficiente.",

                enabled: allowEdit,

                initialValue: settings.panel.interval,
                minValue: 1,
                maxValue: 60,
                // maxLines: 5,
                onChange: (value) {
                  settings.panel.interval = value;
                },
              ),
            ),
            SettingsItem(
              child: SettingRowDropDown(
                title: "Tipo de Intervalo:",
                enabled: allowEdit,
                items: settings.panel.availableTypes,
                selectedValue: settings.panel.typeInterval,
                onChange: (value) {
                  settings.panel.typeInterval = value;
                },
              ),
            ),
          ],
        )
      ],
    );
  }
}
