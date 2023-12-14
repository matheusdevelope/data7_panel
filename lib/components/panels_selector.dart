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
    final retPanels = await GetPanels.execute();
    setState(() {
      panels = retPanels;
      joined = settings.panel.joined;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadPanels();
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: ListView.builder(
        itemCount: panels.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: PanelBox(
              panel: panels[index],
              rightIcon: Switch(
                value: joined.contains(panels[index].id),
                onChanged: (value) {
                  List<String> tempJoined = settings.panel.joined;
                  if (value) {
                    tempJoined = tempJoined
                        .where((element) => element != panels[index].id)
                        .toList();
                    tempJoined.add(panels[index].id);
                  } else {
                    tempJoined = tempJoined
                        .where((element) => element != panels[index].id)
                        .toList();
                  }
                  settings.panel.joined = tempJoined;
                  setState(() {
                    joined = tempJoined;
                  });
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
