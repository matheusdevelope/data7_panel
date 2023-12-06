import 'dart:convert';

import 'package:data7_panel/infra/services/Interfaces/windows_firewall_rules.dart';
import 'package:data7_panel/infra/services/Models/windows_firewall_rules.dart';
import 'package:data7_panel/old/services/powershel.dart';

class WindowsFirewallRulePowershellAdapter implements IWindowsFirewallRule {
  WindowsFirewallRulePowershellAdapter();

  @override
  Future<List<WindowsFirewallRule>> load(String displayName) async {
    final command =
        "Get-NetFirewallRule -DisplayName '$displayName' | Select-Object Name, DisplayName, Description, Enabled, Direction, Action, @{Name='Protocol';Expression={(\$PSItem | Get-NetFirewallPortFilter).Protocol}}, @{Name='LocalPort';Expression={(\$PSItem | Get-NetFirewallPortFilter).LocalPort}}, @{Name='Program';Expression={(\$PSItem | Get-NetFirewallApplicationFilter).Program}} | ConvertTo-Json";
    final result = await PowerShell.run(command);
    final list = <WindowsFirewallRule>[];
    if (result.toString().isNotEmpty) {
      final json = jsonDecode(result);
      if (json is List) {
        for (var element in json) {
          list.add(WindowsFirewallRule.fromJson(element));
        }
      }
      list.add(WindowsFirewallRule.fromJson(json));
    }
    return list;
  }

  @override
  Future<void> add(WindowsFirewallRule rule) async {
    final command = "New-NetFirewallRule ${_mountParams(rule)}";
    final result = await PowerShell.runAs(command);
    print(result);
    print(command);
  }

  @override
  Future<void> remove(WindowsFirewallRule rule) async {
    final command = "Remove-NetFirewallRule -DisplayName '${rule.displayName}'";
    await PowerShell.runAs(command);
  }

  @override
  Future<void> update(WindowsFirewallRule rule) async {
    final command = "Set-NetFirewallRule ${_mountParams(rule)}";
    await PowerShell.runAs(command);
  }

  @override
  Future<bool> exists(WindowsFirewallRule rule) async {
    final command =
        "Get-NetFirewallRule -DisplayName '${rule.displayName}' | Select-Object Name, DisplayName, Description, Enabled, Direction, Action, @{Name='Protocol';Expression={(\$PSItem | Get-NetFirewallPortFilter).Protocol}}, @{Name='LocalPort';Expression={(\$PSItem | Get-NetFirewallPortFilter).LocalPort}}, @{Name='Program';Expression={(\$PSItem | Get-NetFirewallApplicationFilter).Program}} | ConvertTo-Json";
    final result = await PowerShell.run(command);
    if (result.toString().isNotEmpty) {
      final json = jsonDecode(result);
      if (json is List) {
        return json.isNotEmpty;
      }
      return json['Name'] ? json['Name'].toString().isNotEmpty : false;
    }
    return false;
  }

  @override
  Future<void> enable(WindowsFirewallRule rule) async {
    final command =
        "Set-NetFirewallRule -DisplayName '${rule.displayName}' -Enabled True";
    await PowerShell.runAs(command);
  }

  @override
  Future<void> disable(WindowsFirewallRule rule) async {
    final command =
        "Set-NetFirewallRule -DisplayName '${rule.displayName}' -Enabled False";
    await PowerShell.runAs(command);
  }

  String _mountParams(WindowsFirewallRule rule) {
    final params = <String>[];
    if (rule.displayName.isNotEmpty) {
      params.add("-DisplayName1 '${rule.displayName}'");
    }
    if (rule.description.isNotEmpty) {
      params.add("-Description '${rule.description}'");
    }
    if (rule.localPort != null && rule.localPort! > 0) {
      params.add("-LocalPort ${rule.localPort}");
    }
    if (rule.program.isNotEmpty) {
      params.add("-Program '${rule.program}'");
    }
    params.add("-Direction ${rule.direction.name}");
    params.add("-Action ${rule.action.name}");
    params.add("-Protocol ${rule.protocol.name}");
    params.add("-Enabled ${rule.enabled}");
    return params.join(' ');
  }
}
