import 'package:data7_panel/infra/services/Interfaces/windows_firewall_rules.dart';
import 'package:data7_panel/infra/services/Models/windows_firewall_rules.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;

class WinFirewalConsumer extends StatelessWidget {
  final winFirewal = getIt.get<IWindowsFirewallRule>();
  final service = WindowsFirewallRule.create(
    displayName: '01 - Teste',
    direction: WindowsFirewallDirection.Outbound,
    action: WindowsFirewallAction.Allow,
    protocol: WindowsFirewallProtocol.TCP,
    description: 'Teste',
    localPort: 3549,
    // program: 'C:\\Program Files\\nodejs\\node.exe',
  );
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final displayNameController = TextEditingController();
  final portController = TextEditingController();
  final statusController = TextEditingController();
  int count = 0;
  WinFirewalConsumer({super.key}) {
    nameController.text = service.name;
    descriptionController.text = service.description;
    displayNameController.text = service.displayName;
    portController.text = service.localPort.toString();
    statusController.text = service.enabled.toString();
  }

  _loadService() {
    service.name = nameController.text;
    service.description = descriptionController.text;
    service.displayName = displayNameController.text;
    service.localPort = int.tryParse(portController.text) ?? 0;
    service.enabled = statusController.text == 'true' ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          TextField(
            controller: nameController,
          ),
          TextField(
            controller: displayNameController,
          ),
          TextField(
            controller: descriptionController,
          ),
          TextField(
            controller: portController,
          ),
          TextField(
            controller: statusController,
          ),
          const Padding(
            padding: EdgeInsets.only(top: 100),
          ),
          TextButton(
            onPressed: () async {
              _loadService();
              print((await winFirewal.load(nameController.text))
                  .map((e) => e.toJson())
                  .toList());
            },
            child: const Text('Carregar'),
          ),
          TextButton(
            onPressed: () async {
              _loadService();
              await winFirewal.add(service);
            },
            child: const Text('Instalar'),
          ),
          TextButton(
            onPressed: () async {
              _loadService();
              await winFirewal.remove(service);
            },
            child: const Text('Desinstalar'),
          ),
          TextButton(
            onPressed: () async {
              _loadService();
              await winFirewal.enable(service);
            },
            child: const Text('Ativar'),
          ),
          TextButton(
            onPressed: () async {
              _loadService();
              await winFirewal.disable(service);
            },
            child: const Text('Desativar'),
          ),
          TextButton(
            onPressed: () async {
              _loadService();
              await winFirewal.update(service);
            },
            child: const Text('Atualizar'),
          ),
        ],
      ),
    );
  }
}
