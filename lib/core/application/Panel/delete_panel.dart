import 'package:data7_panel/core/domain/repository/panel_repository.dart';

class DeletePanel {
  IPanelRepository repository;
  DeletePanel({required this.repository});
  Future<void> execute(String id) async {
    return await repository.delete(id);
  }
}
