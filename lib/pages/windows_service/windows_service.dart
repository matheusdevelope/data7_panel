import 'package:data7_panel/components/download_box.dart';
import 'package:data7_panel/components/outilined_buttom.dart';
import 'package:data7_panel/components/settings/settings.dart';
import 'package:data7_panel/components/settings/settings_textfield.dart';
import 'package:data7_panel/services/firewall_rules.dart';
import 'package:data7_panel/services/windows_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WindowsServiceManagerUI extends StatefulWidget {
  WindowsServiceManagerUI({
    super.key,
  });
  @override
  State<WindowsServiceManagerUI> createState() =>
      _WindowsServiceManagerUIState();
}

class _WindowsServiceManagerUIState extends State<WindowsServiceManagerUI> {
  bool loading = true;
  bool executableSync = false;
  StatusService serviceStatus = StatusService.startPending;
  bool initialized = false;

  Future<void> initializeValues(WinServiceSettings settings) async {
    if (!initialized) {
      serviceStatus = (await WindowsServicePs(settings.name).status());
      setState(() {
        initialized = true;
        loading = false;
      });
    }
  }

  FirewallRule firewall(WinServiceSettings settings) {
    return FirewallRule(
        displayName: settings.name,
        description:
            "Libera a porta do servidor HTTP para que o Painel possa obter os dados",
        localPort: settings.port,
        program: settings.executable);
  }

  Map<String, String> paramsWinService(WinServiceSettings settings) {
    return {
      'server_port': settings.port.toString(),
      'database': Settings.db.rdbms,
      'host': Settings.db.server,
      'port': Settings.db.port,
      'dbname': Settings.db.databaseName,
      'user': Settings.db.user,
      'pass': Settings.db.pass,
      'query': '"${Settings.panel.query}"',
      'time_refresh': (Settings.panel.typeInterval == 'min'
              ? (Settings.panel.interval * 60 * 1000)
              : Settings.panel.typeInterval == 'hour'
                  ? Settings.panel.interval * 60 * 60 * 1000
                  : Settings.panel.interval * 1000)
          .toString(),
    };
  }

  void _install(WinServiceSettings settings) async {
    setState(() {
      loading = true;
    });
    String command = await FileWindowService()
        .create(context, settings.name, paramsWinService(settings));
    await WindowsServicePs(settings.name).create(command);
    await firewall(settings).addInboundAndOutbound();
    _getStatus(settings);
  }

  _uninstall(WinServiceSettings settings) async {
    setState(() {
      loading = true;
    });
    await WindowsServicePs(settings.name).delete();
    await firewall(settings).remove();
    _getStatus(settings);
  }

  _start(WinServiceSettings settings) async {
    setState(() {
      loading = true;
    });
    await FileWindowService()
        .create(context, settings.name, paramsWinService(settings));
    await WindowsServicePs(settings.name).start();
    _getStatus(settings);
  }

  _stop(WinServiceSettings settings) async {
    setState(() {
      loading = true;
    });
    await WindowsServicePs(settings.name).stop();
    _getStatus(settings);
  }

  _getStatus(WinServiceSettings settings) async {
    setState(() {
      loading = true;
    });
    StatusLoop().startLoop(
      settings.name,
      (status) {
        settings.status = status;
        setState(() {
          loading = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // initializeValues();

    return Consumer<WinServiceSettings>(
      builder: (context, settings, c) {
        initializeValues(settings);
        return SizedBox(
          width: 500,
          height: 500,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
            child: ListView(
              children: [
                SettingsGroup(
                  title: "Serviço Windows",
                  children: [
                    SettingsCategory(
                      child: [
                        DownloadBox(
                          title: "Dependências",
                          subtitle:
                              "Arquivos necessários para o funcionamento do serviço.",
                          onDownload: (progress) {
                            if (progress >= 100) {
                              setState(() {
                                executableSync = true;
                              });
                            }
                          },
                        ),
                        SettingsItem(
                          child: SettingRowTextField(
                            title: 'Nome do Serviço',
                            subtitle:
                                "Para a alterar o serviço deve ser reinstalado.",
                            enabled:
                                settings.status == StatusService.unistalled,
                            initialValue: settings.name,
                            required: true,
                            validations: [
                              (value) {
                                if (value.contains(' ')) {
                                  return "O nome do serviço não pode conter espaços.";
                                }
                              }
                            ],
                            onChange: (value) {
                              settings.name = value;
                            },
                          ),
                        ),
                        CustomOutilinedButton(
                          label: "Instalar Serviço",
                          enabled: !loading &&
                              executableSync &&
                              (settings.status == StatusService.unistalled &&
                                  settings.name.isNotEmpty),
                          onPress: () {
                            _install(settings);
                          },
                        ),
                        CustomOutilinedButton(
                          label: "Iniciar Serviço",
                          enabled: !loading &&
                              executableSync &&
                              (settings.status == StatusService.stopped ||
                                  settings.status == StatusService.paused),
                          onPress: () {
                            _start(settings);
                          },
                        ),
                        CustomOutilinedButton(
                          label: "Parar Serviço",
                          enabled: !loading &&
                              executableSync &&
                              settings.status == StatusService.running,
                          onPress: () {
                            _stop(settings);
                          },
                        ),
                        CustomOutilinedButton(
                          label: "Desinstalar Serviço",
                          enabled: !loading &&
                              executableSync &&
                              settings.status == StatusService.stopped,
                          onPress: () {
                            _uninstall(settings);
                          },
                        ),
                        if (!loading)
                          CustomOutilinedButton(
                            label:
                                "Status: ${settings.status.name.toUpperCase()}",
                            enabled: loading,
                            onPress: () {
                              _getStatus(settings);
                            },
                          ),
                        if (loading)
                          const Center(child: CircularProgressIndicator()),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
