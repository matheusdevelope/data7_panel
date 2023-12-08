import 'dart:io';
import 'dart:typed_data';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as p;

import 'package:data7_panel/infra/services/Interfaces/audio_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:data7_panel/infra/services/Models/audio.dart';

class DiskAudioManager implements IAudioManager {
  Directory? _baseDir;
  DiskAudioManager() {
    _init();
  }

  @override
  Future<Audio> save(String path) async {
    await _init();
    File curentFile = File(path);
    File file = await curentFile
        .copy(p.join(_baseDir!.path, p.basename(curentFile.path)));
    return Audio(path: file.path);
  }

  @override
  Future<Audio> saveBytes(
      {required String filename, required ByteData data}) async {
    await _init();
    File file = File(p.join(_baseDir!.path, filename));
    await file.writeAsBytes(
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
    return Audio(path: file.path);
  }

  @override
  Future<bool> delete(String path) async {
    await _init();
    File curentFile = File(path);
    return curentFile.delete().then((value) => true).catchError((e) => false);
  }

  @override
  Future<Audio?> find(String path) async {
    await _init();
    File curentFile = File(path);
    if (!curentFile.existsSync()) return null;
    return Audio(path: curentFile.path);
  }

  @override
  Future<bool> exists(String path) async {
    await _init();
    File curentFile = File(path);
    return curentFile.existsSync();
  }

  @override
  Future<Audio> list() async {
    await _init();
    List<FileSystemEntity> list =
        Directory(_baseDir!.path).listSync(recursive: true, followLinks: false);
    return Audio(path: list.first.path);
  }

  _init() async {
    if (_baseDir != null) return;
    final path = '${(await getApplicationSupportDirectory()).path}/songs/';
    _baseDir = Directory(path);
    if (!_baseDir!.existsSync()) {
      _baseDir!.create(recursive: true);
    }
  }
}
