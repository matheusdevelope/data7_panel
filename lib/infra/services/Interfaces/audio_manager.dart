import 'dart:typed_data';

import 'package:data7_panel/infra/services/Models/audio.dart';

abstract class IAudioManager {
  Future<Audio> save(String path);
  Future<Audio> saveBytes({required String filename, required ByteData data});
  Future<bool> delete(String path);
  Future<Audio?> find(String path);
  Future<bool> exists(String path);
  Future<Audio> list();
}
