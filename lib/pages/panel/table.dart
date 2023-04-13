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
    List<Columns> cols = data.columns;
    return List<DataColumn>.generate(
        cols.length, (index) => _buildCol(cols[index]));
  }

  _buildCells(List<Data> dataRow) {
    return List<DataCell>.generate(
        dataRow.length,
        (index) => DataCell(Text(
              dataRow[index].value.toString(),
              overflow: TextOverflow.ellipsis,
              softWrap: true,
            )));
  }

  _buildRow(Rows dataRow, int i, BuildContext context) {
    List<Data>? rows = dataRow.data;
    if (rows != null) {
      return DataRow(
          color: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
            if (states.contains(MaterialState.selected)) {
              return Theme.of(context).colorScheme.primary.withOpacity(0.08);
            }
            if (i.isEven) {
              return const Color.fromRGBO(237, 242, 247, 1);
            }
            return null;
          }),
          cells: _buildCells(rows));
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
    if (data.columns.isNotEmpty) {
      return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: DataTable(
                    dividerThickness: 0.4,
                    columns: _buildColumns(),
                    rows: _buildRows(context))),
          ));
    }
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[
          Text(
            'Aguardando Novos Registros...',
            // style: Theme.of(context).textTheme.headlineMedium,
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
