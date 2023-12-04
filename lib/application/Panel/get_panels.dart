import 'package:data7_panel/domain/entity/Panel.dart';
import 'package:data7_panel/domain/repository/panel_repository.dart';

class GetPanels {
  IPanelRepository repository;
  GetPanels({required this.repository});
  Future<List<Panel>> execute() async {
    return await repository.list();
  }
}
