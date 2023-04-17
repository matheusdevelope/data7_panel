import 'package:data7_panel/models/tableComponentData.dart';
import 'package:data7_panel/pages/panel/transform_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_model.dart';
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

  _buildCol(Columns col) {
    return DataColumn(
      label: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(
          col.label.toString().toUpperCase(),
          style: TextStyle(
              color: getColor("#4A5568"),
              fontSize: _fontSize(col.fontSize, fontSizeProvider)),
        ),
      ),
      tooltip: col.toolTip,
    );
  }

  _buildColumns() {
    List<Columns> cols = data.columns;
    return List<DataColumn>.generate(
        cols.length, (index) => _buildCol(cols[index]));
  }

  _buildCells(List<Data> dataRow, double? fontSize) {
    return List<DataCell>.generate(
        dataRow.length,
        (index) => DataCell(Text(dataRow[index].value.toString(),
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                // color: color,
                fontSize: fontSize,
                fontWeight: FontWeight.bold))));
  }

  _buildRow(Rows dataRow, int i, BuildContext context) {
    List<Data>? rows = dataRow.data;
    // Color? fnColor = dataRow.options?.color;
    if (rows != null) {
      return DataRow(
          color: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
            // Color? bgColor = dataRow.options?.backgroundColor;

            if (states.contains(MaterialState.selected)) {
              return Theme.of(context).colorScheme.primary.withOpacity(0.08);
            }
            // if (bgColor != null) {
            //   return bgColor;
            // }
            if (i.isEven) {
              return const Color.fromRGBO(237, 242, 247, 1);
            }
            return null;
          }),
          cells: _buildCells(
              rows, _fontSize(dataRow.options?.fontSize, fontSizeProvider)));
    }
  }

  _buildRows(BuildContext context) {
    List<Rows> rows = data.rows;
    return List<DataRow>.generate(
            rows.length, (index) => _buildRow(rows[index], index, context))
        .toList();
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
      RegExp hexColor = RegExp(r'^#?([0-9a-fA-F]{3}|[0-9a-fA-F]{6})$');

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
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: hexColor.hasMatch(dataRow.options?.color ?? '')
                              ? Color(
                                  int.parse((dataRow.options?.color ?? ""), radix: 16) + 0xFF000000)
                              : null,
                          fontSize: _fontSize(dataRow.options?.fontSize, fontSizeProvider),
                          fontWeight: FontWeight.bold)))));
    });

    if (data.columns.isNotEmpty) {
      return Consumer<ThemeModel>(builder: (context, ThemeModel theme, child) {
        fontSizeProvider = theme.fontSizeDataPanel;
        return CustomTable(
          // title: Text('Dynamic Table'),
          columns: columns,
          rows: rows,
          // headerHeight: 50,
          // rowHeight: 40,
          // columnWidth: 200,
          dividerThickness: 1,
          isIvenColor: Color(int.parse(("#EDF2F7").replaceAll("#", "0xFF"))),
        );
        // DataTable(
        //     dividerThickness: 1,
        //     columnSpacing: 24,
        //     columns: _buildColumns(),
        //     rows: _buildRows(context));
      });
    }
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[
          Text(
            'Aguardando Novos Registros...',
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 16,
          ),
          CircularProgressIndicator()
        ],
      ),
    );
  }
}
