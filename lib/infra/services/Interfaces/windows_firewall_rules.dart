import 'package:data7_panel/infra/services/Models/windows_firewall_rules.dart';

abstract class IWindowsFirewallRule {
  Future<List<WindowsFirewallRule>> load(String displayName);
  Future<void> add(WindowsFirewallRule rule);
  Future<void> remove(WindowsFirewallRule rule);
  Future<void> update(WindowsFirewallRule rule);
  Future<bool> exists(WindowsFirewallRule rule);
  Future<void> enable(WindowsFirewallRule rule);
  Future<void> disable(WindowsFirewallRule rule);
}
