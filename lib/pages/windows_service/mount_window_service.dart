import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class FileWindowService {
  Future<String> create(BuildContext context, String serviceName,
      Map<String, String> configParams) async {
    Map<String, dynamic> manifest =
        await loadFilesFromAssetsToLocalResources(context);
    List<String> filesServiceAssets = getServiceRunnerPaths(manifest);
    List<String> filesServiceRunner =
        await saveFilesIntoServiceRunner(filesServiceAssets);
    File srvStart =
        File("${(await FileWindowService.getServiceRunnerDir())}/SRVSTART.ini");
    Directory serviceDir =
        Directory('${await FileWindowService.getServiceRunnerDir()}/service/');
    String pathService = serviceDir.listSync().first.path;
    String params = ' ';
    configParams.forEach((key, value) {
      params += '--$key $value ';
    });
    String content = '[$serviceName]\n';
    content += "startup=$pathService $params";
    srvStart.writeAsStringSync(content);
    filesServiceRunner.add(srvStart.path);
    String command =
        "${filesServiceRunner.firstWhere((element) => p.basename(element).toLowerCase() == 'srvstart.exe')} install $serviceName -c ${srvStart.path}";

    return command;
  }

  static getServiceExecutable() async {
    Directory serviceDir = Directory(
        '${await FileWindowService.getServiceRunnerDir()}\\service\\');
    String pathService = serviceDir.listSync().first.path;
    return pathService ?? '';
  }

  Future<List<String>> saveFilesIntoServiceRunner(
      List<String> filesServiceAssets) async {
    List<String> files = [];
    for (var element in filesServiceAssets) {
      ByteData bytes = await rootBundle.load(element);
      String path =
          '${await FileWindowService.getServiceRunnerDir()}${p.basename(element)}';
      File file = File(path);
      if (file.existsSync()) {
        files.add(file.path);
      } else {
        files.add(await writeToFile(bytes, path));
      }
    }
    return files;
  }

  static Future<String> getServiceRunnerDir() async {
    return '${(await getApplicationSupportDirectory()).path}\\service_runner\\';
  }

  static Future<String> writeToFile(ByteData data, String path) async {
    final buffer = data.buffer;
    await Directory(p.dirname(path)).create(recursive: true);
    File file = await File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
    return file.path;
  }

  loadFilesFromAssetsToLocalResources(BuildContext context) async {
    var assetsFile =
        await DefaultAssetBundle.of(context).loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(assetsFile);
    return manifestMap;
  }

  List<String> getServiceRunnerPaths(Map<String, dynamic> assetPaths) {
    final filteredPaths = <String>[];

    assetPaths.forEach((key, value) {
      for (final path in value) {
        if (path.contains('assets/service_runner')) {
          filteredPaths.add(path);
        }
      }
    });

    return filteredPaths;
  }
}
