import 'package:data7_panel/old/models/tableComponentData.dart';
import 'package:data7_panel/old/models/transform_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_model.dart';
import 'custom_table.dart';

class TableComponent extends StatelessWidget {
  const TableComponent({super.key, required this.data});
  final TableComponentData data;
  static double? fontSizeProvider;

  _fontSize(double? fontSize1, double? fontSize2) {
    double? font = fontSize1;
    font = font != null && font > 0
        ? font
        : fontSize2 != null && fontSize2 > 0
            ? fontSize2
            : null;
    return font;
  }

  @override
  Widget build(BuildContext context) {
    List<CustomDataColumn> columns =
        List.generate(data.columns.length, (index) {
      return CustomDataColumn(
          label: Text(
            data.columns[index].label.toString().toUpperCase(),
            style: TextStyle(
                overflow: TextOverflow.ellipsis,
                color: getColor("#4A5568"),
                fontWeight: FontWeight.bold,
                fontSize:
                    _fontSize(data.columns[index].fontSize, fontSizeProvider)),
          ),
          width: data.columns[index].width);
    });

    List<CustomDataRow> rows = List.generate(data.rows.length, (index) {
      final dataRow = data.rows[index];
      RegExp hexColor = RegExp(r'^#?([0-9a-fA-F]{6})$');

      return CustomDataRow(
          cells: List.generate(
              data.columns.length,
              (cellIndex) => CustomDataCell(
                  backgroundColor: (dataRow.options?.backgroundColor ?? '')
                                  .toUpperCase() ==
                              "FFFFFF" &&
                          index.isEven
                      ? null
                      : hexColor
                              .hasMatch(dataRow.options?.backgroundColor ?? '')
                          ? Color(int.parse(
                                  (dataRow.options?.backgroundColor ?? ""),
                                  radix: 16) +
                              0xFF000000)
                          : null,
                  cell: Text(dataRow.data![cellIndex].value.toString(),
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: hexColor.hasMatch(dataRow.options?.color ?? '')
                              ? Color(
                                  int.parse((dataRow.options?.color ?? ""), radix: 16) + 0xFF000000)
                              : null,
                          fontSize: _fontSize(dataRow.options?.fontSize, fontSizeProvider),
                          fontWeight: FontWeight.bold)))));
    });

    // if (data.columns.isEmpty) {
    return Consumer<ThemeModel>(builder: (context, ThemeModel theme, child) {
      fontSizeProvider = theme.fontSizeDataPanel;
      return CustomTable(
        columns: columns,
        rows: rows,
        dividerThickness: 1,
        isIvenColor: Color(int.parse(("#EDF2F7").replaceAll("#", "0xFF"))),
      );
    });
    // }
    // return
    //     // Center(
    //     //   child:
    //     // Column(
    //     //   mainAxisAlignment: MainAxisAlignment.center,
    //     //   crossAxisAlignment: CrossAxisAlignment.center,
    //     //   children: <Widget>[
    //     //     // Text(
    //     //   'Aguardando Dados...',
    //     //   textAlign: TextAlign.center,
    //     //   style: TextStyle(fontWeight: FontWeight.bold),
    //     // ),
    //     Center(
    //   // height: 60,
    //   // width: 60,
    //   child: CircularProgressIndicator(),
    // ); //,
    //     ],
    //   ),
    // );
  }
}
