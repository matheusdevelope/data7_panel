class Filter {
  String name;
  String value;

  Filter({required this.name, required this.value});

  factory Filter.fromJson(Map<String, dynamic> json) {
    return Filter(
      name: json['name'],
      value: json['value'],
    );
  }
}
