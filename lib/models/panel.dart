class Panel {
  String id;
  String description;
  String statement;
  int interval;

  Panel({
    required this.id,
    required this.description,
    required this.statement,
    required this.interval,
  });

  factory Panel.fromJson(Map<String, dynamic> json) => Panel(
        id: json["id"],
        description: json["description"],
        statement: json["statement"],
        interval: json["interval"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "description": description,
        "statement": statement,
        "interval": interval,
      };
}
