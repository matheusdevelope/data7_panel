import 'package:data7_panel/components/dialogAlert.dart';
import 'package:data7_panel/components/panel_box.dart';
import 'package:data7_panel/components/settings/settings.dart';
import 'package:data7_panel/main.dart';
import 'package:data7_panel/models/panel.dart';
import 'package:data7_panel/repository/get_panels.dart';
import 'package:flutter/material.dart';

class PanelsSelector extends StatefulWidget {
  const PanelsSelector({super.key, required this.url});
  final String url;

  @override
  State<PanelsSelector> createState() => _PanelsSelectorState();
}

class _PanelsSelectorState extends State<PanelsSelector> {
  List<Panel> panels = [];
  List<String> joined = [];

  _loadPanels() async {
    try {
      final retPanels = await GetPanels.execute(url: widget.url);
      setState(() {
        panels = retPanels;
        joined = settings.panel.joined;
      });
    } catch (e) {
      showAlertDialog(context, 'Erro ao buscar paineis',
          'Não foi possível buscar os paineis, verifique sua conexão e se o endereço está correto.');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: ListView(
        children: [
          SettingsCategory(
            title: "Selecionar paineis",
            expansible: true,
            icon: Icons.table_view,
            iconStyle: IconStyle(
              withBackground: true,
              backgroundColor: Colors.green[700],
            ),
            onChangeExpansion: (expanded) {
              if (expanded) {
                _loadPanels();
              }
            },
            child: panels
                .map(
                  (panel) => SettingsItem(
                    child: PanelBox(
                      panel: panel,
                      rightIcon: Switch(
                        value: joined.contains(panel.id),
                        onChanged: (value) {
                          List<String> tempJoined = settings.panel.joined;
                          if (value) {
                            tempJoined = tempJoined
                                .where((element) => element != panel.id)
                                .toList();
                            tempJoined.add(panel.id);
                          } else {
                            tempJoined = tempJoined
                                .where((element) => element != panel.id)
                                .toList();
                          }
                          settings.panel.joined = tempJoined;
                          setState(() {
                            joined = tempJoined;
                          });
                        },
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
