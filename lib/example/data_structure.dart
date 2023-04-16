class TableData {
  final String title;
  final List<Map<String, dynamic>> columns;
  final List<Map<String, dynamic>> rows;
  final TableConfig config;

  TableData(
      {required this.title,
      required this.columns,
      required this.rows,
      required this.config //= const {},
      });
}

class TableConfig {
  final bool showHeader;
  final bool showFooter;
  final bool highlightSelected;
  final bool enableSort;
  final bool enableFilter;

  TableConfig({
    this.showHeader = true,
    this.showFooter = false,
    this.highlightSelected = true,
    this.enableSort = true,
    this.enableFilter = true,
  });
}

List<TableData> tableList = [
  TableData(
    title: 'Table 1',
    columns: [
      {'label': 'Col 1', 'toolTip': 'Column 1'},
      {'label': 'Col 2', 'toolTip': 'Column 2'},
      {'label': 'Col 3', 'toolTip': 'Column 3'},
    ],
    rows: [
      {'Col 1': 'Row 1 Col 1', 'Col 2': 'Row 1 Col 2', 'Col 3': 'Row 1 Col 3'},
      {'Col 1': 'Row 2 Col 1', 'Col 2': 'Row 2 Col 2', 'Col 3': 'Row 2 Col 3'},
      {'Col 1': 'Row 3 Col 1', 'Col 2': 'Row 3 Col 2', 'Col 3': 'Row 3 Col 3'},
    ],
    config: TableConfig(
      showFooter: true,
      highlightSelected: false,
    ),
  ),
  TableData(
    title: 'Table 2',
    columns: [
      {'label': 'Col 1', 'toolTip': 'Column 1'},
      {'label': 'Col 2', 'toolTip': 'Column 2'},
    ],
    rows: [
      {'Col 1': 'Row 1 Col 1', 'Col 2': 'Row 1 Col 2'},
      {'Col 1': 'Row 2 Col 1', 'Col 2': 'Row 2 Col 2'},
      {'Col 1': 'Row 3 Col 1', 'Col 2': 'Row 3 Col 2'},
    ],
    config: TableConfig(
      enableFilter: false,
    ),
  ),
];
