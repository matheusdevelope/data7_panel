import 'package:data7_panel/core/domain/entity/Panel.dart';
import 'package:data7_panel/core/domain/repository/panel_repository.dart';

class UpdatePanel {
  IPanelRepository repository;
  UpdatePanel({required this.repository});
  Future<Panel> execute(Panel panel) async {
    return await repository.save(panel);
  }
}