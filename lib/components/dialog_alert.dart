import 'package:flutter/material.dart';

class CustomDialogAlert {
  final String? defaultTitle;
  final String? defaultMessage;
  List<CustomDialogAction>? actions;
  final Function? onClose;

  CustomDialogAlert({
    this.defaultTitle,
    this.defaultMessage,
    this.actions,
    this.onClose,
  });

  void show(BuildContext context, String? title, String? message) {
    List<Widget> actionList = [
      TextButton(
        child: const Text('Ok'),
        onPressed: () {
          Navigator.of(context).pop();
        },
      )
    ];
    if (actions != null) {
      actionList = actions!
          .map((action) => TextButton(
                child: Text(action.label),
                onPressed: () {
                  action.onPress();
                },
              ))
          .toList();
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title ?? defaultTitle ?? "Atenção!"),
          content: Text(message ?? defaultMessage ?? ""),
          actions: actionList,
        );
      },
    );
  }

  void close(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop('dialog');
    if (onClose != null) onClose!();
  }
}

class CustomDialogAction {
  final String label;
  final Function onPress;
  CustomDialogAction({required this.label, required this.onPress});
}
