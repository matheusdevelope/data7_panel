import 'package:data7_panel/infra/services/Interfaces/windows_service.dart';
import 'package:data7_panel/infra/services/Models/windows_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;

class WinServiceConsumer extends StatelessWidget {
  final winService = getIt.get<IWindowsService>();
  final service = WindowsService(
    name: 'Meu Serviço',
    path:
        'C:\\Users\\emers\\AppData\\Roaming\\com.example\\data7_panel\\service_runner\\srvstart.exe svc Data7Panel -c C:\\Users\\emers\\AppData\\Roaming\\com.example\\data7_panel\\service_runner\\SRVSTART.ini',
    description: 'Teste de serviço',
    displayName: '01 - Meu Serviço - Display Name',
    startupType: StartupType.Automatic,
  );
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final displayNameController = TextEditingController();
  final statusController = TextEditingController();
  int count = 0;
  WinServiceConsumer({super.key}) {
    nameController.text = service.name;
    descriptionController.text = service.description;
    displayNameController.text = service.displayName;
    winService.status(service).then((value) {
      statusController.text = value.name;
    });

    winService.on(WindowsServiceEvent.statusChange, _handleEvent);
    winService.startMonitorStatusChange(service, 2000);
  }

  void _handleEvent(WindowsService service) {
    statusController.text = service.status.name;
  }

  _loadService() {
    service.name = nameController.text;
    service.description = descriptionController.text;
    service.displayName = displayNameController.text;
    service.startupType = StartupType.values.firstWhere(
        (element) => element.name == statusController.text,
        orElse: () => StartupType.Automatic);
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
            controller: statusController,
          ),
          const Padding(
            padding: EdgeInsets.only(top: 100),
          ),
          TextButton(
            onPressed: () async {
              _loadService();
              (await winService.load(nameController.text));
            },
            child: const Text('Carregar'),
          ),
          TextButton(
            onPressed: () async {
              _loadService();
              await winService.install(service);
            },
            child: const Text('Instalar'),
          ),
          TextButton(
            onPressed: () async {
              _loadService();
              await winService.uninstall(service);
            },
            child: const Text('Desinstalar'),
          ),
          TextButton(
            onPressed: () async {
              _loadService();
              await winService.start(service);
            },
            child: const Text('Iniciar'),
          ),
          TextButton(
            onPressed: () async {
              _loadService();
              await winService.stop(service);
            },
            child: const Text('Parar'),
          ),
          TextButton(
            onPressed: () async {
              _loadService();
              await winService.restart(service);
            },
            child: const Text('Reiniciar'),
          ),
          TextButton(
            onPressed: () async {
              _loadService();
              final status = await winService.status(service);
              statusController.text = status.name;
            },
            child: const Text('Status'),
          ),
          TextButton(
            onPressed: () async {
              _loadService();
              await winService.update(service);
            },
            child: const Text('Atualizar'),
          ),
        ],
      ),
    );
  }
}
