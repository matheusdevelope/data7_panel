import 'package:data7_panel/pages/panel/panel.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/dialogAlert.dart';

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

  void _saveAndOpenPanel() {
    if (textController.text.isNotEmpty && textController.text.length > 10) {
      prefs.setString('local_url', textController.text);
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return PanelPage(url: textController.text);
      }));
    } else {
      showAlertDialog(
          context, 'Atenção', 'Para prosseguir informe um endereço válido.');
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      String? value = prefs.getString('local_url');
      if (value != null) {
        textController.text = value;
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return PanelPage(url: value);
        }));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
                    controller: textController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Endereço do Servidor',
                      contentPadding: EdgeInsets.all(8),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50), // NEW
                      ),
                      onPressed: _saveAndOpenPanel,
                      child: const Text(
                        "Abrir Painel",
                        style: TextStyle(fontWeight: FontWeight.w400),
                      ))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
