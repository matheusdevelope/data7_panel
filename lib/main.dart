import 'package:data7_panel/UI/pages/home/home.dart';
import 'package:data7_panel/UI/pages/panel/panel.dart';
import 'package:data7_panel/core/providers/Settings/settings_model.dart';
import 'package:data7_panel/core/providers/Theme/theme_model.dart';
import 'package:data7_panel/dependecy_injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:media_kit/media_kit.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';
import 'custom_theme.dart';

GetIt getIt = GetIt.instance;
Settings settings = Settings();

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  MediaKit.ensureInitialized();
  await Wakelock.enable();
  Dependencies.init();
  await settings.initialize();
  // await WindowsServiceDownloader.execute(
  //     httpClient: DI.get<IHttpClient>(),
  //     user: 'matheusdevelope',
  //     repo: 'service-panel');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.select): const ActivateIntent(),
      },
      child: ChangeNotifierProvider(
        create: (_) => settings.theme,
        child: Consumer<ThemeModel>(
          builder: (context, theme, _) {
            return LayoutBuilder(
              builder: (_, constraints) {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'Painel Data7',
                  theme: theme.useAdaptiveTheme
                      ? CustomTheme.getTheme(context, constraints.maxWidth)
                      : ThemeData.light().copyWith(
                          iconTheme: const IconThemeData(color: Colors.blue),
                        ),
                  navigatorKey: navigatorKey,
                  home: const HomePage(
                    title: 'Painel Data7',
                  ),
                  routes: {
                    '/panel': (context) => const PanelPage(),
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
