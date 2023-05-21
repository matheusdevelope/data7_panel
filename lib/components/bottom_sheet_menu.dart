import 'package:data7_panel/components/custom_increase.dart';
import 'package:data7_panel/providers/caroussel_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import '../providers/theme_model.dart';
import 'bottom_sheet_row.dart';

class BottomSheetMenu extends StatelessWidget {
  const BottomSheetMenu({super.key});
  final minFont = 10.0;
  final maxFont = 60.0;
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModel>(
      builder: (ctx, ThemeModel theme, c) {
        return Consumer<CarousselModel>(
          builder: (context, CarousselModel caroussel, c) {
            return Wrap(
              crossAxisAlignment: WrapCrossAlignment.end,
              alignment: WrapAlignment.spaceAround,
              children: [
                BottomSheetRow(
                  child: [
                    Transform.rotate(
                      angle: 180 * math.pi / 180,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        iconSize: theme.fontSizeMenuPanel + 8.0,
                        tooltip: 'Voltar',
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(
                          Icons.exit_to_app_outlined,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
                BottomSheetRow(
                  label: Text(
                    "Auto Avançar Carrossel",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: theme.fontSizeMenuPanel),
                  ),
                  child: [
                    IconButton(
                      padding: const EdgeInsets.only(right: 22),
                      constraints: const BoxConstraints(),
                      iconSize: theme.fontSizeMenuPanel + 12,
                      onPressed: () {
                        caroussel.autoplay = !caroussel.autoplay;
                      },
                      color: caroussel.autoplay ? null : Colors.black,
                      tooltip: "Ativo",
                      icon: Icon(
                        caroussel.autoplay ? Icons.toggle_on : Icons.toggle_off,
                      ),
                    ),
                  ],
                ),
                BottomSheetRow(
                  label: Text(
                    "Duração Carrossel",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: theme.fontSizeMenuPanel),
                  ),
                  child: [
                    CustomIncrease(
                      value: caroussel.autoPlayDuration.toDouble(),
                      minValue: 1,
                      maxValue: 60 * 10,
                      onChange: (value) {
                        caroussel.autoPlayDuration = value.toInt();
                      },
                      fontSize: theme.fontSizeMenuPanel,
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.only(left: 4, right: 4, bottom: 4),
                  child: CustomIncrease(
                    label: 'Fonte Geral',
                    value: theme.fontSize,
                    minValue: minFont,
                    maxValue: maxFont,
                    onChange: (value) {
                      theme.fontSize = value;
                      theme.fontSizeTitlePanel = value;
                      theme.fontSizeDataPanel = value;
                      theme.fontSizeMenuPanel = value;
                    },
                    fontSize: theme.fontSizeMenuPanel,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 4, right: 4, bottom: 4),
                  child: CustomIncrease(
                      label: 'Titulo Painel',
                      value: theme.fontSizeTitlePanel,
                      minValue: minFont,
                      maxValue: maxFont,
                      onChange: (value) {
                        theme.fontSizeTitlePanel = value;
                      },
                      fontSize: theme.fontSizeMenuPanel),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 4, right: 4, bottom: 4),
                  child: CustomIncrease(
                      label: 'Linhas Painel',
                      value: theme.fontSizeDataPanel,
                      minValue: minFont,
                      maxValue: maxFont,
                      onChange: (value) {
                        theme.fontSizeDataPanel = value;
                      },
                      fontSize: theme.fontSizeMenuPanel),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 4, right: 4, bottom: 4),
                  child: CustomIncrease(
                      label: 'Menu Painel',
                      value: theme.fontSizeMenuPanel,
                      minValue: minFont,
                      maxValue: maxFont,
                      onChange: (value) {
                        theme.fontSizeMenuPanel = value;
                      },
                      fontSize: theme.fontSizeMenuPanel),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
