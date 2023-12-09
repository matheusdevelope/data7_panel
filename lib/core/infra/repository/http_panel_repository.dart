import 'package:data7_panel/core/domain/entity/Panel.dart';
import 'package:data7_panel/core/domain/repository/panel_repository.dart';
import 'package:data7_panel/core/infra/api/Http/http_client.dart';
import 'package:data7_panel/dependecy_injection.dart';

class HttpPanelRepository implements IPanelRepository {
  late IHttpClient httpClient;
  final String baseUrl;
  HttpPanelRepository({required this.baseUrl}) {
    httpClient = DI.get<IHttpClient>(param1: baseUrl);
  }

  @override
  Future<Panel> save(Panel panel) async {
    await httpClient.post('/panels', data: panel.toJson());
    return panel;
  }

  @override
  Future<Panel?> get(String id) async {
    final response = await httpClient.get('/panels/$id');
    if (response.statusCode == 200) {
      return Panel.fromJson(response.data);
    }
    return null;
  }

  @override
  Future<void> delete(String id) async {
    await httpClient.delete('/panels/$id');
  }

  @override
  Future<List<Panel>> list() async {
    final response = await httpClient.get('/panels');
    if (response.statusCode == 200) {
      return (response.data as List).map((e) => Panel.fromJson(e)).toList();
    }
    return [];
  }
}
