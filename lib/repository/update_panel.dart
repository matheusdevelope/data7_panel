import 'dart:convert';

import 'package:data7_panel/providers/settings_model.dart';
import 'package:http/http.dart' as http;

class UpdatePanel {
  static Future<void> execute(
      {required String id,
      required String description,
      required String statement,
      required int interval}) async {
    final url = '${(await Settings.panel.initialize()).url}/panels/$id';
    final body = jsonEncode({
      'description': description,
      'statement': statement,
      'interval': interval
    });
    final response = await http.put(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          "accept": "application/json",
        },
        body: body);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to create panel: ${response.body}');
    }
  }
}
