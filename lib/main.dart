import 'package:data7_panel/dependecy_injection.dart';
import 'package:data7_panel/infra/api/Http/http_client.dart';
import 'package:data7_panel/infra/services/Models/github_release.dart';
import 'package:data7_panel/providers/WindowsService/windows_service_model.dart';
import 'package:data7_panel/providers/theme/theme_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:media_kit/media_kit.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';
import 'custom_theme.dart';

GetIt getIt = GetIt.instance;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  MediaKit.ensureInitialized();
  await Wakelock.enable();
  Dependencies.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key}) {
    final githubChecker = GitHubReleaseChecker(
      httpClient: DI.get<IHttpClient>(),
      user: 'matheusdevelope',
      repo: 'service-panel',
    );

    githubChecker.on(GitHubEvents.updateAvailable, (data) {
      print('updateAvailable');
      print(data);
    });

    githubChecker.on(GitHubEvents.updateNotAvailable, (data) {
      print('updateNotAvailable');
      print(data);
    });

    githubChecker.on<GitHubRelease>(GitHubEvents.updateDownloaded, (data) {
      print('updateDownloaded');
      print(data.toJson());
    });

    githubChecker.on(GitHubEvents.updateDownloadProgress, (data) {
      print('updateDownloadProgress');
      print(data);
    });

    githubChecker.on(GitHubEvents.error, (data) {
      print('error');
      print(data);
    });

    githubChecker.checkForUpdates().then((value) {
      print('checkForUpdates done');
      githubChecker.currentFile.then((value) {
        print('currentFile');
        print(value);
      });
      print(githubChecker.version);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.select): const ActivateIntent(),
      },
      child: ChangeNotifierProvider(
        create: (_) => WindowsServiceProvider(),
        child: ChangeNotifierProvider(
          create: (_) => ThemeModel(),
          child: Consumer<ThemeModel>(
            builder: (context, them, c) {
              return LayoutBuilder(
                builder: (_, c) {
                  return MaterialApp(
                      debugShowCheckedModeBanner: false,
                      title: 'Painel Data7',
                      theme: them.useAdaptiveTheme
                          ? CustomTheme.getTheme(context, c.maxWidth)
                          : ThemeData.light().copyWith(
                              iconTheme:
                                  const IconThemeData(color: Colors.blue),
                            ),
                      home: const Scaffold(
                        body: Center(
                          child: Column(
                            children: [
                              Text('Hello World'),
                              // WinFirewalConsumer(),
                            ],
                          ),
                        ),
                      ));
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
