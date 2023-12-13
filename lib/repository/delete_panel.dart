import 'package:data7_panel/providers/settings_model.dart';
import 'package:http/http.dart' as http;

class DeletePanel {
  static Future<void> execute({required String id}) async {
    final url = '${(await Settings.panel.initialize()).url}/panels/$id';
    final response = await http.delete(
      Uri.parse(url),
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to delete panel: ${response.body}');
    }
  }
}
