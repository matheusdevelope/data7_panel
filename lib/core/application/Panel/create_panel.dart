import 'package:data7_panel/core/domain/entity/Panel.dart';
import 'package:data7_panel/core/domain/repository/panel_repository.dart';

class CreatePanel {
  IPanelRepository repository;
  CreatePanel({required this.repository});
  Future<Panel> execute(Panel panel) async {
    return await repository.save(panel);
  }
}
