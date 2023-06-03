import 'package:data7_panel/pages/windows_service/service_panel_configs.dart';
import 'package:data7_panel/pages/windows_service/windows_service.dart';
import 'package:data7_panel/providers/settings_model.dart';
import 'package:flutter/material.dart';

class ServicePanel extends StatefulWidget {
  const ServicePanel({
    super.key,
  });
  @override
  State<ServicePanel> createState() => _ServicePanelState();
}

class _ServicePanelState extends State<ServicePanel> {
  bool initialized = false;
  Future<void> initializeValues() async {
    if (!initialized) {
      await Settings.notifications.initialize();
      await Settings.db.initialize();
      await Settings.panel.initialize();
      await Settings.winService.initialize();
      setState(() {
        initialized = true;
      });
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
          return Row(
            children: [ServicePanelConfigs(), WindowsServiceManagerUI()],
          );
        }
      },
    );
  }
}
