import 'package:data7_panel/UI/pages/home/bottom_navigation.dart';
import 'package:data7_panel/UI/screens/panel/panel.dart';
import 'package:data7_panel/UI/screens/settings/settings.dart';
import 'package:data7_panel/UI/screens/windows_service/windows_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentTab = 0;

  final List<Widget> screens = [
    const PanelScreen(),
    const SettingsScreen(),
    const WindowsServiceScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentTab],
      floatingActionButton: currentTab != 0
          ? null
          : FloatingActionButton(
              tooltip: "Abrir Painel",
              heroTag: "Abrir Painel",
              backgroundColor: Colors.white,
              child: const Icon(
                Icons.exit_to_app,
                color: Color(0xFF006B98),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/panel');
              },
            ),
      bottomNavigationBar: HomeBottomNavigationBar(
        index: currentTab,
        onTap: (index) {
          setState(() {
            currentTab = index;
          });
        },
      ),
    );
  }
}
