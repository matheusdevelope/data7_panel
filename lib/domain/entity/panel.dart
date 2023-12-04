import 'package:data7_panel/domain/entity/column.dart';

class Panel {
  String id;
  String description;
  String statement;
  int interval;
  List<Column> columns;

  Panel(
      {required this.id,
      required this.description,
      required this.statement,
      required this.interval,
      required this.columns});

  factory Panel.fromJson(Map<String, dynamic> json) {
    return Panel(
      id: json['id'],
      description: json['description'],
      statement: json['statement'],
      interval: json['interval'],
      columns: json['columns']
          .map<Column>((column) => Column.fromJson(column))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'description': description,
        'statement': statement,
        'interval': interval,
        'columns': columns.map((column) => column.toJson()).toList(),
      };
}
