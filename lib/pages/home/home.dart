import 'dart:io';
import 'package:data7_panel/components/dialog_alert.dart';
import 'package:data7_panel/pages/panel/panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:math' as math;

import '../../providers/theme_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late SharedPreferences prefs;
  TextEditingController textController =
      TextEditingController(text: 'http://192.168.0.1:3546');
  CustomDialogAlert alert = CustomDialogAlert();

  void _saveAndOpenPanel() {
    if (textController.text.isNotEmpty && textController.text.length > 10) {
      prefs.setString('local_url', textController.text);
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
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);

    super.initState();
    getData();
  }

  getData() async {
    prefs = await SharedPreferences.getInstance();
    setState(
      () {
        String? value = prefs.getString('local_url');
        if (value != null) {
          textController.text = value;
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
      builder: (context, ThemeModel themeNotifier, child) {
        return Scaffold(
          body: Center(
            child: Container(
              margin: const EdgeInsets.all(24),
              constraints: const BoxConstraints(minWidth: 300, maxWidth: 700),
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
                        // autofocus: true,
                        textInputAction: TextInputAction.next,
                        controller: textController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Endereço do Servidor',
                          contentPadding: EdgeInsets.all(8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            tooltip: "Abrir Painel",
            heroTag: "Abrir Painel",
            backgroundColor: Colors.white,
            onPressed: _saveAndOpenPanel,
            child: const Icon(
              Icons.exit_to_app,
              color: Color(0xFF006B98),
            ),
          ),
        );
      },
    );
  }
}
