import 'package:data7_panel/core/domain/entity/Panel.dart';
import 'package:data7_panel/core/domain/entity/filters.dart';

class PanelCaroussel {
  Panel panel;
  Filters? filters;
  PanelCaroussel({
    required this.panel,
    required this.filters,
  });
}
