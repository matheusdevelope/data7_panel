import 'package:data7_panel/UI/components/outilined_buttom.dart';
import 'package:data7_panel/UI/components/settings/settings.dart';
import 'package:data7_panel/UI/components/settings/settings_textfield.dart';
import 'package:data7_panel/core/infra/services/Interfaces/windows_firewall_rules.dart';
import 'package:data7_panel/core/infra/services/Interfaces/windows_service.dart';
import 'package:data7_panel/core/infra/services/Models/windows_service.dart';
import 'package:data7_panel/core/providers/WindowsService/windows_service_model.dart';
import 'package:data7_panel/dependecy_injection.dart';
import 'package:data7_panel/main.dart';
import 'package:flutter/material.dart';

class WindowsServiceCategory extends StatefulWidget {
  const WindowsServiceCategory({super.key});
  @override
  State<WindowsServiceCategory> createState() => _WindowsServiceCategoryState();
}

class _WindowsServiceCategoryState extends State<WindowsServiceCategory> {
  bool loading = true;
  bool executableSync = false;
  bool initialized = false;
  final serviceManager = DI.get<IWindowsService>();
  final firewallManager = DI.get<IWindowsFirewallRule>();

  void _install() async {
    setState(() {
      loading = true;
    });
    // await serviceManager.install(WindowsService(
    //   name: settings.winService.name,
    // ));
    // await firewall(settings).addInboundAndOutbound();
    // _getStatus(settings);
  }

  _uninstall() async {
    // setState(() {
    //   loading = true;
    // });
    // await WindowsServicePs(settings.name).delete();
    // await firewall(settings).remove();
    // _getStatus(settings);
  }

  _start() async {
    // setState(() {
    //   loading = true;
    // });
    // await FileWindowService()
    //     .create(context, settings.name, paramsWinService(settings));
    // await WindowsServicePs(settings.name).start();
    // _getStatus(settings);
  }

  _stop() async {
    // setState(() {
    //   loading = true;
    // });
    // await WindowsServicePs(settings.name).stop();
    // _getStatus(settings);
  }

  _getStatus() async {
    // StatusLoop().startLoop(
    //   settings.name,
    //   (status) {
    //     settings.status = status;
    //     setState(() {
    //       loading = false;
    //       if (!initialized) {
    //         initialized = true;
    //       }
    //     });
    //   },
    // );
  }

  _onStatusChange(WindowsService settings) async {
    settings.status = settings.status;
    setState(() {
      loading = false;
      if (!initialized) {
        initialized = true;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      serviceManager.on(WindowsServiceEvent.statusChange, _onStatusChange);
    });
  }

  @override
  void dispose() {
    super.dispose();
    serviceManager.off(WindowsServiceEvent.statusChange, _onStatusChange);
  }

  @override
  Widget build(BuildContext context) {
    bool allowEdit = settings.winService.status == StatusService.stopped ||
        settings.winService.status == StatusService.unistalled;
    return SettingsGroup(
      title: "Serviço Windows",
      children: [
        SettingsCategory(
          child: [
            settings.winService.name.isEmpty
                ? const Text("Loading...")
                : SettingsItem(
                    child: SettingRowTextField(
                      title: 'Nome do Serviço',
                      subtitle:
                          "Para a alterar o serviço deve ser reinstalado.",
                      enabled: settings.winService.status ==
                          StatusService.unistalled,
                      initialValue: settings.winService.name,
                      required: true,
                      validations: [
                        (value) {
                          if (value.contains(' ')) {
                            return "O nome do serviço não pode conter espaços.";
                          }
                        }
                      ],
                      onChange: (value) {
                        settings.winService.name = value;
                      },
                    ),
                  ),
            settings.winService.port.toString().isEmpty
                ? const Text("Loading...")
                : SettingsItem(
                    child: SettingRowTextField(
                      title: 'Porta HTTP',
                      subtitle: "Porta exposta pelo serviço windows.",
                      enabled: allowEdit,
                      initialValue: settings.winService.port.toString(),
                      required: true,
                      inputType: TextInputType.number,
                      onChange: (value) {
                        settings.winService.port = int.parse(value);
                      },
                    ),
                  ),
            CustomOutilinedButton(
              label: "Instalar Serviço",
              enabled: !loading &&
                  executableSync &&
                  (settings.winService.status == StatusService.unistalled &&
                      settings.winService.name.isNotEmpty),
              onPress: () {
                _install();
              },
            ),
            CustomOutilinedButton(
              label: "Iniciar Serviço",
              enabled: !loading &&
                  executableSync &&
                  (settings.winService.status == StatusService.stopped ||
                      settings.winService.status == StatusService.paused),
              onPress: () {
                _start();
              },
            ),
            CustomOutilinedButton(
              label: "Parar Serviço",
              enabled: !loading &&
                  executableSync &&
                  settings.winService.status == StatusService.running,
              onPress: () {
                _stop();
              },
            ),
            CustomOutilinedButton(
              label: "Desinstalar Serviço",
              enabled: !loading &&
                  executableSync &&
                  settings.winService.status == StatusService.stopped,
              onPress: () {
                _uninstall();
              },
            ),
            if (!loading)
              CustomOutilinedButton(
                label:
                    "Status: ${settings.winService.status.name.toUpperCase()}",
                enabled: loading,
                onPress: () {
                  _getStatus();
                },
              ),
            if (loading) const Center(child: CircularProgressIndicator()),
          ],
        )
      ],
    );
  }
}
