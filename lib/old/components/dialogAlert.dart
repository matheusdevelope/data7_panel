import 'package:flutter/material.dart';

showAlertDialog(BuildContext context, String title, String message,
    {String closeButton = "Ok",
    String actionButton = "",
    VoidCallback? callback}) {
  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: Text(message),
    actions: [
      TextButton(
        child: Text(
            closeButton.toString().isEmpty ? "Ok" : closeButton.toString()),
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pop('dialog');
        },
      ),
      TextButton(
          child: Text(actionButton.toString()),
          onPressed: () {
            if (callback == null) {
            } else {
              callback();
            }
            Navigator.of(context, rootNavigator: true).pop('dialog');
          }),
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
