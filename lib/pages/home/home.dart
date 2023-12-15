import 'dart:io';

import 'package:data7_panel/components/dialog_alert.dart';
import 'package:data7_panel/components/panels_selector.dart';
import 'package:data7_panel/main.dart';
import 'package:data7_panel/pages/panel/panel.dart';
import 'package:data7_panel/pages/windows_service/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_model.dart';
import '../configuration/configuration.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController textController = TextEditingController(
      text: settings.panel.url.isNotEmpty
          ? settings.panel.url
          : 'http://192.168.0.1:3546');
  CustomDialogAlert alert = CustomDialogAlert();
  int currentTab = 0;
  bool showPanels = true;

  void _saveAndOpenPanel() async {
    if (textController.text.isNotEmpty && textController.text.length > 10) {
      settings.panel.url = textController.text;
    } else {
      alert.show(
          context, 'Atenção', 'Para prosseguir informe um endereço válido.');
      return;
    }

    if (settings.panel.joined.isEmpty) {
      alert.show(context, 'Atenção',
          'Para prosseguir, selecione pelo menos um painel.');
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        maintainState: true,
        builder: (context) {
          return PanelPage(url: textController.text);
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (settings.panel.openAutomatic) _saveAndOpenPanel();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModel>(
      builder: (context, ThemeModel theme, child) {
        return Scaffold(
          body: Center(
            child: Container(
                constraints:
                    const BoxConstraints(minWidth: 300, maxWidth: 1000),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: currentTab == 0
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Padding(
                              padding: EdgeInsets.only(bottom: 8 * 2),
                              child: Text(
                                'Painel Data7',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            TextField(
                              textInputAction: TextInputAction.next,
                              controller: textController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'URL Servidor',
                                contentPadding: EdgeInsets.all(8),
                              ),
                            ),
                            const SizedBox(height: 16),
                            PanelsSelector(url: textController.text)
                          ],
                        )
                      : currentTab == 1
                          ? const Configurations()
                          : currentTab == 2
                              ? const ServicePanel()
                              : null,
                )),
          ),
          floatingActionButton: currentTab == 0
              ? FloatingActionButton(
                  tooltip: "Abrir Painel",
                  heroTag: "Abrir Painel",
                  backgroundColor: Colors.white,
                  onPressed: _saveAndOpenPanel,
                  child: const Icon(
                    Icons.exit_to_app,
                    color: Color(0xFF006B98),
                  ),
                )
              : null,
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentTab,
            // unselectedFontSize: theme.fontSizeMenuPanel,
            // selectedFontSize: theme.fontSizeMenuPanel + 2,
            onTap: (value) {
              setState(() {
                currentTab = value;
              });
            },
            items: [
              const BottomNavigationBarItem(
                label: "Home",
                activeIcon: Icon(
                  Icons.home,
                ),
                icon: Icon(
                  Icons.home,
                  color: Colors.grey,
                ),
              ),
              const BottomNavigationBarItem(
                label: "Configurações",
                activeIcon: Icon(
                  Icons.settings,
                ),
                icon: Icon(
                  Icons.settings,
                  color: Colors.grey,
                ),
              ),
              if (Platform.isWindows)
                const BottomNavigationBarItem(
                  label: "Serviço Windows",
                  activeIcon: Icon(
                    Icons.install_desktop,
                  ),
                  icon: Icon(
                    Icons.install_desktop,
                    color: Colors.grey,
                  ),
                )
            ],
          ),
        );
      },
    );
  }
}
