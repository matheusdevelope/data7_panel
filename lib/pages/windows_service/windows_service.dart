import 'package:data7_panel/components/outilined_buttom.dart';
import 'package:data7_panel/components/settings/settings.dart';
import 'package:data7_panel/components/settings/settings_textfield.dart';
import 'package:flutter/material.dart';

import '../../components/dropdown.dart';

class WindowsService extends StatefulWidget {
  const WindowsService({
    super.key,
  });
  @override
  State<WindowsService> createState() => _WindowsServiceState();
}

class _WindowsServiceState extends State<WindowsService> {
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
                  title: 'Paramêtros',
                  children: [
                    SettingsCategory(
                      title: 'Dados de Conexão',
                      icon: Icons.account_tree_outlined,
                      iconStyle: IconStyle(),
                      child: [
                        SettingsItem(
                          child: SettingRowDropDown(
                            title: "RDBMS:",
                            items: const {
                              "mssql": "SQL Server",
                              "sybase": "Sybase SQL Anywhere"
                            },
                            selectedValue: "mssql",
                            onChange: (value) {
                              print(value);
                            },
                          ),
                        ),
                        SettingsItem(
                          child: SettingRowTextField(
                            title: "Usuário:",
                            initialValue: "",
                            onChange: (value) {
                              print(value);
                            },
                          ),
                        ),
                        SettingsItem(
                          child: SettingRowTextField(
                            title: "Senha:",
                            initialValue: "",
                            isPassword: true,
                            onChange: (value) {
                              print(value);
                            },
                          ),
                        ),
                        SettingsItem(
                          child: SettingRowTextField(
                            title: "Servidor",
                            initialValue: "",
                            onChange: (value) {
                              print(value);
                            },
                          ),
                        ),
                        SettingsItem(
                          child: SettingRowTextField(
                            title: "Porta",
                            initialValue: "",
                            inputType: TextInputType.number,
                            onChange: (value) {
                              print(value);
                            },
                          ),
                        ),
                        SettingsItem(
                          child: SettingRowTextField(
                            title: "Base de Dados",
                            initialValue: "",
                            onChange: (value) {
                              print(value);
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
                            initialValue: "",
                            maxLines: 5,
                            onChange: (value) {
                              print(value);
                            },
                          ),
                        ),
                        SettingsItem(
                          child: SettingRowDropDown(
                            title: "Tipo de Intervalo:",
                            items: const {
                              "sec": "Segundo(s)",
                              "min": "Minuto(s)",
                              "hour": "Hora(s)"
                            },
                            selectedValue: "sec",
                            onChange: (value) {
                              print(value);
                            },
                          ),
                        ),
                        SettingsItem(
                          child: SettingRowNumber(
                            title: "Intervalo de Atualização:",
                            subtitle:
                                "Tenha em mente que dependendo da query, o intervalo pode não ser suficiente.",
                            initialValue: 5,
                            minValue: 1,
                            maxValue: 60,
                            // maxLines: 5,
                            onChange: (value) {
                              print(value);
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                SettingsGroup(title: "Serviço Windows", children: [
                  SettingsCategory(
                    child: [
                      SettingsItem(
                        child: SettingRowTextField(
                          title: 'Nome do Serviço',
                          initialValue: '',
                          onChange: (value) {},
                        ),
                      ),
                      SettingsItem(
                        child: CustomOutilinedButton(
                          label: "Instalar Serviço",
                          onPress: () {},
                        ),
                      ),
                      SettingsItem(
                        child: CustomOutilinedButton(
                          label: "Iniciar Serviço",
                          onPress: () {},
                        ),
                      ),
                      SettingsItem(
                        child: CustomOutilinedButton(
                          label: "Parar Serviço",
                          onPress: () {},
                        ),
                      ),
                      SettingsItem(
                        child: CustomOutilinedButton(
                          label: "Desinstalar Serviço",
                          onPress: () {},
                        ),
                      ),
                    ],
                  )
                ])
              ],
            ),
          );
        }
      },
    );
  }
}
