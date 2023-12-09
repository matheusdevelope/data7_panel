class Column {
  String name;
  String type;
  String? title;
  double? width;
  bool? visible;
  int? order;
  Column(
      {required this.name,
      required this.type,
      this.title,
      this.width,
      this.visible,
      this.order});
  factory Column.fromJson(Map<String, dynamic> json) {
    return Column(
        name: json['name'] as String,
        type: json['type'] as String,
        title: json['title'] as String?,
        width: json['width'] as double?,
        visible: json['visible'] as bool?,
        order: json['order'] as int?);
  }
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
      'title': title,
      'width': width, //?? 0,
      'visible': visible, // ?? true,
      'order': order // ?? 0
    };
  }
}
