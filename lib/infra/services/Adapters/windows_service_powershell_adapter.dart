import "dart:async";
import "dart:convert";

import "package:data7_panel/infra/services/Interfaces/windows_service.dart";
import "package:data7_panel/infra/services/Models/windows_service.dart";
import 'package:events_emitter/events_emitter.dart';
import "package:data7_panel/old/services/powershel.dart";

class PowershellWindowsServiceAdapter implements IWindowsService {
  final WindowServiceEvent _events = WindowServiceEvent();
  final Map<String, Map<String, dynamic>> _listenersStatus = {};
  PowershellWindowsServiceAdapter();

  @override
  Future<WindowsService?> load(String serviceName) async {
    final command =
        "Get-CimInstance Win32_Service -Filter 'Name = \"$serviceName\"' | Select-Object * | ConvertTo-Json";
    final result = await PowerShell.run(command);
    if (result.toString().isNotEmpty) {
      final json = jsonDecode(result);
      String startupType = json["StartMode"].toString().toLowerCase();
      if (startupType == "auto" ||
          startupType == "system" ||
          startupType == "boot") {
        startupType = "automatic";
      }
      final service = WindowsService(
        name: json["Name"],
        path: json["PathName"],
        description: json["Description"],
        displayName: json["DisplayName"],
        startupType: StartupType.values.firstWhere(
            (element) => element.name.toLowerCase() == startupType,
            orElse: () => StartupType.Automatic),
      );
      _emit(WindowsServiceEvent.load, service);
      return service;
    }
    return null;
  }

  @override
  Future<void> install(WindowsService service) async {
    final command =
        "New-Service -Name '${service.name}' -BinaryPathName '${service.path}' -Description '${service.description}' -DisplayName '${service.displayName}' -StartupType '${service.startupType.name}'";
    await PowerShell.runAs(command);
    _emit(WindowsServiceEvent.install, service);
  }

  @override
  Future<void> uninstall(WindowsService service) async {
    final command =
        "Stop-Service -Name '${service.name}' |  sc.exe delete '${service.name}'";
    await PowerShell.runAs(command);
    _emit(WindowsServiceEvent.uninstall, service);
  }

  @override
  Future<void> start(WindowsService service) async {
    final command = "Start-Service -Name '${service.name}'";
    await PowerShell.runAs(command);
    _emit(WindowsServiceEvent.start, service);
  }

  @override
  Future<void> stop(WindowsService service) async {
    final command = "Stop-Service -Name '${service.name}'";
    await PowerShell.runAs(command);
    _emit(WindowsServiceEvent.stop, service);
  }

  @override
  Future<void> restart(WindowsService service) async {
    final command = "Restart-Service -Name '${service.name}'";
    await PowerShell.runAs(command);
    _emit(WindowsServiceEvent.restart, service);
  }

  @override
  Future<StatusWindowsService> status(WindowsService service) async {
    _emit(WindowsServiceEvent.status, service);
    return _status(service);
  }

  Future<StatusWindowsService> _status(WindowsService service) async {
    String command =
        "Get-Service -Name '${service.name}' | Select-Object -ExpandProperty Status";
    StatusWindowsService status = StatusWindowsService.Unistalled;
    String result = await PowerShell.run(command);
    for (var element in StatusWindowsService.values) {
      if (element.name.trim().toLowerCase() == result.trim().toLowerCase()) {
        status = element;
        break;
      }
    }
    return status;
  }

  @override
  Future<void> update(WindowsService service) async {
    final command =
        "Set-Service -Name '${service.name}' -StartupType '${service.startupType.name}' -DisplayName '${service.displayName}' -Description '${service.description}'";
    await PowerShell.runAs(command);
    _emit(WindowsServiceEvent.update, service);
  }

  @override
  on(WindowsServiceEvent event, WindowsServiceCallback callback) {
    _events.on(event, callback);
  }

  @override
  off(WindowsServiceEvent event, WindowsServiceCallback callback) {
    _events.off(event, callback);
  }

  _emit(WindowsServiceEvent event, WindowsService service) async {
    service.status = await _status(service);
    _events.emit(event, service);
  }

  @override
  removeAllListeners(
      WindowsServiceEvent event, WindowsServiceCallback callback) {
    _events.removeAllListeners(event, callback);
  }

  @override
  startMonitorStatusChange(WindowsService service, int interval) {
    if (_listenersStatus.containsKey(service.name)) {
      _listenersStatus[service.name]?['timer']?.cancel();
    }
    _listenersStatus[service.name] = {
      "interval": interval,
    };
    final timer = Timer.periodic(
      Duration(milliseconds: interval),
      (timer) async {
        _emit(WindowsServiceEvent.statusChange, service);
      },
    );
    _listenersStatus[service.name]?["timer"] = timer;
  }

  @override
  stopMonitorStatusChange(WindowsService service) {
    if (_listenersStatus.containsKey(service.name)) {
      _listenersStatus[service.name]?['timer']?.cancel();
      _listenersStatus.remove(service.name);
    }
  }
}

class WindowServiceEvent {
  final EventEmitter _events = EventEmitter();

  WindowServiceEvent();

  void on(
    WindowsServiceEvent event,
    WindowsServiceCallback callback,
  ) {
    _events.on(event.name, callback);
  }

  void off(
    WindowsServiceEvent event,
    WindowsServiceCallback callback,
  ) {
    _events.off(type: event.name, callback: callback);
  }

  void removeAllListeners(
      WindowsServiceEvent? event, WindowsServiceCallback? callback) {
    if (event == null && callback == null) {
      for (var element in _events.listeners) {
        _events.removeEventListener(element);
      }
      return;
    }
    final listener = _events.listeners
        .firstWhere((element) => element.matches(event?.name, callback));
    _events.removeEventListener(listener);
  }

  void emit<T>(WindowsServiceEvent event, WindowsService service) {
    _events.emit(event.name, service);
  }
}
