import 'package:data7_panel/old/components/settings/settings_category.dart';
import 'package:data7_panel/old/services/github_releases.dart';
import 'package:flutter/material.dart';

class DownloadBox extends StatefulWidget {
  final String title;
  final String subtitle;
  final Function onDownload;
  const DownloadBox({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onDownload,
  });
  @override
  State<DownloadBox> createState() => _DownloadBoxState();
}

class _DownloadBoxState extends State<DownloadBox> {
  double _percentualDownload = 0;
  bool checked = false;
  _checkExecutavekArquivo() async {
    final checker = GitHubReleaseChecker(
        'https://api.github.com/repos/matheusdevelope/service-panel');
    bool hasRelease = await checker.checkLatestRelease();
    if (hasRelease) {
      await checker.downloadLatestRelease(
        (progress) {
          widget.onDownload(progress);
          setState(() {
            _percentualDownload = progress;
          });
        },
      );
    } else {
      setState(() {
        _percentualDownload = 100;
        widget.onDownload(100);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!checked) {
      _checkExecutavekArquivo();
      setState(() {
        checked = true;
      });
    }
    return SettingsCategory(
      title: widget.title,
      subtitle: widget.subtitle,
      expansible: false,
      child: [
        Text("Download ${_percentualDownload.toInt()} % Concluído"),
        LinearProgressIndicator(
          value: _percentualDownload,
        )
      ],
    );
  }
}
