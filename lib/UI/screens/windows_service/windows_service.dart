import 'package:data7_panel/UI/screens/windows_service/categories/windows_service_category.dart';
import 'package:data7_panel/UI/screens/windows_service/categories/windows_service_connection_params_category.dart';
import 'package:flutter/material.dart';

class WindowsServiceScreen extends StatelessWidget {
  const WindowsServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: ListView(
        children: const [
          WindowsServiceConnectionParamsCategory(),
          WindowsServiceCategory(),
        ],
      ),
    );
  }
}
