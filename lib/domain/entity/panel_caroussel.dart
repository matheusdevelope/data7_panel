import 'package:data7_panel/domain/entity/Panel.dart';
import 'package:data7_panel/domain/entity/filters.dart';

class PanelCaroussel {
  Panel panel;
  Filters? filters;
  PanelCaroussel({
    required this.panel,
    required this.filters,
  });
}
