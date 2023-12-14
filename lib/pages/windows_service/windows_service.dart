import 'package:data7_panel/components/download_box.dart';
import 'package:data7_panel/components/outilined_buttom.dart';
import 'package:data7_panel/components/settings/settings.dart';
import 'package:data7_panel/components/settings/settings_textfield.dart';
import 'package:data7_panel/services/firewall_rules.dart';
import 'package:data7_panel/services/windows_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WindowsServiceManagerUI extends StatefulWidget {
  const WindowsServiceManagerUI({super.key});
  @override
  State<WindowsServiceManagerUI> createState() =>
      _WindowsServiceManagerUIState();
}

class _WindowsServiceManagerUIState extends State<WindowsServiceManagerUI> {
  bool loading = true;
  bool executableSync = false;
  bool initialized = false;

  Future<void> initializeValues() async {
    if (!initialized) {
      await Settings.winService.initialize();
      _getStatus(Settings.winService);
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
      'PORT': settings.port.toString(),
      // 'database': Settings.db.rdbms,
      'DB_HOST': Settings.db.server,
      'DB_PORT': Settings.db.port,
      'DB_SCHEMA': Settings.db.databaseSchema,
      'DB_NAME': Settings.db.databaseName,
      'DB_USER': Settings.db.user,
      'DB_PASSWORD': Settings.db.pass,
      // 'query': '"${Settings.panel.query}"',
      // 'time_refresh': (Settings.panel.typeInterval == 'min'
      //         ? (Settings.panel.interval * 60 * 1000)
      //         : Settings.panel.typeInterval == 'hour'
      //             ? Settings.panel.interval * 60 * 60 * 1000
      //             : Settings.panel.interval * 1000)
      //     .toString(),
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
    StatusLoop().startLoop(
      settings.name,
      (status) {
        settings.status = status;
        setState(() {
          loading = false;
          if (!initialized) {
            initialized = true;
          }
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initializeValues();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Consumer<WinServiceSettings>(
          builder: (context, settings, c) {
            // initializeValues(settings);
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
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
                        settings.name.isEmpty
                            ? const Text("Loading...")
                            : SettingsItem(
                                child: SettingRowTextField(
                                  title: 'Nome do Serviço',
                                  subtitle:
                                      "Para a alterar o serviço deve ser reinstalado.",
                                  enabled: settings.status ==
                                      StatusService.unistalled,
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
                        settings.port.toString().isEmpty
                            ? const Text("Loading...")
                            : SettingsItem(
                                child: SettingRowTextField(
                                  title: 'Porta HTTP',
                                  subtitle:
                                      "Porta exposta pelo serviço windows.",
                                  enabled: settings.status ==
                                          StatusService.unistalled ||
                                      settings.status == StatusService.stopped,
                                  initialValue: settings.port.toString(),
                                  required: true,
                                  inputType: TextInputType.number,
                                  onChange: (value) {
                                    settings.port = int.parse(value);
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
            );
          },
        ),
      ],
    );
  }
}
