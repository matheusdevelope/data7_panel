import 'dart:io';

import 'package:data7_panel/components/dialog_alert.dart';
import 'package:data7_panel/pages/panel/panel.dart';
import 'package:data7_panel/pages/windows_service/index.dart';
import 'package:data7_panel/providers/settings_model.dart';
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
  TextEditingController textController =
      TextEditingController(text: 'http://192.168.0.1:3546');
  CustomDialogAlert alert = CustomDialogAlert();
  int currentTab = 0;

  void _saveAndOpenPanel() {
    if (textController.text.isNotEmpty && textController.text.length > 10) {
      Settings.panel.url = textController.text;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return PanelPage(url: textController.text);
          },
        ),
      );
    } else {
      alert.show(
          context, 'Atenção', 'Para prosseguir informe um endereço válido.');
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    await Settings.panel.initialize();
    setState(
      () {
        String value = Settings.panel.url;
        if (value.isNotEmpty) {
          textController.text = value;
        }

        if (Settings.panel.openAutomatic) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return PanelPage(url: value);
              },
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModel>(
      builder: (context, ThemeModel theme, child) {
        return Scaffold(
          body: currentTab == 0
              ? Center(
                  child: Container(
                    margin: const EdgeInsets.all(24),
                    constraints:
                        const BoxConstraints(minWidth: 300, maxWidth: 700),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                        Column(
                          children: <Widget>[
                            TextField(
                              textInputAction: TextInputAction.next,
                              controller: textController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'URL Servidor',
                                contentPadding: EdgeInsets.all(8),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              : Center(
                  child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1000),
                      child: currentTab == 1
                          ? const Configurations()
                          : currentTab == 2
                              ? ServicePanel()
                              : null),
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
