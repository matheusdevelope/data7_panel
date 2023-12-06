import 'dart:io';

class PowerShell {
  static Future<dynamic> runAs(String command) async {
    var powerShellCommand = 'powershell.exe';
    var powerShellArguments = [
      '-NoProfile',
      '-ExecutionPolicy',
      'Unrestricted',
      '-Command',
      shellArgument(
          '& {Start-Process PowerShell -WindowStyle hidden -ArgumentList ""${shellArgument('-WindowStyle hidden -NoProfile -ExecutionPolicy Unrestricted  -Command ${shellArgument(command)}')} -Verb RunAs}',
          quote: '"')
    ];
    String cmd = "$powerShellCommand ${powerShellArguments.join(" ")}";
    try {
      var ret = await Process.run(
        cmd,
        [],
      );
      if (ret.stderr.toString().isNotEmpty) {
        throw ret.stderr.toString();
      }
      return ret.stdout.toString();
    } catch (e) {
      rethrow;
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
      if (ret.stderr.toString().isNotEmpty) {
        throw ret.stderr.toString();
      }
      return ret.stdout.toString();
    } catch (e) {
      return e.toString();
    }
  }
}

String shellArgument(String argument, {String quote = '""'}) {
  return quote + argument + quote;
}
