import 'package:data7_panel/pages/home/home.dart';
import 'package:flutter/material.dart';
import 'package:wakelock/wakelock.dart';

void main() {
  Wakelock.enable();
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
MaterialColor myColor = const MaterialColor(0xFF006B98, color);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, c) {
        final width = c.maxWidth;
        var fontSizeFactor = 1.0;
        final devices = [
          {
            "device": "Mobile devices",
            "min": 320,
            "max": 480,
            "fontFactorSize": 1.0
          },
          {
            "device": "iPads, Tablets",
            "min": 481,
            "max": 768,
            "fontFactorSize": 1.2
          },
          {
            "device": "Small screens, laptops",
            "min": 769,
            "max": 1024,
            "fontFactorSize": 1.3
          },
          {
            "device": "Desktops, large screens",
            "min": 1025,
            "max": 1300,
            "fontFactorSize": 1.5
          },
          {
            "device": "Extra large screens, TV",
            "min": 1300,
            "max": 1600,
            "fontFactorSize": 1.8
          },
          {
            "device": "Extra large screens, TV",
            "min": 1601,
            "max": 5000,
            "fontFactorSize": 2.0
          },
        ];
        devices.forEach((device) {
          if (width >= double.parse(device['min'].toString()) &&
              width <= double.parse(device['max'].toString())) {
            fontSizeFactor = double.parse(device['fontFactorSize'].toString());
          }
        });

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Painel Data7',
          theme: ThemeData(
              primarySwatch: myColor,
              textTheme: Theme.of(context)
                  .textTheme
                  .apply(
                    fontSizeFactor: fontSizeFactor,
                    fontSizeDelta: 2.0,
                  )
                  .copyWith(
                      titleSmall: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(fontWeight: FontWeight.bold)
                          .apply(
                            fontSizeFactor: fontSizeFactor,
                            fontSizeDelta: 2.0,
                          ))),
          home: const HomePage(title: 'Painel Data7'),
        );
      },
    );
  }
}
