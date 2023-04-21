import 'package:data7_panel/providers/theme_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyBottomAppBar extends StatelessWidget {
  final bool isConnected;
  final Function onConnectionButtonPressed;
  final String lastSyncTime;
  final bool isExpanded;
  final Function onExpandButtonPressed;
  final int selectedFontSizeIndex;
  final List<double> fontSizes;
  final double fontSize;
  final String? legends;

  const MyBottomAppBar(
      {Key? key,
      required this.isConnected,
      required this.onConnectionButtonPressed,
      required this.lastSyncTime,
      required this.isExpanded,
      required this.onExpandButtonPressed,
      required this.selectedFontSizeIndex,
      required this.fontSizes,
      required this.fontSize,
      this.legends})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> legendsList = (legends ?? '').split(',');
    _buildListLegends(
        List<String> legends, BuildContext context, double fontSize) {
      return Wrap(
          // mainAxisSize: MainAxisSize.min,
          children: List<Row>.generate(
              legends.length,
              (index) => Row(mainAxisSize: MainAxisSize.min, children: [
                    if (legends[index].toString().contains(":"))
                      Icon(Icons.circle,
                          color: Color(int.parse(legends[index]
                              .split(":")[0]
                              .replaceAll("#", "0xFF")))),
                    if (legends[index].toString().contains(':'))
                      Text(legends[index].split(":")[1].toString(),
                          style: TextStyle(fontSize: fontSize)),
                    const SizedBox(
                      width: 4.0,
                    )
                  ])));
    }

    return Consumer<ThemeModel>(builder: (context, ThemeModel theme, child) {
      return BottomAppBar(
          shape: const CircularNotchedRectangle(),
          child: Container(
            padding: EdgeInsets.all(8),
            child: Wrap(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,

              runAlignment: WrapAlignment.spaceBetween,
              alignment: WrapAlignment.spaceBetween,

              children: <Widget>[
                _buildListLegends(
                    legendsList, context, theme.fontSizeMenuPanel),
                Text(
                  lastSyncTime,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: theme.fontSizeDataPanel),
                ),
              ],
            ),
          ));
    });
  }
}
