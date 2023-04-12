import 'package:flutter/material.dart';

class BottomPanelBar extends StatefulWidget {
  const BottomPanelBar(
      {super.key,
      required this.legends,
      required this.lastTimeSync,
      required this.connected,
      required this.callback});
  final String legends;
  final String lastTimeSync;
  final bool connected;
  final VoidCallback callback;

  @override
  State<BottomPanelBar> createState() => _BottomPanelBarState();
}

_buildListLegends(List<String> legends) {
  return Row(
      mainAxisSize: MainAxisSize.min,
      children: List<Row>.generate(
          legends.length,
          (index) => Row(children: [
                Icon(Icons.circle,
                    color: Color(int.parse(
                        legends[index].split(":")[0].replaceAll("#", "0xFF")))),
                Text(
                  legends[index].split(":")[1].toString(),
                ),
                const SizedBox(
                  width: 4.0,
                )
              ])));
}

class _BottomPanelBarState extends State<BottomPanelBar> {
  @override
  Widget build(BuildContext context) {
    List<String> legends = widget.legends.split(',');

    return BottomAppBar(
      padding: const EdgeInsets.all(4),
      child: IconTheme(
        data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
        child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.spaceBetween,
            spacing: 8.0, // gap between adjacent chips
            runSpacing: 4.0,
            children: [
              _buildListLegends(legends),
              IconButton(
                tooltip: widget.connected ? "Painel Conectado" : "Reconectar",
                onPressed: () {
                  widget.connected ? null : widget.callback();
                },
                icon: Icon(
                  Icons.connected_tv_outlined,
                  color: widget.connected ? Colors.green : Colors.red,
                  size: 24,
                ),
              ),
              Text(widget.lastTimeSync),
            ]),
      ),
    );
  }
}
