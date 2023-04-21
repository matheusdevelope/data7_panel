import 'package:data7_panel/providers/theme_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'legends.dart';

class CustomBottomAppBar extends StatelessWidget {
  const CustomBottomAppBar(
      {super.key, required this.legends, required this.lastTimeSync});
  final String legends;
  final String lastTimeSync;

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModel>(
      builder: (context, ThemeModel theme, c) {
        return BottomAppBar(
          padding: const EdgeInsets.only(top: 8),
          shape: const CircularNotchedRectangle(),
          child: Container(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Legends(
                      legends: legends, fontSize: theme.fontSizeMenuPanel),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    lastTimeSync,
                    textAlign: TextAlign.end,
                    style: TextStyle(fontSize: theme.fontSizeMenuPanel),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
