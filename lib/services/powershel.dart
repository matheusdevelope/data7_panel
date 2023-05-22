import 'dart:async';
import 'dart:io';

class PowerShell {
  static Future<dynamic> runAs(String command) async {
    var powerShellCommand = 'powershell.exe';
    var powerShellArguments = [
      '-NoProfile',
      '-ExecutionPolicy',
      'Unrestricted',
      '-Command',
      "& {Start-Process PowerShell -ArgumentList '-WindowStyle hidden -NoProfile -ExecutionPolicy Unrestricted  -Command $command ' -Verb RunAs}"
    ];
    try {
      var ret = await Process.run(
        powerShellCommand,
        powerShellArguments,
        runInShell: true,
        stdoutEncoding: const SystemEncoding(),
        stderrEncoding: const SystemEncoding(),
      );
      return ret.stdout.toString();
    } catch (e) {
      return e.toString();
    }
  }

  static Future<dynamic> run(String command) async {
    var powerShellCommand = 'powershell.exe';
    var powerShellArguments = ['-Command', command];
    try {
      var ret = await Process.run(
        powerShellCommand,
        powerShellArguments,
        runInShell: true,
        stdoutEncoding: const SystemEncoding(),
        stderrEncoding: const SystemEncoding(),
      );
      return ret.stdout.toString();
    } catch (e) {
      return e.toString();
    }
  }
}

class WindowsServicePs {
  final String name;
  WindowsServicePs(this.name);
  Future<StatusService> status() async {
    String command =
        'Get-Service -Name "$name" | Select-Object -ExpandProperty Status';
    String result = await PowerShell.run(command);

    for (var element in StatusService.values) {
      if (element.name.trim().toLowerCase() == result.trim().toLowerCase()) {
        return element;
      }
    }
    return StatusService.unistalled;
  }

  Future<StatusService> start() async {
    String command = 'Start-Service -Name $name';
    await PowerShell.runAs(command);
    return await status();
  }

  Future<StatusService> stop() async {
    String command = 'Stop-Service -Name $name';
    await PowerShell.runAs(command);
    return await status();
  }

  Future<StatusService> restart() async {
    String command = 'Restart-Service -Name $name';
    await PowerShell.runAs(command);
    return await status();
  }

  Future<StatusService> create(String path) async {
    await PowerShell.runAs(path);
    String command =
        'Get-Service -Name "$name" | Set-Service -StartupType Automatic';
    await PowerShell.runAs(command);
    return await status();
  }

  Future<StatusService> delete() async {
    String command = 'Stop-Service -Name $name |  sc.exe delete $name';
    await PowerShell.runAs(command);
    return await status();
  }
}

class StatusLoop {
  Timer? _timer;
  int _elapsedTime = 0;
  void startLoop(String name, void Function(StatusService status) callback) {
    _timer = Timer.periodic(
      const Duration(milliseconds: 500),
      (timer) async {
        StatusService status = await WindowsServicePs(name).status();

        if (!status.name.toLowerCase().contains('pending') ||
            _elapsedTime >= 30) {
          _timer?.cancel();
          callback(status);
        } else {
          _elapsedTime++;
        }
      },
    );
  }

  void stopLoop() {
    _timer?.cancel();
  }
}

enum StatusService {
  stopped,
  startPending,
  stopPending,
  running,
  continuePending,
  pausePending,
  paused,
  unistalled
}
