import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class GitHubReleaseChecker {
  final String repoUrl;
  final List<String> downloadedReleases = [];
  Map<String, dynamic>? latestRelease;

  GitHubReleaseChecker(this.repoUrl);

  Future<bool> checkLatestRelease() async {
    final response = await http.get(Uri.parse('$repoUrl/releases'));
    if (response.statusCode == 200) {
      final releases = jsonDecode(response.body);
      if (releases is List && releases.isNotEmpty) {
        final latestRelease = releases[0];
        final tagName = latestRelease['tag_name'];
        if (!downloadedReleases.contains(tagName)) {
          this.latestRelease = latestRelease;
          return true;
        }
      }
    }
    return false;
  }

  Future<void> downloadLatestRelease(Function(double) progressCallback) async {
    if (latestRelease != null) {
      final assets = latestRelease!['assets'];
      if (assets is List && assets.isNotEmpty) {
        final asset = assets[0];
        final downloadUrl = asset['browser_download_url'];
        final fileName = asset['name'];
        Dio dio = Dio();
        Directory dir = await getApplicationSupportDirectory();
        String path = '${dir.path}/service_runner/service/$fileName';
        if (!File(path).existsSync()) {
          dio.download(
            downloadUrl,
            path,
            onReceiveProgress: (actualBytes, totalBytes) {
              var percentage = actualBytes / totalBytes * 100;
              progressCallback(percentage);
            },
          );
        } else {
          progressCallback(100);
        }
      }
    }
  }

  void installExecutable() {
    if (latestRelease != null) {
      // Implement your installation logic here
      print('Installation logic goes here.');
    }
  }
}
