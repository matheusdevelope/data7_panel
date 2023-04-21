import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import '../providers/theme_model.dart';
import 'custom_slider.dart';

class BottomSheetMenu extends StatelessWidget {
  const BottomSheetMenu({super.key});
  final minFont = 10.0;
  final maxFont = 60.0;
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModel>(builder: (ctx, ThemeModel theme, c) {
      return Wrap(
          crossAxisAlignment: WrapCrossAlignment.end,
          alignment: WrapAlignment.center,
          children: [
            const SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Transform.rotate(
                    angle: 180 * math.pi / 180,
                    child: IconButton(
                      padding: const EdgeInsets.all(0),
                      iconSize: theme.fontSizeMenuPanel + 8.0,
                      tooltip: 'Voltar',
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.exit_to_app_outlined,
                        color: Colors.red,
                      ),
                    ))
              ],
            ),
            const Divider(),
            CustomSlider(
                label: 'Fonte Geral:',
                value: theme.fontSize,
                minValue: minFont,
                maxValue: maxFont,
                onChange: (value) {
                  theme.fontSize = value;
                  theme.fontSizeTitlePanel = value;
                  theme.fontSizeDataPanel = value;
                  theme.fontSizeMenuPanel = value;
                }),
            CustomSlider(
                label: 'Titulo Painel:',
                value: theme.fontSizeTitlePanel,
                minValue: minFont,
                maxValue: maxFont,
                onChange: (value) {
                  theme.fontSizeTitlePanel = value;
                }),
            CustomSlider(
                label: 'Linhas Painel:',
                value: theme.fontSizeDataPanel,
                minValue: minFont,
                maxValue: maxFont,
                onChange: (value) {
                  theme.fontSizeDataPanel = value;
                }),
            CustomSlider(
                label: 'Menu Painel:',
                value: theme.fontSizeMenuPanel,
                minValue: minFont,
                maxValue: maxFont,
                onChange: (value) {
                  theme.fontSizeMenuPanel = value;
                }),
          ]);
    });
  }
}
