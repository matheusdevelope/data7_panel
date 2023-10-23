import 'dart:convert';
import 'package:data7_panel/services/powershel.dart';

enum FirewallAction {
  allow,
  block,
}

enum FirewallDirection {
  inbound,
  outbound,
}

enum FirewallProtocol { upd, tcp }

class FirewallRule {
  String displayName;
  String description;
  String program;
  int? localPort;
  bool? enabled = true;

  FirewallDirection? direction = FirewallDirection.inbound;
  FirewallAction? action = FirewallAction.allow;
  FirewallProtocol? protocol = FirewallProtocol.tcp;

  FirewallRule({
    required this.displayName,
    required this.description,
    required this.program,
    this.direction = FirewallDirection.inbound,
    this.enabled = true,
    this.action = FirewallAction.allow,
    this.protocol = FirewallProtocol.tcp,
    this.localPort,
  });

  add({FirewallDirection? pDirection}) async {
    FirewallDirection? _direction = pDirection ?? direction;
    String command =
        'New-NetFirewallRule -DisplayName ${shellArgument(displayName, quote: "'")} -Program ${shellArgument(program, quote: "'")} '
        // '-RemoteAddress LocalSubnet '
        '${action != null ? '-Action ${shellArgument(action!.name)}' : ''} '
        '${_direction != null ? '-Direction ${shellArgument(_direction.name)}' : ''} '
        '${protocol != null ? '-Protocol ${shellArgument(protocol!.name)}' : ''} '
        '${localPort != null ? '-LocalPort $localPort' : ''} ';
    try {
      await PowerShell.runAs(command);
      return true;
    } catch (e) {
      rethrow;
    }
  }

  remove() async {
    String command =
        'Remove-NetFirewallRule -DisplayName ${shellArgument(displayName, quote: "'")}';
    try {
      await PowerShell.runAs(command);
      return true;
    } catch (e) {
      rethrow;
    }
  }

  edit() async {
    return await remove() && await add();
  }

  addInboundAndOutbound() async {
    try {
      await add(pDirection: FirewallDirection.inbound);
      await add(pDirection: FirewallDirection.outbound);
      return true;
    } catch (e) {
      rethrow;
    }
  }

  static removeRule(String displayName) async {
    String command =
        'Remove-NetFirewallRule -DisplayName ${shellArgument(displayName, quote: "'")}';
    try {
      await PowerShell.runAs(command);
      return true;
    } catch (e) {
      rethrow;
    }
  }

  static Future<FirewallRule?> getRule(String displayName) async {
    String command =
        'Get-NetFirewallRule -DisplayName ${shellArgument(displayName, quote: "'")} | ConvertTo-Json';
    String output = await PowerShell.runAs(command);
    if (output.isNotEmpty) {
      try {
        dynamic json = jsonDecode(output);

        String displayName = json['DisplayName'];
        String description = getPropertyValue(json, 'Description');
        bool enabled = getPropertyValue(json, 'Enabled') == 'True';
        String direction = getPropertyValue(json, 'Direction');
        String action = getPropertyValue(json, 'Action');
        String protocol = getPropertyValue(json, 'Protocol');
        int localPort =
            int.tryParse(getPropertyValue(json, 'LocalPort') ?? '') ?? 0;
        String program = getPropertyValue(json, 'Program');

        if (displayName != null &&
            enabled != null &&
            direction != null &&
            action != null &&
            protocol != null &&
            program != null &&
            description != null) {
          return FirewallRule(
            displayName: displayName,
            description: description,
            enabled: enabled,
            direction: direction as FirewallDirection,
            action: action as FirewallAction,
            protocol: protocol as FirewallProtocol,
            localPort: localPort,
            program: program,
          );
        } else {
          return null;
        }
      } catch (e) {
        return null;
      }
    } else {
      return null;
    }
  }

  static getPropertyValue(dynamic pJson, String propertyName) {
    List<Map<String, dynamic>> json = pJson['CimInstanceProperties'];
    return json.firstWhere((prop) => prop['Name'] == propertyName,
        orElse: () => {"Value": null})['Value'];
  }
}
