import 'package:data7_panel/domain/entity/Panel.dart';
import 'package:data7_panel/domain/repository/panel_repository.dart';

class GetPanel {
  IPanelRepository repository;
  GetPanel({required this.repository});
  Future<Panel?> execute(String id) async {
    return await repository.get(id);
  }
}
