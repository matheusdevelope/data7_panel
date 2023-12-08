import 'dart:io';
import 'package:data7_panel/global_navigator.dart';
import 'package:data7_panel/infra/api/Http/http_client.dart';
import 'package:data7_panel/infra/services/Models/github_release.dart';
import 'package:flutter/material.dart';

class WindowsServiceDownloader {
  static Future<void> execute({
    required IHttpClient httpClient,
    required String user,
    required String repo,
  }) async {
    GitHubReleaseChecker githubChecker = GitHubReleaseChecker(
      httpClient: httpClient,
      user: user,
      repo: repo,
    );
    if (Platform.isWindows) {
      githubChecker.on(GitHubEvents.error, (error) {
        GlobalNavigator.showAlertDialog(
          title: "Erro ao buscar atualização do serviço.",
          content: Text(error.toString()),
        );
      });

      githubChecker.on<GitHubRelease>(
          GitHubEvents.updateAvailable, (release) => _showDialog(release));
      githubChecker.on<GitHubRelease>(
          GitHubEvents.updateDownloaded, (_) => _closeDialog());
      githubChecker.on<double>(GitHubEvents.updateDownloadProgress, (progress) {
        GlobalNavigator.progress.value = progress / 100;
      });
      githubChecker.checkForUpdates();
    }
  }

  static void _showDialog(GitHubRelease release) {
    GlobalNavigator.showLoadingDialog(
      title: "Atualização disponível, download em andamento...",
      content: ValueListenableBuilder<double>(
        valueListenable: GlobalNavigator.progress,
        builder: (context, value, _) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Versão disponível: ${release.version}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Progresso: ${(value * 100).toStringAsFixed(2)}%",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              LinearProgressIndicator(
                value: value,
              )
            ],
          );
        },
      ),
    );
  }

  static void _closeDialog() {
    GlobalNavigator.pop();
  }
}
