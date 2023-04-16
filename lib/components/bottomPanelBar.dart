import 'package:data7_panel/components/number_stepper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/theme_model.dart';

class BottomPanelBar extends StatefulWidget {
  const BottomPanelBar({
    super.key,
    required this.legends,
    required this.lastTimeSync,
    required this.connected,
    required this.callback,
  });
  final String legends;
  final String lastTimeSync;
  final bool connected;
  final VoidCallback callback;

  @override
  State<BottomPanelBar> createState() => _BottomPanelBarState();
}

class _BottomPanelBarState extends State<BottomPanelBar> {
  bool openConfigs = false;
  bool incrementAllTogeter = true;
  _buildListLegends(
      List<String> legends, BuildContext context, double fontSize) {
    return Wrap(
        // mainAxisSize: MainAxisSize.min,
        children: List<Row>.generate(
            legends.length,
            (index) => Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.circle,
                      color: Color(int.parse(legends[index]
                          .split(":")[0]
                          .replaceAll("#", "0xFF")))),
                  Text(legends[index].split(":")[1].toString(),
                      style: TextStyle(fontSize: fontSize)),
                  const SizedBox(
                    width: 4.0,
                  )
                ])));
  }

  _toggleConfigs() {
    setState(() {
      openConfigs = !openConfigs;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> legends = widget.legends.split(',');
    double step = 0.5;

    return Consumer<ThemeModel>(builder: (context, ThemeModel theme, child) {
      return BottomAppBar(
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
          ),
          child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.spaceBetween,
              spacing: 8.0,
              runSpacing: 4.0,
              children: [
                _buildListLegends(legends, context, theme.fontSizeMenuPanel),
                IconButton(
                  padding: const EdgeInsets.all(0),
                  iconSize: theme.fontSizeMenuPanel + 8.0,
                  tooltip: widget.connected ? "Painel Conectado" : "Reconectar",
                  onPressed: () {
                    widget.connected ? _toggleConfigs() : widget.callback();
                  },
                  icon: Icon(
                    Icons.connected_tv_outlined,
                    color: widget.connected ? Colors.green : Colors.red,
                  ),
                ),
                Text(widget.lastTimeSync,
                    style: TextStyle(fontSize: theme.fontSizeMenuPanel)),
                if (openConfigs) ...[
                  const Divider(height: 1),
                  Wrap(
                    runAlignment: WrapAlignment.spaceBetween,
                    alignment: WrapAlignment.spaceEvenly,
                    children: [
                      CheckboxMenuButton(
                          style: ButtonStyle(
                            overlayColor:
                                MaterialStateProperty.resolveWith<Color?>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.hovered) ||
                                    states.contains(MaterialState.pressed)) {
                                  return Colors.transparent; //<-- SEE HERE
                                }
                                return null; // Defer to the widget's default.
                              },
                            ),
                          ),
                          value: incrementAllTogeter,
                          onChanged: (bool? value) {
                            setState(() {
                              incrementAllTogeter = value!;
                            });
                          },
                          child: Text("Tamanho Único",
                              style: TextStyle(fontSize: theme.fontSize))),
                      if (incrementAllTogeter)
                        NumberStepper(
                          label: "Fonte Geral",
                          fontSize: theme.fontSizeMenuPanel,
                          initialValue: theme.fontSize,
                          min: 14,
                          max: 60,
                          step: step,
                          onChanged: (value) {
                            theme.fontSize = value;
                            theme.fontSizeTitlePanel = value;
                            theme.fontSizeDataPanel = value;
                            theme.fontSizeMenuPanel = value;
                          },
                        )
                      else
                        // Row(  children:
                        ...[
                        NumberStepper(
                          label: "Fonte Geral",
                          fontSize: theme.fontSizeMenuPanel,
                          initialValue: theme.fontSize,
                          min: 14,
                          max: 60,
                          step: step,
                          onChanged: (value) {
                            theme.fontSize = value;
                            theme.fontSizeTitlePanel = value;
                            theme.fontSizeDataPanel = value;
                            theme.fontSizeMenuPanel = value;
                          },
                        ),
                        NumberStepper(
                          label: "Titulo Painel",
                          fontSize: theme.fontSizeMenuPanel,
                          initialValue: theme.fontSizeTitlePanel,
                          min: 14,
                          max: 60,
                          step: step,
                          onChanged: (value) {
                            theme.fontSizeTitlePanel = value;
                          },
                        ),
                        NumberStepper(
                          label: "Dados Painel",
                          fontSize: theme.fontSizeMenuPanel,
                          initialValue: theme.fontSizeDataPanel,
                          min: 14,
                          max: 60,
                          step: step,
                          onChanged: (value) {
                            setState(() {
                              theme.fontSizeDataPanel = value;
                            });
                          },
                        ),
                        NumberStepper(
                          label: "Menu Painel",
                          fontSize: theme.fontSizeMenuPanel,
                          initialValue: theme.fontSizeMenuPanel,
                          min: 14,
                          max: 60,
                          step: step,
                          onChanged: (value) {
                            setState(() {
                              theme.fontSizeMenuPanel = value;
                            });
                          },
                        ),
                      ],
                    ],
                  )
                ]
              ]));
    });
  }
}
