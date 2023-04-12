class TableComponentData {
  List<Columns>? columns;
  Rows? rows;

  TableComponentData({this.columns, this.rows});

  TableComponentData.fromJson(Map<String, dynamic> json) {
    if (json['columns'] != null) {
      columns = <Columns>[];
      json['columns'].forEach((v) {
        columns!.add(new Columns.fromJson(v));
      });
    }
    rows = json['rows'] != null ? new Rows.fromJson(json['rows']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.columns != null) {
      data['columns'] = this.columns!.map((v) => v.toJson()).toList();
    }
    if (this.rows != null) {
      data['rows'] = this.rows!.toJson();
    }
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['label'] = this.label;
    data['toolTip'] = this.toolTip;
    data['isOrderColumn'] = this.isOrderColumn;
    data['hide'] = this.hide;
    data['fontSize'] = this.fontSize;
    return data;
  }
}

class Rows {
  List<Data>? data;
  Options? options;

  Rows({this.data, this.options});

  Rows.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['field'] = this.field;
    data['value'] = this.value;
    return data;
  }
}

class Options {
  String? color;
  String? backgroundColor;
  int? fontSize;

  Options({this.color, this.backgroundColor, this.fontSize});

  Options.fromJson(Map<String, dynamic> json) {
    color = json['color'];
    backgroundColor = json['backgroundColor'];
    fontSize = json['fontSize'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['color'] = this.color;
    data['backgroundColor'] = this.backgroundColor;
    data['fontSize'] = this.fontSize;
    return data;
  }
}
