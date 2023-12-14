import 'dart:convert';

import 'package:data7_panel/main.dart';
import 'package:data7_panel/models/panel.dart';
import 'package:http/http.dart' as http;

class GetPanels {
  static Future<List<Panel>> execute() async {
    List<Panel> panels = [];
    final url = '${settings.panel.url.split('?')[0]}/panels';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final jsonPanels = jsonDecode(response.body);
      for (var panel in jsonPanels) {
        panels.add(Panel.fromJson(panel));
      }
    } else {
      throw Exception('Failed to load panels');
    }

    return panels;
  }
}
