import 'package:data7_panel/pages/home/home.dart';
import 'package:data7_panel/providers/settings_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:media_kit/media_kit.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';
import 'custom_theme.dart';
import 'providers/theme_model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  MediaKit.ensureInitialized();
  Wakelock.enable();
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
        create: (_) => WinServiceSettings(),
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
                            iconTheme: const IconThemeData(color: Colors.blue)),
                    home: const HomePage(title: 'Painel Data7'),
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
