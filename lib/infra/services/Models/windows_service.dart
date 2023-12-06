class WindowsService {
  String name;
  String path;
  String description;
  String displayName;
  StartupType startupType;
  StatusWindowsService status = StatusWindowsService.Unistalled;
  WindowsService({
    required this.name,
    required this.path,
    required this.description,
    required this.displayName,
    required this.startupType,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'path': path,
      'description': description,
      'displayName': displayName,
      'startupType': startupType.name,
      'status': status.name
    };
  }
}

enum StatusWindowsService {
  Stopped,
  StartPending,
  StopPending,
  Running,
  ContinuePending,
  PausePending,
  Paused,
  Unistalled
}

enum StartupType { Automatic, Manual, Disabled }

enum WindowsServiceEvent {
  load,
  install,
  uninstall,
  start,
  stop,
  restart,
  status,
  update,
  statusChange
}
