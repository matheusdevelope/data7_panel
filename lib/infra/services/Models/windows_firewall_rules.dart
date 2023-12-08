// ignore_for_file: constant_identifier_names

class WindowsFirewallRule {
  String name;
  String displayName;
  String description;
  bool enabled;
  WindowsFirewallDirection direction = WindowsFirewallDirection.Inbound;
  WindowsFirewallAction action = WindowsFirewallAction.Allow;
  WindowsFirewallProtocol protocol = WindowsFirewallProtocol.TCP;
  int? localPort;
  String program;

  WindowsFirewallRule({
    required this.name,
    required this.displayName,
    required this.description,
    required this.enabled,
    required this.direction,
    required this.action,
    required this.protocol,
    required this.localPort,
    required this.program,
  });

  factory WindowsFirewallRule.create({
    required String displayName,
    required WindowsFirewallDirection direction,
    required WindowsFirewallAction action,
    required WindowsFirewallProtocol protocol,
    String? description,
    int? localPort,
    String? program,
    bool enabled = true,
  }) {
    return WindowsFirewallRule(
      name: '',
      displayName: displayName,
      description: description ?? '',
      enabled: enabled,
      direction: direction,
      action: action,
      protocol: protocol,
      localPort: localPort,
      program: program ?? '',
    );
  }

  factory WindowsFirewallRule.fromJson(Map<String, dynamic> json) {
    return WindowsFirewallRule(
      name: json['Name'],
      displayName: json['DisplayName'],
      description: json['Description'],
      enabled: json['Enabled'] == 1 ? true : false,
      direction: json['Direction'] == 1
          ? WindowsFirewallDirection.Inbound
          : WindowsFirewallDirection.Outbound,
      action: json['Action'] <= 2
          ? WindowsFirewallAction.Allow
          : WindowsFirewallAction.Block,
      protocol: json['Protocol'] == 'UDP'
          ? WindowsFirewallProtocol.UDP
          : WindowsFirewallProtocol.TCP,
      localPort: json['LocalPort'],
      program: json['Program'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'displayName': displayName,
      'description': description,
      'enabled': enabled,
      'direction': WindowsFirewallDirection.values
          .where((element) => direction == element),
      'action':
          WindowsFirewallAction.values.where((element) => action == element),
      'protocol': WindowsFirewallProtocol.values
          .where((element) => protocol == element),
      'localPort': localPort,
      'program': program,
    };
  }
}

enum WindowsFirewallAction {
  Allow,
  Block,
}

enum WindowsFirewallDirection {
  Inbound,
  Outbound,
}

enum WindowsFirewallProtocol { UDP, TCP }
