import 'package:data7_panel/core/domain/entity/panel.dart';

class Carousel {
  String id;
  List<Panel> panels;
  double duration;
  Orientation orientation;
  Carousel({
    required this.id,
    required this.panels,
    required this.duration,
    this.orientation = Orientation.vertical,
  });

  factory Carousel.fromJson(Map<String, dynamic> json) {
    return Carousel(
      id: json['id'],
      panels: json['panels'] != null
          ? (json['panels'] as List)
              .map((e) => Panel.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
      duration: json['duration'] ?? 0.0,
      orientation: json['orientation'] == 'vertical'
          ? Orientation.vertical
          : Orientation.horizontal,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'panels': panels.map((e) => e.toJson()).toList(),
      'duration': duration,
      'orientation':
          orientation == Orientation.vertical ? 'vertical' : 'horizontal',
    };
  }
}

enum Orientation { vertical, horizontal }
