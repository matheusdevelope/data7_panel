import 'dart:io';

import 'package:data7_panel/infra/api/Http/http_client.dart';
import 'package:events_emitter/events_emitter.dart';
import 'package:path_provider/path_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as p;

class GitHubAsset {
  int id;
  String name;
  String nameWithoutExtension;
  String extension;
  String label;
  String contentType;
  int size;
  DateTime createdAt;
  DateTime updatedAt;
  String browserDownloadUrl;

  GitHubAsset({
    required this.id,
    required this.name,
    required this.nameWithoutExtension,
    required this.extension,
    required this.label,
    required this.contentType,
    required this.size,
    required this.createdAt,
    required this.updatedAt,
    required this.browserDownloadUrl,
  });

  factory GitHubAsset.fromJson(Map<String, dynamic> json) => GitHubAsset(
        id: json["id"] ?? '',
        name: json["name"] ?? '',
        nameWithoutExtension: p.basenameWithoutExtension(json["name"] ?? ''),
        extension: p.extension(json["name"] ?? ''),
        label: json["label"] ?? '',
        contentType: json["content_type"] ?? '',
        size: json["size"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        browserDownloadUrl: json["browser_download_url"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "nameWithoutExtension": nameWithoutExtension,
        "extension": extension,
        "label": label,
        "content_type": contentType,
        "size": size,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "browser_download_url": browserDownloadUrl,
      };
}

class GitHubRelease {
  int id;
  String version;
  String name;
  DateTime createdAt;
  DateTime publishedAt;
  String body;
  List<GitHubAsset> assets;

  GitHubRelease({
    required this.id,
    required this.version,
    required this.name,
    required this.createdAt,
    required this.publishedAt,
    required this.body,
    required this.assets,
  });

  factory GitHubRelease.fromJson(Map<String, dynamic> json) {
    final assets = <GitHubAsset>[];
    for (var i = 0; i < json["assets"].length; i++) {
      assets.add(GitHubAsset.fromJson(json["assets"][i]));
    }

    return GitHubRelease(
      id: json["id"] ?? '',
      version: json["tag_name"] ?? '',
      name: json["name"] ?? '',
      createdAt: DateTime.parse(json["created_at"]),
      publishedAt: DateTime.parse(json["published_at"]),
      body: json["body"] ?? '',
      assets: assets,
    );
  }

  GitHubAsset? executableAsset() {
    return assets.firstWhere((element) => element.name.contains('.exe'));
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "version": version,
        "name": name,
        "created_at": createdAt.toIso8601String(),
        "published_at": publishedAt.toIso8601String(),
        "body": body,
        "assets": List<dynamic>.from(assets.map((x) => x.toJson())),
      };
}

enum GitHubEvents {
  error,
  checkingForUpdates,
  updateAvailable,
  updateNotAvailable,
  updateDownloaded,
  updateDownloadProgress
}

abstract class IGitHubReleaseChecker {
  IGitHubReleaseChecker({
    required httpClient,
    required user,
    required repo,
    required version,
  });
  Future<void> checkForUpdates();
  on<T>(GitHubEvents event, dynamic Function(T) callback);
}

class GitHubReleaseChecker {
  final _emitter = EventEmitter();
  late IHttpClient _httpClient;
  String url = 'https://api.github.com/repos/:user/:repo/releases';
  final String user;
  final String repo;
  late String _version;
  final List<GitHubRelease> releases = [];
  GitHubReleaseChecker({
    required httpClient,
    required this.user,
    required this.repo,
  }) {
    _httpClient = httpClient;
    url = url.replaceAll(':user', user).replaceAll(':repo', repo);
    _version = '0.0.0';
  }

  String get version => _version;

  Future<void> checkForUpdates() async {
    _version = await _currentVersion;
    try {
      await _checkForUpdates();
    } catch (e) {
      _emit(GitHubEvents.error, e);
    }
  }

  Future<void> _checkForUpdates() async {
    try {
      _emit(GitHubEvents.checkingForUpdates, null);
      final response = await _httpClient.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> json = response.data;
        for (var element in json) {
          releases.add(GitHubRelease.fromJson(element));
        }
        final latestRelease = release;
        if (latestRelease != null) {
          if (latestRelease.version.compareTo(version) > 0) {
            _emit(GitHubEvents.updateAvailable, latestRelease);
            _download(latestRelease);
          } else {
            _emit(GitHubEvents.updateNotAvailable, latestRelease);
          }
        } else {
          _emit(GitHubEvents.updateNotAvailable, latestRelease);
        }
        return;
      }
      throw Exception(
          'Erro ao carregar releases, status code: ${response.statusCode}, body: ${response.data}, url: $url . \n Verifique se o usuário e o repositório estão corretos.');
    } catch (e) {
      _emit(GitHubEvents.error, e);
    }
  }

  Future<void> _download(GitHubRelease release) async {
    final asset = release.executableAsset();
    final tempDir = await _tempDirectory;
    final currentDir = await _currentDirectory;

    final tempFile = p.join(tempDir.path,
        '${asset?.nameWithoutExtension}-${release.version}${asset?.extension}');
    final currentFile = p.join(currentDir.path,
        '${asset?.nameWithoutExtension}-${release.version}${asset?.extension}');
    if (asset != null) {
      if (File(currentFile).existsSync()) {
        // _emit(GitHubEvents.updateDownloaded, release);
        return;
      }
      final response = await _httpClient
          .download(asset.browserDownloadUrl, tempFile,
              onReceiveProgress: (count, total) {
        _emit(GitHubEvents.updateDownloadProgress, count / total * 100);
      });
      if (response.statusCode == 200) {
        currentDir.deleteSync(recursive: true);
        currentDir.createSync(recursive: true);
        File(tempFile).renameSync(currentFile);
        _setCurrentVersion(release.version);
        tempDir.deleteSync(recursive: true);
        _emit(GitHubEvents.updateDownloaded, release);
      }
    } else {
      _emit(GitHubEvents.error,
          'Não foi possível encontrar o executável na release.');
    }
  }

  GitHubRelease? get release =>
      releases.firstWhere((element) => element.version.compareTo(version) >= 0);

  on<T>(GitHubEvents event, dynamic Function(T) callback) {
    return _emitter.on(event.name, callback);
  }

  void _emit<T>(GitHubEvents event, T data) {
    _emitter.emit(event.name, data);
  }

  Future<Directory> get _downloadDirectory async {
    final dir = Directory(p.joinAll([
      (await getApplicationSupportDirectory()).path,
      'releases',
    ]));
    return dir;
  }

  Future<Directory> get _tempDirectory async {
    final dir = Directory(p.joinAll([
      (await _downloadDirectory).path,
      'temp',
    ]));
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }
    return dir;
  }

  Future<Directory> get _currentDirectory async {
    final dir = Directory(p.joinAll([
      (await _downloadDirectory).path,
      'current',
    ]));
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }
    return dir;
  }

  Future<String?> get currentFile async {
    final currentDir = await _currentDirectory;
    final files = currentDir.listSync();
    if (files.isEmpty) {
      return null;
    }
    return files
        .firstWhere(
          (element) => p.extension(element.path) == '.exe',
        )
        .path;
  }

  Future<String> get _currentVersion async {
    final currentDirectory = await _currentDirectory;
    final versionFile = currentDirectory.listSync().firstWhere(
        (element) => p.extension(element.path) == '.version',
        orElse: () => File('0.0.0.version'));
    return p.basenameWithoutExtension(versionFile.path);
  }

  _setCurrentVersion(String version) async {
    final file = File(p.joinAll([
      (await _currentDirectory).path,
      '$version.version',
    ]));
    file.writeAsStringSync(version);
  }
}
