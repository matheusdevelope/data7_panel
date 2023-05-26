import 'package:data7_panel/components/download_box.dart';
import 'package:data7_panel/components/outilined_buttom.dart';
import 'package:data7_panel/components/settings/settings.dart';
import 'package:data7_panel/components/settings/settings_textfield.dart';
import 'package:data7_panel/pages/windows_service/mount_window_service.dart';
import 'package:data7_panel/services/firewall_rules.dart';
import 'package:data7_panel/services/powershel.dart';
import 'package:flutter/material.dart';

class WindowsService extends StatefulWidget {
  const WindowsService({
    super.key,
  });
  @override
  State<WindowsService> createState() => _WindowsServiceState();
}

class _WindowsServiceState extends State<WindowsService> {
  late StatusService serviceStatus;
  bool initialized = false;
  Future<void> initializeValues() async {
    if (!initialized) {
      await Settings.notifications.initialize();
      await Settings.db.initialize();
      await Settings.panel.initialize();
      await Settings.winService.initialize();
      serviceStatus =
          (await WindowsServicePs(Settings.winService.name).status());
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initializeValues(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return const Text('Erro ao carregar as configurações');
        } else {
          bool fieldsEnabledToEdit = serviceStatus == StatusService.stopped ||
              serviceStatus == StatusService.unistalled;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
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
                            enabled: fieldsEnabledToEdit,
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
                            enabled: fieldsEnabledToEdit,
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
                            enabled: fieldsEnabledToEdit,
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
                            enabled: fieldsEnabledToEdit,
                            initialValue: Settings.db.server,
                            onChange: (value) {
                              Settings.db.server = value;
                            },
                          ),
                        ),
                        SettingsItem(
                          child: SettingRowTextField(
                            title: "Porta",
                            enabled: fieldsEnabledToEdit,
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
                            enabled: fieldsEnabledToEdit,
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
                            enabled: fieldsEnabledToEdit,
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

                            enabled: fieldsEnabledToEdit,
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
                            enabled: fieldsEnabledToEdit,
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
                SettingsGroup(
                  title: "Serviço Windows",
                  children: [
                    SettingsCategory(
                      child: [
                        SettingsItem(
                          child: SettingRowTextField(
                            title: 'Nome do Serviço',
                            subtitle:
                                "Para a alterar o serviço deve ser reinstalado.",
                            enabled: serviceStatus == StatusService.unistalled,
                            initialValue: Settings.winService.name,
                            onChange: (value) {
                              Settings.winService.name = value;
                            },
                          ),
                        ),
                        CustomOutilinedButton(
                          label: "Instalar Serviço",
                          enabled: serviceStatus == StatusService.unistalled,
                          onPress: () async {
                            String command = await FileWindowService()
                                .create(context, Settings.winService.name, {
                              'server_port':
                                  Settings.winService.port.toString(),
                              'database': Settings.db.rdbms,
                              'host': Settings.db.server,
                              'port': Settings.db.port,
                              'dbname': Settings.db.databaseName,
                              'user': Settings.db.user,
                              'pass': Settings.db.pass,
                              'query': '"${Settings.panel.query}"',
                              'time_refresh': (Settings.panel.typeInterval ==
                                          'min'
                                      ? (Settings.panel.interval * 60 * 1000)
                                      : Settings.panel.typeInterval == 'hour'
                                          ? Settings.panel.interval *
                                              60 *
                                              60 *
                                              1000
                                          : Settings.panel.interval * 1000)
                                  .toString(),
                            });
                            await WindowsServicePs(Settings.winService.name)
                                .create(command);
                            // 'C:\\servico\\srvstart.exe install Data7DispatchPanel -c C:\\servico\\SRVSTART.ini',
                            // );
                            StatusLoop().startLoop(Settings.winService.name,
                                (status) {
                              setState(() {
                                serviceStatus = status;
                              });
                            });
                          },
                        ),
                        CustomOutilinedButton(
                          label: "Iniciar Serviço",
                          enabled: serviceStatus == StatusService.stopped ||
                              serviceStatus == StatusService.paused,
                          onPress: () async {
                            await FileWindowService()
                                .create(context, Settings.winService.name, {
                              'server_port':
                                  Settings.winService.port.toString(),
                              'database': Settings.db.rdbms,
                              'host': Settings.db.server,
                              'port': Settings.db.port,
                              'dbname': Settings.db.databaseName,
                              'user': Settings.db.user,
                              'pass': Settings.db.pass,
                              'query': '"${Settings.panel.query}"',
                              'time_refresh': (Settings.panel.typeInterval ==
                                          'min'
                                      ? (Settings.panel.interval * 60 * 1000)
                                      : Settings.panel.typeInterval == 'hour'
                                          ? Settings.panel.interval *
                                              60 *
                                              60 *
                                              1000
                                          : Settings.panel.interval * 1000)
                                  .toString(),
                            });
                            await WindowsServicePs(Settings.winService.name)
                                .start();
                            StatusLoop().startLoop(Settings.winService.name,
                                (status) {
                              setState(() {
                                serviceStatus = status;
                              });
                            });
                          },
                        ),
                        CustomOutilinedButton(
                          label: "Parar Serviço",
                          enabled: serviceStatus == StatusService.running,
                          onPress: () async {
                            await WindowsServicePs(Settings.winService.name)
                                .stop();
                            StatusLoop().startLoop(Settings.winService.name,
                                (status) {
                              setState(() {
                                serviceStatus = status;
                              });
                            });
                          },
                        ),
                        CustomOutilinedButton(
                          label: "Desinstalar Serviço",
                          enabled: serviceStatus == StatusService.stopped,
                          onPress: () async {
                            await WindowsServicePs(Settings.winService.name)
                                .delete();
                            StatusLoop().startLoop(Settings.winService.name,
                                (status) {
                              setState(() {
                                serviceStatus = status;
                              });
                            });
                          },
                        ),
                        CustomOutilinedButton(
                          label: "Status Serviço: $serviceStatus",
                          enabled: true,
                          onPress: () async {
                            print(await FirewallRule.getRule("Painel Data7"));
                            StatusLoop().startLoop(
                              Settings.winService.name,
                              (status) {
                                setState(() {
                                  serviceStatus = status;
                                });
                              },
                            );
                          },
                        ),
                        CustomOutilinedButton(
                          label: "Get Rule Firewall",
                          enabled: true,
                          onPress: () async {
                            print(await FirewallRule.getRule("Painel Data7"));
                          },
                        ),
                        CustomOutilinedButton(
                          label: "Add Rule Firewall",
                          enabled: true,
                          onPress: () async {
                            print(await FirewallRule(
                                    displayName: "Painel Data7",
                                    description:
                                        "Libera a porta do servidor HTTP para que o Painel possa obter os dados",
                                    localPort: Settings.winService.port,
                                    program: await FileWindowService
                                        .getServiceExecutable())
                                .addInboundAndOutbound());
                          },
                        ),
                        CustomOutilinedButton(
                          label: "Remove Rule Firewall",
                          enabled: true,
                          onPress: () async {
                            print(await FirewallRule(
                                    displayName: "Painel Data7",
                                    description:
                                        "Libera a porta do servidor HTTP para que o Painel possa obter os dados",
                                    direction: FirewallDirection.inbound,
                                    program: "")
                                .remove());
                          },
                        ),
                        DownloadBox(
                            title: "Arquivos de Serviço",
                            subtitle:
                                "Esse processo só vai ocorrer no primeiro uso ou quando houverem novas versões disponíveis.",
                            onDownload: (progress) {}),
                      ],
                    )
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
