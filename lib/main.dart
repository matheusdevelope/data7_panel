import 'package:data7_panel/pages/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';
import 'custom_theme.dart';
import 'providers/theme_model.dart';

void main() {
  Wakelock.enable();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeModel(),
      child: Consumer<ThemeModel>(
        builder: (context, _, c) {
          return LayoutBuilder(
            builder: (_, c) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Painel Data7',
                theme: CustomTheme.getTheme(context, c.maxWidth),
                home: const HomePage(title: 'Painel Data7'),
              );
            },
          );
        },
      ),
    );
  }
}
