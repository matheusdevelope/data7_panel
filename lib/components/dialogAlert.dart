import 'package:flutter/material.dart';

showAlertDialog(BuildContext context, String title, String message) {
  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: Text(message),
    actions: [
      TextButton(
        child: const Text("Ok"),
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pop('dialog');
        },
      ),
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
