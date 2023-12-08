import 'package:data7_panel/dependecy_injection.dart';
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

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  MediaKit.ensureInitialized();
  await Wakelock.enable();
  Dependencies.init();
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
                            iconTheme: const IconThemeData(color: Colors.blue),
                          ),
                    navigatorKey: navigatorKey,
                    home: const Scaffold(
                      body: Center(
                        child: Column(
                          children: [
                            Text('Hello World'),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
