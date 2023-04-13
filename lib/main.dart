import 'package:data7_panel/pages/home/home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

const Map<int, Color> color = {
  50: Color(0xFF006B98),
  100: Color(0xFF006B98),
  200: Color(0xFF006B98),
  300: Color(0xFF006B98),
  400: Color(0xFF006B98),
  500: Color(0xFF006B98),
  600: Color(0xFF006B98),
  700: Color(0xFF006B98),
  800: Color(0xFF006B98),
  900: Color(0xFF006B98),
};
MaterialColor myColor = MaterialColor(0xFF006B98, color);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, c) {
        final width = c.maxWidth;
        var fontSize = 14.0;
        if (width <= 480) {
          fontSize = 16.0;
        } else if (width > 480 && width <= 960) {
          fontSize = 22.0;
        } else {
          fontSize = 28.0;
        }
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Painel Data7',
          theme: ThemeData(
            primarySwatch: myColor,
            textTheme: TextTheme(
              bodySmall: TextStyle(fontSize: fontSize - 4),
              bodyMedium: TextStyle(fontSize: fontSize - 2),
              bodyLarge: TextStyle(fontSize: fontSize),
              labelSmall: TextStyle(fontSize: fontSize - 4),
              labelMedium: TextStyle(fontSize: fontSize - 2),
              labelLarge: TextStyle(fontSize: fontSize),
              titleSmall: TextStyle(fontSize: fontSize),
              titleMedium: TextStyle(fontSize: fontSize - 2),
              titleLarge: TextStyle(fontSize: fontSize),
            ),
          ),
          home: const HomePage(title: 'Painel Data7'),
        );
      },
    );
  }
}
