import 'dart:convert';

import 'package:data7_panel/main.dart';
import 'package:data7_panel/models/panel.dart';
import 'package:http/http.dart' as http;

class GetPanels {
  static Future<List<Panel>> execute({String? url}) async {
    List<Panel> panels = [];
    url = url ?? settings.panel.url;
    final urlPanels = '${url.split('?')[0]}/panels';
    final response = await http.get(Uri.parse(urlPanels));
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
