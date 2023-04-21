import 'package:flutter/material.dart';

class CustomTable extends StatelessWidget {
  final List<CustomDataColumn> columns;
  final List<CustomDataRow> rows;
  final double? rowHeight;
  final double? headerHeight;
  final double? columnWidth;
  final Color? isIvenColor;
  final BoxDecoration? rowDecoration;
  final BoxDecoration? headerDecoration;
  final double? dividerThickness;

  CustomTable(
      {required this.columns,
      required this.rows,
      this.rowHeight,
      this.headerHeight,
      this.columnWidth,
      this.isIvenColor,
      this.rowDecoration,
      this.headerDecoration,
      this.dividerThickness});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: ConstrainedBox(
                    constraints: BoxConstraints(
                        minWidth: MediaQuery.of(context).size.width),
                    child: Table(
                      columnWidths: _getColumnWidths(),
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      children: _getTableRows(),
                      border: TableBorder(
                          verticalInside: BorderSide.none,
                          horizontalInside: BorderSide(
                              width: dividerThickness ?? 0.5,
                              color: Colors.grey.shade300,
                              style: BorderStyle.solid)),
                    )))));
  }

  Map<int, TableColumnWidth> _getColumnWidths() {
    final Map<int, TableColumnWidth> columnWidths = {};

    for (int i = 0; i < columns.length; i++) {
      if (columns[i].width != null && columns[i].width! > 0) {
        columnWidths[i] = FixedColumnWidth(columns[i].width!);
      } else if (columnWidth != null) {
        columnWidths[i] = FixedColumnWidth(columnWidth!);
      } else {
        columnWidths[i] = const IntrinsicColumnWidth();
      }
    }

    return columnWidths;
  }

  List<TableRow> _getTableRows() {
    final List<TableRow> tableRows = [];

    tableRows.add(
      TableRow(
        decoration: headerDecoration,
        children: columns.map((column) {
          return TableCell(
            verticalAlignment: TableCellVerticalAlignment.top,
            child: Container(
              padding: const EdgeInsets.only(top: 0, bottom: 6, left: 4),
              height: headerHeight,
              child: column.label,
            ),
          );
        }).toList(),
      ),
    );

    for (int i = 0; i < rows.length; i++) {
      final CustomDataRow row = rows[i];

      final List<Widget> cells = row.cells.map((cell) {
        return TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Container(
            padding: EdgeInsets.all(row.padding ?? 6),
            height: rowHeight,
            color: cell.backgroundColor ??
                (i % 2 == 0
                    ? isIvenColor ?? Colors.grey.shade300
                    : Colors.white),
            child: cell.cellBuilder != null
                ? cell.cellBuilder!(cell.cell)
                : cell.cell,
          ),
        );
      }).toList();

      tableRows.add(
        TableRow(
          // decoration: rowDecoration ??
          //     BoxDecoration(
          //       border: Border.all(width: 10),
          //       borderRadius: const BorderRadius.all(Radius.circular(4.0)),
          //     ),
          children: cells,
        ),
      );
    }
    return tableRows;
  }
}

class CustomDataColumn {
  final Widget label;
  final double? width;
  final Widget Function(dynamic)? colBuilder;
  CustomDataColumn({required this.label, this.width, this.colBuilder});
}

class CustomDataRow {
  final List<CustomDataCell> cells;
  final double? height;
  final Color? color;
  final double? padding;
  final Widget Function(dynamic)? rowBuilder;
  CustomDataRow({
    required this.cells,
    this.height,
    this.color,
    this.padding,
    this.rowBuilder,
  });
}

class CustomDataCell {
  final Widget cell;
  final double? height;
  final double? width;
  final Color? color;
  final Color? backgroundColor;
  final Widget Function(dynamic)? cellBuilder;

  CustomDataCell(
      {required this.cell,
      this.width,
      this.height,
      this.color,
      this.backgroundColor,
      this.cellBuilder});
}
