import 'package:flutter/material.dart';

class Modal {
  final String title;
  final Widget content;
  List<ModalAction>? actions;
  final Function? onClose;

  Modal({
    required this.title,
    required this.content,
    this.actions,
    this.onClose,
  });

  void show(BuildContext context) {
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
          title: Text(title),
          content: content,
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

class ModalAction {
  final String label;
  final Function onPress;
  ModalAction({required this.label, required this.onPress});
}
