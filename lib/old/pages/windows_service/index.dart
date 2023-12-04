import 'package:data7_panel/old/pages/windows_service/service_panel_configs.dart';
import 'package:data7_panel/old/pages/windows_service/windows_service.dart';
import 'package:flutter/material.dart';

class ServicePanel extends StatefulWidget {
  const ServicePanel({
    super.key,
  });
  @override
  State<ServicePanel> createState() => _ServicePanelState();
}

class _ServicePanelState extends State<ServicePanel> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, constraints) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: constraints.maxWidth / 2,
            child: const ServicePanelConfigs(),
          ),
          SizedBox(
            width: constraints.maxWidth / 2,
            child: const WindowsServiceManagerUI(),
          ),
        ],
      );
    });
  }
}
