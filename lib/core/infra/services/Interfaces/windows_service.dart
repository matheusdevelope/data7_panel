import 'package:data7_panel/core/infra/services/Models/windows_service.dart';

abstract class IWindowsService {
  Future<WindowsService?> load(String serviceName);
  Future<void> install(WindowsService service);
  Future<void> uninstall(WindowsService service);
  Future<void> start(WindowsService service);
  Future<void> stop(WindowsService service);
  Future<void> restart(WindowsService service);
  Future<StatusWindowsService> status(WindowsService service);
  Future<void> update(WindowsService service);
  on(WindowsServiceEvent event, WindowsServiceCallback callback);
  off(WindowsServiceEvent event, WindowsServiceCallback callback);
  removeAllListeners(
      WindowsServiceEvent event, WindowsServiceCallback callback);
  startMonitorStatusChange(WindowsService service, int interval);
  stopMonitorStatusChange(WindowsService service);
}

typedef WindowsServiceCallback = void Function(WindowsService service);
