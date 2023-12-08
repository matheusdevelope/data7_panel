import 'package:data7_panel/main.dart';
import 'package:flutter/material.dart';

class GlobalNavigator {
  static final progress = ValueNotifier<double>(0);

  static showAlertDialog({
    required String title,
    required Widget content,
  }) {
    showDialog(
      barrierDismissible: false,
      context: navigatorKey.currentContext!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: content,
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  static pop() {
    navigatorKey.currentState?.pop();
  }

  static popUntil(String routeName) {
    navigatorKey.currentState?.popUntil((route) {
      return route.settings.name == routeName;
    });
  }

  static showLoadingDialog({
    required String title,
    Widget content = const Center(
      heightFactor: 1,
      child: CircularProgressIndicator(),
    ),
  }) {
    showDialog(
      barrierDismissible: false,
      context: navigatorKey.currentContext!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: content,
        );
      },
    );
  }
}
