import 'package:flutter/material.dart';

class TableComponentData {
  List<Columns> columns = [];
  List<Columns> columnsHide = [];
  List<Rows> rows = [];
  double fontSize = 14;

  TableComponentData({required this.columns, required this.rows});

  TableComponentData.fromJson(Map<String, dynamic> json) {
    if (json['columns'] != null) {
      columns = <Columns>[];
      json['columns'].forEach((v) {
        columns.add(Columns.fromJson(v));
      });
    }
    if (json['rows'] != null) {
      rows = <Rows>[];
      json['rows'].forEach((v) {
        rows.add(Rows.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['columns'] = columns.map((v) => v.toJson()).toList();
    data['columnsHide'] = columnsHide.map((v) => v.toJson()).toList();
    data['rows'] = rows.map((v) => v.toJson()).toList();
    return data;
  }
}

class Columns {
  String? name;
  String? label;
  String? toolTip;
  bool? isOrderColumn;
  bool? hide;
  double? fontSize;

  Columns(
      {this.name,
      this.label,
      this.toolTip,
      this.isOrderColumn,
      this.hide,
      this.fontSize});

  Columns.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    label = json['label'];
    toolTip = json['toolTip'];
    isOrderColumn = json['isOrderColumn'];
    hide = json['hide'];
    fontSize = json['fontSize'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['name'] = name;
    data['label'] = label;
    data['toolTip'] = toolTip;
    data['isOrderColumn'] = isOrderColumn;
    data['hide'] = hide;
    data['fontSize'] = fontSize;
    return data;
  }
}

class Rows {
  List<Data>? data;
  List<Data>? dataHide;
  Options? options;

  Rows({this.data, this.dataHide, this.options});

  Rows.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    if (json['dataHide'] != null) {
      dataHide = <Data>[];
      json['dataHide'].forEach((v) {
        dataHide!.add(new Data.fromJson(v));
      });
    }
    options =
        json['options'] != null ? new Options.fromJson(json['options']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.dataHide != null) {
      data['dataHide'] = this.dataHide!.map((v) => v.toJson()).toList();
    }
    if (this.options != null) {
      data['options'] = this.options!.toJson();
    }
    return data;
  }
}

class Data {
  String? field;
  String? value;

  Data({this.field, this.value});

  Data.fromJson(Map<String, dynamic> json) {
    field = json['field'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['field'] = field;
    data['value'] = value;
    return data;
  }
}

class Options {
  Color? color;
  Color? backgroundColor;
  double? fontSize;

  Options({this.color, this.backgroundColor, this.fontSize});

  Options.fromJson(Map<String, dynamic> json) {
    color = json['color'];
    backgroundColor = json['backgroundColor'];
    fontSize = json['fontSize'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['color'] = color;
    data['backgroundColor'] = backgroundColor;
    data['fontSize'] = fontSize;
    return data;
  }
}
