import 'package:data7_panel/domain/entity/Panel.dart';

abstract class IPanelRepository {
  Future<Panel> save(Panel panel);
  Future<Panel?> get(String id);
  Future<void> delete(String id);
  Future<List<Panel>> list();
}
