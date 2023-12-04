import 'package:data7_panel/domain/entity/Filter.dart';

class Filters {
  List<Filter> filters;

  Filters({this.filters = const []});

  factory Filters.fromJson(Map<String, dynamic> json) {
    return Filters(
      filters: json['filters'] != null
          ? (json['filters'] as List).map((i) => Filter.fromJson(i)).toList()
          : [],
    );
  }
}
