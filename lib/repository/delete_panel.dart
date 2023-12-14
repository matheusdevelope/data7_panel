import 'package:data7_panel/main.dart';
import 'package:http/http.dart' as http;

class DeletePanel {
  static Future<void> execute({required String id}) async {
    final url = '${(settings.panel).url.split('?')[0]}/panels/$id';
    final response = await http.delete(
      Uri.parse(url),
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to delete panel: ${response.body}');
    }
  }
}
