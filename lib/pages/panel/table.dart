import 'package:data7_panel/models/tableComponentData.dart';
import 'package:flutter/material.dart';

class TableComponent extends StatelessWidget {
  const TableComponent({super.key, required this.data});
  final TableComponentData data;

  _buildCol(Columns col) {
    return DataColumn(
      label: Text(
        col.label.toString(),
        style: TextStyle(fontSize: col.fontSize),
      ),
      tooltip: col.toolTip,
    );
  }

  _buildColumns() {
    List<Columns>? cols = data.columns;
    if (cols != null) {
      return List<DataColumn>.generate(
          cols.length, (index) => _buildCol(cols[index]));
    }
    return [];
  }

  _buildCells(List<Data> dataRow) {
    return List<DataCell>.generate(dataRow.length,
        (index) => DataCell(Text(dataRow[index].value.toString())));
  }

  _buildRow(List<Data> dataRow, int i, BuildContext context) {
    return DataRow(
        color: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
          // All rows will have the same selected color.
          if (states.contains(MaterialState.selected)) {
            return Theme.of(context).colorScheme.primary.withOpacity(0.08);
          }
          // Even rows will have a grey color.
          if (i.isEven) {
            return Colors.grey.withOpacity(0.3);
          }
          return null; // Use default value for other states and odd rows.
        }),
        cells: _buildCells(dataRow));
  }

  _buildRows(BuildContext context) {
    List<Data>? rows = data.rows?.data;
    if (rows != null) {
      return List<DataRow>.generate(
          rows.length, (index) => _buildRow(rows, index, context)).toList();
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return DataTable(columns: _buildColumns(), rows: _buildRows(context));
  }
}
