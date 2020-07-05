import 'package:flutter/material.dart';

/*
 * method to display confirmation dialog
 */
showConfirmationDialog(
  BuildContext context,
  String message,
) async {
  return await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Confirmation"),
        content: Text(message),
        actions: [
          FlatButton(
            key: const Key("cancel"),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text("Cancel"),
          ),
          FlatButton(
            key: const Key("confirm"),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text(
              "Confirm",
              style: TextStyle(color: Theme.of(context).errorColor),
            ),
          ),
        ],
      );
    },
  );
}
